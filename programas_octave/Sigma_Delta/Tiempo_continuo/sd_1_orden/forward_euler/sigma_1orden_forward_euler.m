% Modelo de sigma-delta de primer orden con cálculo de SNR
%El integrador utiliza metodo de forward Euler para aproximar la integral
close all;
clear all;
clc;

% Configuración de parámetros
Fs = 256;           % Frecuencia de muestreo (Hz)
Ts = 1 / Fs;
Fin = 1;            % Frecuencia de la señal de entrada (Hz) - no armónica
N = 100;            % Número de ciclos a simular
BW = 1;             % Ancho de banda de interés (Hz)
OSR = Fs/(2*BW);    % Razón de sobremuestreo

% Tiempo de simulación
T = 1/Fin;          % Periodo de la señal de entrada
t = 0:1/Fs:N*T;     % Vector de tiempo

% Inicialización de variables
y = zeros(size(t)); % Salida del integrador
Q = zeros(size(t)); % Salida cuantificada (1 bit)
e = zeros(size(t)); % Señal de error
S = zeros(size(t)); % Señal de entrada

t_1 = t(1)
t_2 = t(2)

% Simulación del modulador sigma-delta
for i = 2:length(t)
    % Señal de entrada sinusoidal
    S(i-1) = sin(2*pi*Fin*t(i-1));

    % Señal de error (entrada - realimentación)
    e(i-1) = S(i-1) - Q(i-1);

    % Integrador por medio de forward euler
    y(i) = y(i-1) + ( Ts * e(i-1));

    % Cuantificador de 1 bit
    Q(i) = sign(y(i));
end

% Visualización de las señales en el tiempo
figure;
set(gca, "fontsize", 12, "fontweight", "bold");
subplot(2,1,1);
plot(t, S, 'r', t, Q, 'b');
title('Señal de entrada (rojo) y salida SD (azul)');
xlabel('Tiempo (s)');
ylabel('Amplitud');
legend('Entrada', 'Salida');
grid on;

%----------------------------------------------------------------
% Cálculo del espectro de frecuencia
%nfft = 2^nextpow2(length(Q));  % Tamaño de la FFT (potencia de 2)
%window = hanning(length(Q));   % Ventana de Hanning para reducir fugas espectrales

% FFT de la señal de salida (quitamos el componente DC)
%Q_fft = fft(Q.*window' - mean(Q), nfft)/length(Q);
%Pxx = abs(Q_fft(1:nfft/2+1)).^2;  % Densidad espectral de potencia

% Vector de frecuencias
%f = Fs/2*linspace(0,1,nfft/2+1);

% Encontrar el bin de la señal principal
##[~, sig_idx] = max(Pxx(2:end));  % Excluimos el componente DC
##sig_idx = sig_idx + 1;

% Definir bins que contienen ruido (excluyendo la señal y sus armónicos)
##noise_bins = [];
##harmonic_multiples = 1:5;  % Consideramos hasta el 5to armónico
##for h = harmonic_multiples
##    harmonic_idx = round(h*sig_idx);
##    % Excluimos ±5 bins alrededor de cada armónico
##    noise_bins = [noise_bins, 2:harmonic_idx-5, harmonic_idx+5:round(nfft/Fs*BW)];
##end
##noise_bins = unique(noise_bins(noise_bins > 1 & noise_bins <= round(nfft/Fs*BW)));

% Calcular potencias
##signal_power = sum(Pxx(sig_idx-2:sig_idx+2));  % Sumamos 5 bins alrededor de la frecuencia fundamental
##noise_power = sum(Pxx(noise_bins));

% Calcular SNR en dB
##SNR_dB = 10*log10(signal_power/noise_power);

% Visualización del espectro
##subplot(2,1,2);
##semilogx(f, 10*log10(Pxx));
##hold on;
##semilogx(f(sig_idx), 10*log10(Pxx(sig_idx)), 'ro', 'MarkerSize', 8);
##title(['Espectro de frecuencia - SNR = ', num2str(SNR_dB,2), ' dB']);
##xlabel('Frecuencia (Hz)');
##ylabel('Potencia (dB)');
##xlim([0.1 BW*2]);
##grid on;

% Mostrar resultados en consola
##disp(['Parámetros de la simulación:']);
##disp(['  Frecuencia de muestreo (Fs): ', num2str(Fs), ' Hz']);
##disp(['  Frecuencia de entrada (Fin): ', num2str(Fin), ' Hz']);
##disp(['  Razón de sobremuestreo (OSR): ', num2str(OSR)]);
##disp(['  Ancho de banda (BW): ', num2str(BW), ' Hz']);
##disp(' ');
##disp(['Resultados:']);
##disp(['  SNR calculada: ', num2str(SNR_dB,4), ' dB']);
##disp(['  SNR teórica (1er orden): ~', num2str(30*log2(OSR)-20*log2(pi/sqrt(2))+3,4), ' dB']);

%------------------------------------------------------------------------------------------------
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


##%Vector para graficar en frecuencia, figura, y graficar en dB en base a x (x = frecuencia)
x=[Fs/L:Fs/L:Fs];
figure(1);
semilogx(x,magodB,'-*k');
%plot(x,magodB,'k');
set(gca, "fontsize", 16, "fontweight", "bold");
%xlim([Fs/L Fs/2]);
xlim([10^-1 2]);
grid on;
xlabel("Frequency (Hz)");
ylabel("PSD (dB)");

#Figura 2 depsliega la frecuencia contra la amplitud de la senal mago = abs(complexo)./L
figure(2);
%semilogx(x,magodB,'-*k');
plot(x,mago,'-*k');
grid on;
xlim([10^-1 2]);
xlabel("Frequency (Hz)");
ylabel("Amplitud");

%Calculo de la SNR usando la formula para senales sobremuestreadas
%de un modulador sigma delta de primer orden
%the peak SQNR for a full scale input is given by
%SQNR peak   ~= (9 * M^2 * OSR^3) / 2*pi^2
%La SQNR es la SNR sin considerar no idealidades
%En este caso no consideramos no idealidades
%SNR = SQNR = SQNR de un modulador sigma delta 1 bit de primer orden
% SQNR = SNR_peak ~= (9 * M^2 * OSR^3) / 2*pi^2
%M representa el numero de pasos del cuantificador
%En el limite M = 1 es un cuantificador de 1 bit (como que usamos en este ejemplo)
%entonces podemos omitir escribir la variable M en este caso
SNR_teorica_maxima = 10*log10((9 * OSR^3) / (2*pi^2));
disp(['SNR teorica maxima (SQNR): ', num2str(SNR_teorica_maxima), ' dB']);

% También podemos calcular la SNR "empíricamente" desde el espectro
% Encontrar el bin de la frecuencia de entrada
[~, fin_idx] = min(abs(x - Fin));
fin_idx = fin_idx + 1

#Con la siguiente linea comprobamos que la suma de los 5 elementos centrales nos da un aproximado de
# 0.3536 que es aprox la amplitud de la senal de entrada
Amp_fin_idx = mago(fin_idx - 2) + mago(fin_idx - 1) + mago(fin_idx) + mago(fin_idx + 1) +  mago(fin_idx + 2)

AmpdB_fin_idx = magodB(fin_idx - 2) + magodB(fin_idx - 1) + magodB(fin_idx) + magodB(fin_idx + 1) +  magodB(fin_idx + 2)

#Signal power - Potencia de la senal
signal_power = mago(fin_idx - 2)^2 + mago(fin_idx - 1)^2 + mago(fin_idx)^2 + mago(fin_idx + 1)^2 + mago(fin_idx + 2)^2;

% Estimar el ruido en la banda de interés (excluyendo la señal)
noise_bins = [1:fin_idx-3, fin_idx+3:104];
noise_power = sum(mago(noise_bins).^2);

% Calcular SNR empírica
SNR_empirica = 10*log10(signal_power/noise_power);
disp(['SNR empírica: ', num2str(SNR_empirica), ' dB']);




