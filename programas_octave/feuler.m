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
%Periodo de entrada:
T=1/Fin
%Ancho de Banda:
BW=1/(pi*2)
%Frecuencia de Nyquist:
Fn=BW*2
%Factor de sobre muestreo:
OSR=Fs/Fn
% Tiempo de simulaci�n:
t=[0:1/Fs:T*N];
for i=1:length(t)
% Input Signal
x(i)=0;
% Integrated signal
y(i)=0;
endfor
for i=2:length(t)
%Senal de entrada:
x(i)=cos(2.*pi.*Fin.*t(i-1));
%Senal integrada:
%Integrador:
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






