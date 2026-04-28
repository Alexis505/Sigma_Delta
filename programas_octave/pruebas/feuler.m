%%%
%Simula el comportamiento de un integrador
%en tiempo continuo (CTI) usando la
%aprox. de Euler. La FT del CTI es
% "1/s"
close all;
clear all;
%Frecuecia de muestreo:
Fs=10
%Periodo de muestreo:
Ts=1/Fs
%Resistencia
R=1
%Capacidad
C=1
%Numero de ciclos:
N=2
%Frecuencia de entrada:
Fin=1/(2*pi)
%Fin = 0.1592
%Periodo de entrada:
T=1/Fin
%6.2814
%Ancho de Banda:
BW=1/(pi*2)
% BW = 0.1592
%Frecuencia de Nyquist:
Fn=BW*2
%Fn = 0.3184
%Factor de sobre muestreo:
OSR=Fs/Fn
%OSR = 31.47
% Tiempo de simulaci�n:
t=[0:1/Fs:T*N];
% t = [0 : 0.1 : 12.56] va desde 0 hasta 12.56 en pasos de 0.1
% es decir "t" es un vector de aprox 125 pasos

%ciclo for para inicializar vectores de longitud 125 para la senal
%de entrada y la señal integrada
x = zeros(1, length(t));
y = zeros(1, length(t));

%inicializamos valor de x(1) en 1
x(1) = cos(2.*pi.*Fin.*t(1));


%ciclo for para colocar valores cosenoidales en el vector de entrada x(i)
% y para colocar valores en el vector de integracion usando aproximacion de Euler
for i=2:length(t)
%Senal de entrada:
x(i)=cos(2.*pi.*Fin.*t(i));
%Paso de Integracion utlizando aproximacion de Euler
y(i)=y(i-1)+(Ts*x(i-1));
endfor

figure;
subplot(2,1,1);
set(gca, "fontsize", 16, "fontweight", "bold");
hold on;
stem(t,x,"r", 'LineWidth',2, "markersize", 8, 'markerfacecolor', "r");
legend ("Signal");

subplot(2,1,2)
stem(t,y,"b", 'LineWidth', 2, 'markerfacecolor', "b");
legend ("Salida integrador");
grid on;






