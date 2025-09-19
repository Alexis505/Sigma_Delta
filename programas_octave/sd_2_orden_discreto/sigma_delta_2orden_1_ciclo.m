%Modelo de primer orden
close all;
clear all;
%Frecuecia de muestreo:
Fs=50;
%Numero de ciclos:
N=1;
%Frecuencia de entrada:
%Fin=1/(2*sqrt(2));
Fin=1
%Periodo:
T=1/Fin
%Ancho de Banda:
BW=1
%Frecuencia de Nyquist:
Fn=BW*2
%Factor de sobre muestreo:
OSR=Fs/Fn %OSR = 64

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
figure;
set(gca, "fontsize", 16, "fontweight", "bold");
hold on;
plot(t,Q,"b", 'LineWidth',1);
plot(t,S,"r", 'LineWidth',2);
%plot(t,y,"m");
%plot(t,r,"g");
grid on;


##    ESPECTRO
##
L=length(t);
%Ventana de blackman de longitud L
W=blackman(L);
W=W';
Ho=W.*Q;

#Transformada rapida de fourier de Ho, magnitud y magnitud en dB
complexo=fft(Ho);
mago=abs(complexo)./L;
magodB=20.*log10(mago);

##%Vector para graficar en frecuencia, figura, y graficar en en dB en base a x (x = frecuencia)
x=[Fs/L:Fs/L:Fs];
figure;
semilogx(x,magodB,'-*k');
%plot(x,magodB,'k');
set(gca, "fontsize", 16, "fontweight", "bold");
xlim([Fs/L Fs/2]);
grid on;
xlabel("Frequency (Hz)");
ylabel("PSD (dB)");
%print -djpg espectro.jpg;


