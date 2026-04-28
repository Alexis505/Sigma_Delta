import numpy as np
import matplotlib.pyplot as plt

# Parámetros
Ts = 0.01
t = np.arange(0, 1, Ts)
u = np.sin(2 * np.pi * 5 * t)  # seno de 5 Hz

# Integrador continuo ideal (solución analítica)
y_cont = -np.cos(2 * np.pi * 5 * t) / (2 * np.pi * 5)
y_cont -= y_cont[0]  # condición inicial cero

# Euler forward
y_euler_f = np.zeros_like(t)
for k in range(len(t)-1):
    y_euler_f[k+1] = y_euler_f[k] + Ts * u[k]

# Tustin
y_tustin = np.zeros_like(t)
for k in range(len(t)-1):
    y_tustin[k+1] = y_tustin[k] + (Ts/2) * (u[k] + u[k+1])

# Error
error_euler = np.abs(y_cont - y_euler_f)
error_tustin = np.abs(y_cont - y_tustin)

# Gráficas
plt.figure(figsize=(12, 8))

plt.subplot(3,1,1)
plt.plot(t, u , 'g--',linewidth=2, label='Input signal')
plt.legend()
plt.title('Señal de entrada')
plt.grid(True)

plt.subplot(3,1,2)
plt.plot(t, y_cont, 'k-', linewidth=2, label='Continuo ideal')
plt.plot(t, y_euler_f, 'r--', label='Euler forward')
plt.plot(t, y_tustin, 'b:', linewidth=2, label='Tustin')
plt.legend()
plt.title('Integración de señal senoidal de 5 Hz')
plt.grid(True)

plt.subplot(3,1,3)
plt.semilogy(t, error_euler, 'r-', label='Error Euler forward')
plt.semilogy(t, error_tustin, 'b-', label='Error Tustin')
plt.legend()
plt.title('Error absoluto')
plt.grid(True)

plt.tight_layout()
plt.show()

print(f"Error RMS Euler: {np.sqrt(np.mean(error_euler**2)):.6f}")
print(f"Error RMS Tustin: {np.sqrt(np.mean(error_tustin**2)):.6f}")
