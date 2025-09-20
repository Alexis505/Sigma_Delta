#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Wed Sep 17 18:49:35 2025

@author: alexis_silva
"""

import numpy as np
import matplotlib.pyplot as plt

# Parámetros del modelo
Fs = 256
N = 64
Fin = 1 / (2 * np.sqrt(2))
T = 1 / Fin
BW = 1
Fn = BW * 2
OSR = Fs / Fn
K = 0.5

# Vector de tiempo
t = np.arange(0, T * N, 1/Fs)
L = len(t)

# Inicialización de variables
y1 = np.zeros(L)
Q = np.zeros(L)
r1 = np.zeros(L)
r1_k = np.zeros(L)
S = np.zeros(L)
r2 = np.zeros(L)
r2_k = np.zeros(L)
y2 = np.zeros(L)

# Simulación del modulador Sigma-Delta
for i in range(1, L):
    S[i-1] = (1/np.sqrt(2)) * np.sin(2 * np.pi * Fin * t[i-1])
    r1[i-1] = S[i-1] - Q[i-1]
    r1_k[i-1] = K * r1[i-1]
    y1[i] = y1[i-1] + r1_k[i-1]
    r2[i-1] = y1[i-1] - Q[i-1]
    r2_k[i-1] = K * r2[i-1]
    y2[i] = y2[i-1] + r2_k[i-1]
    Q[i] = np.sign(y2[i])

# Cálculo del espectro
W = np.blackman(L)
Ho = W * Q

complexo = np.fft.fft(Ho)
mago = np.abs(complexo) / L
magodB = 20 * np.log10(mago)
x = np.arange(Fs/L, Fs+Fs/L, Fs/L)

# Gráficas
plt.figure(1)
plt.subplot(3,1,1)
plt.plot(x, mago, '-k')
plt.xlim(0, 257)
plt.grid()
plt.xlabel("Frequency (Hz)")
plt.ylabel("Amplitud")

plt.subplot(3,1,2)
plt.plot(x, mago, '-k')
plt.xlim(0, 1)
plt.grid()
plt.xlabel("Frequency (Hz)")
plt.ylabel("Amplitud")

plt.subplot(3,1,3)
plt.plot(x, mago, '-k')
plt.xlim(255, 256)
plt.grid()
plt.xlabel("Frequency (Hz)")
plt.ylabel("Amplitud")

plt.figure(2)
plt.subplot(3,1,1)
plt.semilogx(x, magodB, '-k')
plt.xlim(Fs/L, Fs)
plt.grid()
plt.xlabel("Frequency (Hz)")
plt.ylabel("PSD (dB)")

plt.subplot(3,1,2)
plt.semilogx(x, magodB, '-k')
plt.xlim(0.1, 1)
plt.grid()
plt.xlabel("Frequency (Hz)")
plt.ylabel("PSD (dB)")

plt.subplot(3,1,3)
plt.semilogx(x, magodB, '-k')
plt.xlim(255, 256)
plt.grid()
plt.xlabel("Frequency (Hz)")
plt.ylabel("PSD (dB)")

# Cálculo de SNR
SNR_teorica = 10 * np.log10((15 * OSR**5) / (2 * np.pi**4))
print(f'SNR teórica: {SNR_teorica} dB')

fin_idx = np.argmin(np.abs(x - Fin)) + 1
Amp_fin_idx = (mago[fin_idx-2] + mago[fin_idx-1] + mago[fin_idx] + 
               mago[fin_idx+1] + mago[fin_idx+2])
print(f'Amplitud en frecuencia fundamental: {Amp_fin_idx}')

signal_power = (mago[fin_idx-2]**2 + mago[fin_idx-1]**2 + mago[fin_idx]**2 + 
                mago[fin_idx+1]**2 + mago[fin_idx+2]**2)

noise_bins = np.concatenate([np.arange(1, fin_idx-2), np.arange(fin_idx+3, 128)])
noise_power = np.sum(mago[noise_bins.astype(int)]**2)

SNR_empirica = 10 * np.log10(signal_power/noise_power)
print(f'SNR empírica: {SNR_empirica} dB')

plt.show()