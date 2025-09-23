#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Wed Sep 17 17:43:12 2025

@author: alexis_silva
"""

import numpy as np
import matplotlib.pyplot as plt

# Modelo de primer orden

# Frecuencia de muestreo:
Fs = 128
# Numero de ciclos:
N = 1
# Frecuencia de entrada:
Fin = 1
# Periodo:
T = 1 / Fin
# Ancho de Banda:
BW = Fin * 2
# Frecuencia de Nyquist:
Fn = BW * 2
# Factor de sobre muestreo:
OSR = Fs / Fn

# Tiempo de simulación:
t = np.arange(0, T * N + 1/Fs, 1/Fs)  # +1/Fs para incluir el último punto

# Inicializar arrays
y = np.zeros(len(t))
Q = np.zeros(len(t))
r = np.zeros(len(t))
S = np.zeros(len(t))

for i in range(1, len(t)):
    # Señal de entrada:
    S[i-1] = np.sin(2 * np.pi * Fin * t[i-1])
    
    # Restas
    r[i-1] = S[i-1] - Q[i-1]
    
    # Integrador:
    y[i] = y[i-1] + r[i-1]
    
    # Comparador
    Q[i] = np.sign(y[i])

# Gráfico
plt.figure(figsize=(12, 6))
plt.plot(t, Q, 'b', linewidth=1, label='Q (salida comparador)')
plt.plot(t, S, 'r', linewidth=2, label='S (señal de entrada)')

# Configuración del gráfico
plt.xlabel('Tiempo (s)', fontsize=16, fontweight='bold')
plt.ylabel('Amplitud', fontsize=16, fontweight='bold')
plt.title('Modelo de Primer Orden', fontsize=16, fontweight='bold')
plt.grid(True)
plt.legend(fontsize=12)
plt.xticks(fontsize=12)
plt.yticks(fontsize=12)

# Mostrar información de la simulación
print(f"Frecuencia de muestreo: {Fs} Hz")
print(f"Frecuencia de entrada: {Fin} Hz")
print(f"Periodo de entrada: {T:.4f} s")
print(f"Ancho de banda: {BW} Hz")
print(f"Frecuencia de Nyquist: {Fn} Hz")
print(f"Factor de sobre muestreo (OSR): {OSR:.2f}")
print(f"Número de puntos: {len(t)}")

plt.tight_layout()
plt.show()