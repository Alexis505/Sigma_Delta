    % Simulación de un modulador sigma-delta de primer orden
    % Usando el metodo de integración Trapezoidal.
    close all
    clear all
    % f_in: frec. de la señal de entrada
    f_in = 1;
    % Ancho de banda:
    BW = f_in*2;
    % Frec. de Nyquist:
    Fnyq = BW*2;
    % Tiempo de simulación:
    T = 1;
    % fs: frec. de muestreo:
    fs = 32;
    % Factor de sobre muestreo:
    OSR = fs/Fnyq
    % Periodo de muestreo:
    Ts = 1/fs;
    
    % Generamos la señal de entrada: 
    t=[0:Ts:T];
    for i=1:length(t)
        % x: señal de entrada:
        x(i)= sin(2*pi*t(i));
     endfor

    % dt: paso de tiempo (se recomienda 20 veces menor al periodo de muestreo):
    dt = 1/(20*fs);

    % Longitud de simulacion
    L = length(t);
    y = zeros(1, L);      % Salida del integrador
    bits = zeros(1, L);   % Salida digital (bits)

    % Inicialización
    y(1) = 0;
    bits(1) = -1;

         % Modelamos el lazo de Retroalimentación Negativa:

     for k = 1:L-1

        % Retroalimentación: resta la salida cuantizada
        resta = x(k) - bits(k);
        
        % Integrador (método trapezoidal)
        y(k+1) = y(k) + (dt/2) * (resta + (x(k+1) - bits(k)));
        
        % Cuantización
        bits(k+1) = sign(y(k+1));
    
    endfor

figure;

set(gca, "fontsize", 16, "fontweight", "bold");
hold on; 
plot(t,x,"g", 'LineWidth',3);
%Pongo la leyenda a los datos:
legend("Señal de entrada", "location", 'northwest');
%En una variable guardo la configuración de "legend":
h=legend;
% Asigno directamente las propiedades de tipo y tamaño de letra:
set(h, "fontname", "arial", "fontsize", 12, "fontweight", "bold");
plot(t,bits,"b", 'LineWidth',1, "displayname", "Salida Digital");
ylim([-1.5, 1.5]);
grid on;

figure;
set(gca, "fontsize", 16, "fontweight", "bold");
plot(t,y,"r", 'LineWidth',2);
%Pongo la leyenda a los datos:
legend("Salida del integrador", "location", 'northwest');
%En una variable guardo la configuración de "legend":
h=legend;
% Asigno directamente las propiedades de tipo y tamaño de letra:
set(h, "fontname", "arial", "fontsize", 12, "fontweight", "bold");
grid on;
