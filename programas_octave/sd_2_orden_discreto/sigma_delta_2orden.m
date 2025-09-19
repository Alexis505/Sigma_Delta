%Modelo de primer orden
close all;
clear all;
%Frecuecia de muestreo:
Fs=256;
%Numero de ciclos:
N=64;
%Frecuencia de entrada:
Fin=1/(2*sqrt(2));
%Periodo:
T=1/Fin
%Ancho de Banda:
BW=1
%Frecuencia de Nyquist:
Fn=BW*2
%Factor de sobre muestreo:
OSR=Fs/Fn %OSR = 128
%Ganancia
K = 0.5

% Tiempo de simulacion:
t=[0:1/Fs:T*N];

% Establecemos las variables como vectores con todos los elementos inicializados en 0
for i=1:length(t)
    %Variable para primera etapa de integracion
    y1(i)=0;
    %Senal de cuantificador puede ser  1,0,-1
    Q(i)=0;
    %Variable para representar resta entre senal de entrada y salida de cuantificador
    r1(i)=0;
    %variable r1 multiplicada por el factor "k"
    r1_k(i)=0;
    %variable S para representar la senal de entrada
    S(i)=0;
    %Variable para representar la resta entre la salida del integrador 1 y la salida del cuantificador
    r2(i)=0;
    %variable r2 multiplicada por el factor "k"
    r2_k(i)=0;
    %Variable para integracion de 2 orden
    y2(i)=0;
endfor

for i=2:length(t)
    %Senal de entrada:
    S(i-1)=(1/sqrt(2)).*sin(2.*pi.*Fin.*t(i-1));
    %Restas
    r1(i-1)=S(i-1)-Q(i-1);
    r1_k(i-1)=K*r1(i-1);
    %Integrador:
    y1(i)=y1(i-1)+r1_k(i-1);
    %Resta 2 orden
    r2(i-1)=y1(i-1) - Q(i-1);
    r2_k(i-1) = K*r2(i-1);
    %Integrador 2orden
    y2(i)=y2(i-1)+r2_k(i-1);
    %Comparador
    Q(i)=sign(y2(i));
endfor

#Codigo para pinta en un grafica la senal de entrada S y la senal de cuantificacion Q
%figure(3);
%set(gca, "fontsize", 16, "fontweight", "bold");
%hold on;
%plot(t,Q,"b", 'LineWidth',1);
%plot(t,S,"r", 'LineWidth',2);
%plot(t,y,"m");
%plot(t,r,"g");

##    ESPECTRO

L=length(t);
%Ventana de blackman de longitud L
W=blackman(L);
W=W';
Ho=W.*Q;

#Transformada rapida de fourier de Ho, magnitud y magnitud en dB
complexo=fft(Ho);
mago=abs(complexo)./L;
magodB=20.*log10(mago);

##%Vector para graficar en frecuencia, figura, y graficar en dB en base a x (x = frecuencia)
x=[Fs/L:Fs/L:Fs];

#Figura 1 depsliega la frecuencia contra la amplitud de la senal mago = abs(complexo)./L
#la primera parte en el rango de 0 a 257 herts (veremos dos picos en los extremos de la grafica)
#la segunda y tercer sub grafica hace el plot de la magnitud
#en rangos de 1 hert, con el objetivo de poder observar la magnitud de los 5 bines mas claramente
figure(1);
subplot(3,1,1)
plot(x,mago,'-*k');
%set(gca, "fontsize", 16, "fontweight", "bold");
xlim([0 257]);
grid on;
xlabel("Frequency (Hz)");
ylabel("Amplitud");

subplot(3,1,2);
plot(x,mago,'-*k');
grid on;
xlim([0 10^0]);
xlabel("Frequency (Hz)");
ylabel("Amplitud");

subplot(3,1,3);
plot(x,mago,'-*k');
grid on;
xlim([255 256]);
xlabel("Frequency (Hz)");
ylabel("Amplitud");

#Figura 2
#En esta figura la frecuencia va en escala logaritmica
% y la potencia se expresa en decibeles
figure(2);
subplot(3,1,1)
semilogx(x,magodB,'-*k');
xlim([Fs/L  Fs]);
grid on;
xlabel("Frequency (Hz)");
ylabel("PSD (dB)");

subplot(3,1,2)
semilogx(x,magodB,'-*k');
xlim([0.1 1]);
grid on;
xlabel("Frequency (Hz)");
ylabel("PSD (dB)");

subplot(3,1,3)
semilogx(x,magodB,'-*k');
xlim([255 256]);
grid on;
xlabel("Frequency (Hz)");
ylabel("PSD (dB)");

%Calculo de la SNR usando la formula para senales sobremuestreadas
%SNR_teorica ~= 10*log10((15 * OSR^5) / (2*pi^4))
SNR_teorica = 10*log10((15 * OSR^5) / (2*pi^4));
disp(['SNR teorica: ', num2str(SNR_teorica), ' dB']);

% También podemos calcular la SNR "empíricamente" desde el espectro
% Encontrar el bin de la frecuencia de entrada
[~, fin_idx] = min(abs(x - Fin));
fin_idx = fin_idx + 1;

#Con la siguiente linea comprobamos que la suma de los 5 elementos centrales nos da un aproximado de
# 0.3536 que es aprox la amplitud de la senal de entrada
Amp_fin_idx = mago(fin_idx - 2) + mago(fin_idx - 1) + mago(fin_idx) + mago(fin_idx + 1) +  mago(fin_idx + 2)

#Signal power - Potencia de la senal
signal_power = mago(fin_idx - 2)^2 + mago(fin_idx - 1)^2 + mago(fin_idx)^2 + mago(fin_idx + 1)^2 + mago(fin_idx + 2)^2;

% Estimar el ruido en la banda de interés (excluyendo la señal)
noise_bins = [1:fin_idx-3, fin_idx+3:128];
noise_power = sum(mago(noise_bins).^2);

% Calcular SNR empírica
SNR_empirica = 10*log10(signal_power/noise_power);
disp(['SNR empírica: ', num2str(SNR_empirica), ' dB']);

