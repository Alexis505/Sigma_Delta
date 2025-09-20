#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Wed Sep 17 18:05:36 2025

@author: alexis_silva
"""

import numpy as np
import matplotlib.pyplot as plt
from scipy.signal.windows import blackman

# Modelo de primer orden con k=0.5
# Se simulan 300 ciclos para sacar FFT

# Frecuencia de muestreo:
Fs = 250e3
# Número de ciclos:
N = 300
# Frecuencia de entrada:
Fin = 62.4789
# Periodo:
T = 1/65
# Factor de sobre muestreo:
OSR = Fs/(2*Fin)
# Ganancia del integrador
k = 0.5

print(f"Periodo T: {T}")
print(f"Factor de sobre muestreo OSR: {OSR}")
print(f"Ganancia del integrador k: {k}")

# Tiempo de simulación:
t = np.arange(0, T * N, 1/Fs)

# Inicializar arrays
n = len(t)
y = np.zeros(n)
Q = np.zeros(n)
r = np.zeros(n)
S = np.zeros(n)
m = np.zeros(n)

# Simulación
for i in range(1, n):
    # Señal de entrada:
    S[i-1] = np.sin(2 * np.pi * Fin * t[i-1])
    # Restas
    r[i-1] = S[i-1] - Q[i-1]
    # Multiplicacion por k:
    m[i-1] = r[i-1] * k
    # Integrador:
    y[i] = y[i-1] + m[i-1]
    # Comparador
    Q[i] = np.sign(y[i])

# Cálculo del espectro
L = len(t)
# Ventana de Blackman de longitud L
W = blackman(L)
Ho = W * Q
complexo = np.fft.fft(Ho)
mago = np.abs(complexo) / L
magodB = 20 * np.log10(mago + 1e-12)  # Evitar log(0) añadiendo un pequeño valor

# Vector para graficar en frecuencia
x = np.arange(Fs/L, Fs, Fs/L)
# Asegurarse de que los vectores tengan la misma longitud
min_len = min(len(x), len(magodB))
x = x[:min_len]
magodB = magodB[:min_len]

# Graficar
plt.figure(figsize=(10, 6))
plt.semilogx(x, magodB, 'k')
plt.axis([Fs/L, Fs/2, -200, -10])
plt.grid(True)
plt.xlabel("Frequency (Hz)")
plt.ylabel("PSD (dB)")
plt.title("Espectro de frecuencia")
plt.show()

# Opcional: Graficar histograma de la salida del integrador
plt.figure(figsize=(10, 6))
plt.hist(y, bins=50)
plt.ylim([0, 1400])
plt.grid(True)
plt.xlabel("Integrator Output Level (V)")
plt.ylabel("Number of Occurrences")
plt.title("Histograma de la salida del integrador")
plt.show()

# Opcional: Graficar las señales en el tiempo (solo un segmento para mejor visualización)
plt.figure(figsize=(12, 8))
plt.plot(t[:1000], Q[:1000], 'b', label='Q (Salida digital)')
plt.plot(t[:1000], S[:1000], 'r', label='S (Entrada)')
plt.plot(t[:1000], y[:1000], 'm', label='y (Integrador)')
plt.grid(True)
plt.legend()
plt.xlabel("Tiempo (s)")
plt.title("Señales en el dominio del tiempo (primeros 1000 puntos)")
plt.show()