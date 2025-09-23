import numpy as np
import matplotlib.pyplot as plt

# Simula el comportamiento de un integrador
# en tiempo continuo (CTI) usando la
# aprox. de Euler. La FT del CTI es "1/s"

# Frecuencia de muestreo:
Fs = 10
# Periodo de muestreo:
Ts = 1 / Fs #0.1
# Resistencia
R = 1
# Capacidad
C = 1
# Numero de ciclos:
N = 2
# Frecuencia de entrada:
Fin = 1 / (2 * np.pi)  #0.1591
# Periodo de entrada:
T = 1 / Fin  #6.28
# Ancho de Banda:
BW = 1 / (np.pi * 2)
# Frecuencia de Nyquist:
Fn = BW * 2
# Factor de sobre muestreo:
OSR = Fs / Fn

# Tiempo de simulación:
t = np.arange(0, T * N, Ts)

# Inicializar arrays
x = np.zeros(len(t))
y = np.zeros(len(t))

for i in range(1, len(t)):
    # Señal de entrada:
    x[i] = np.cos(2 * np.pi * Fin * t[i-1])
    
    # Señal integrada:
    # Integrador usando Euler:
    y[i] = y[i-1] + (Ts * x[i-1])

# Crear figura con subplots
plt.figure(figsize=(12, 8))

# Primer subplot - señal de entrada
plt.subplot(2, 1, 1)
#plt.stem(t, x, 'r', linewidth=2, markerfmt='ro', basefmt=" ")
plt.stem(t, x, 'r', markerfmt='ro', basefmt=" ")
plt.title('Señal de entrada', fontsize=16, fontweight='bold')
plt.legend(['Signal'])
plt.grid(True)

# Segundo subplot - salida del integrador
plt.subplot(2, 1, 2)
#plt.stem(t, y, 'b', linewidth=2, markerfmt='bo', basefmt=" ")
plt.stem(t, y, 'b', markerfmt='bo', basefmt=" ")
plt.title('Salida integrador', fontsize=16, fontweight='bold')
plt.legend(['Salida integrador'])
plt.grid(True)

plt.tight_layout()
plt.show()

# Mostrar información de la simulación
print(f"Frecuencia de muestreo: {Fs} Hz")
print(f"Periodo de muestreo: {Ts} s")
print(f"Frecuencia de entrada: {Fin:.4f} Hz")
print(f"Factor de sobre muestreo (OSR): {OSR:.2f}")

