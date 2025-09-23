#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Wed Sep 17 18:02:44 2025

@author: alexis_silva
"""

import numpy as np
import matplotlib.pyplot as plt

# Modelo de primer orden
# Frecuencia de muestreo:
Fs = 256
# Número de ciclos:
N = 1
# Frecuencia de entrada:
Fin = 1
# Periodo: (=1)
T = 1 / Fin
# Ancho de Banda: (=2)
BW = Fin * 2
# Frecuencia de Nyquist: (=4)
Fn = BW * 2
# Factor de sobre muestreo: (= 256/4 = 64)
OSR = Fs / Fn
# Ganancia del Integrador: (= 0.5)
k = 0.5
# Tiempo de simulación: (=[0:1/256:1*1]) = (=[0:0.0039:1]) = 257 pasos
t = np.arange(0, T * N + 1/Fs, 1/Fs)

# Inicializar arrays
n = len(t)
y = np.zeros(n)
Q = np.zeros(n)
r = np.zeros(n)
m = np.zeros(n)
S = np.zeros(n)

# Simulación
for i in range(1, n):
    # Señal de entrada
    S[i-1] = (1/np.sqrt(2)) * np.sin(2 * np.pi * Fin * t[i-1])
    # Restas
    r[i-1] = S[i-1] - Q[i-1]
    # Multiplicación por k
    m[i-1] = r[i-1] * k
    # Integrador
    y[i] = y[i-1] + m[i-1]
    # Comparador
    Q[i] = np.sign(y[i])

# Graficar
plt.figure(figsize=(10, 6))
plt.plot(t, Q, 'b', linewidth=1, label='Q')
plt.plot(t, S, 'r', linewidth=2, label='S')
plt.plot(t, y, 'm', label='y')
plt.grid(True)
plt.legend()
plt.xlabel('Tiempo')
plt.title('Modelo de Primer Orden')
plt.show()