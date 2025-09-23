#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Wed Sep 17 18:33:30 2025

@author: alexis_silva
"""

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
print(f"t es: {t}")
