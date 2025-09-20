#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Wed Sep 17 17:34:27 2025

@author: alexis_silva
"""

import numpy as np
import matplotlib.pyplot as plt
from scipy.signal.windows import blackman

# Modelo de primer orden
# Se simulan 64 ciclos para sacar FFT

# Frecuencia de muestreo:
Fs = 256
# Numero de ciclos:
N = 64
# Frecuencia de entrada:
Fin = 1.5381
# Periodo:
T = 1 / Fin
# Ancho de Banda:
BW = Fin * 2
# Frecuencia de Nyquist:
Fn = BW * 2
# Factor de sobre muestreo:
OSR = Fs / Fn
# Ganancia del Integrador:
k = 0.5

# Tiempo de simulación:
t = np.arange(0, T * N, 1/Fs)

# Inicializar arrays
y = np.zeros(len(t))
Q = np.zeros(len(t))
r = np.zeros(len(t))
S = np.zeros(len(t))
suma = np.zeros(len(t))

for i in range(1, len(t)):
    # Señal de entrada:
    S[i-1] = (1/np.sqrt(2)) * np.sin(2 * np.pi * Fin * t[i-1])
    
    # Restas
    r[i-1] = S[i-1] - Q[i-1]
    
    # Integrador:
    suma[i] = y[i-1] + r[i-1]
    y[i] = suma[i]
    
    # Comparador
    Q[i] = np.sign(y[i])

# Gráfico de las señales en el tiempo
plt.figure(figsize=(12, 8))
plt.gca().set_prop_cycle(plt.cycler('color', ['blue', 'red', 'red', 'green']))
plt.plot(t, Q, linewidth=2)
plt.plot(t, S, '.', markersize=4)
plt.plot(t, S, linewidth=1)
plt.plot(t, y, linewidth=1)
plt.xlabel('Tiempo')
plt.ylabel('Amplitud')
plt.title('Señales en el dominio del tiempo')
plt.grid(True)
plt.legend(['Q (salida comparador)', 'S (entrada) puntos', 'S (entrada)', 'y (integrador)'])
plt.gca().tick_params(labelsize=12)
plt.tight_layout()
plt.show()

# ESPECTRO
L = len(t)
# ventana de blackman de longitud L
W = blackman(L)
Ho = W * Q

complexo = np.fft.fft(Ho)
mago = np.abs(complexo) / L
magodB = 20 * np.log10(mago + 1e-12)  # Se añade pequeño valor para evitar log(0)

# Vector para graficar en frecuencia
x = np.arange(Fs/L, Fs, Fs/L)
# Asegurarse que los arrays tienen la misma longitud
min_len = min(len(x), len(magodB))
x = x[:min_len]
magodB = magodB[:min_len]

# Gráfico del espectro
plt.figure(figsize=(12, 6))
plt.semilogx(x, magodB, '-k', linewidth=1, markersize=4)
plt.xlim(Fs/L, Fs/2)
plt.grid(True)
plt.xlabel("Frequency (Hz)", fontsize=16, fontweight='bold')
plt.ylabel("PSD (dB)", fontsize=16, fontweight='bold')
plt.title('Espectro de frecuencia')
plt.gca().tick_params(labelsize=12)
plt.tight_layout()
plt.show()

# Mostrar información de la simulación
print(f"Frecuencia de muestreo: {Fs} Hz")
print(f"Frecuencia de entrada: {Fin:.4f} Hz")
print(f"Periodo de entrada: {T:.4f} s")
print(f"Ancho de banda: {BW:.4f} Hz")
print(f"Frecuencia de Nyquist: {Fn:.4f} Hz")
print(f"Factor de sobre muestreo (OSR): {OSR:.2f}")
print(f"Número de puntos: {L}")