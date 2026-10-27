import numpy as np

def trimf(x, a, b, c):
    return np.maximum(0, np.minimum(
        (x-a)/(b-a+1e-9),
        (c-x)/(c-b+1e-9)
    ))

def trapmf(x, a, b, c, d):
    return np.maximum(0, np.minimum(
        np.minimum((x-a)/(b-a+1e-9), 1),
        (d-x)/(d-c+1e-9)
    ))

def gaussmf(x, mean, sigma):
    return np.exp(-0.5 * ((x-mean)/sigma)**2)

def sigmoidmf(x, a, c):
    return 1 / (1 + np.exp(-a*(x-c)))

temp = np.arange(0, 41, 1)
hum = np.arange(0, 101, 1)
speed = np.arange(0, 101, 1)

cold = trapmf(temp, 0, 0, 10, 20)
warm = trimf(temp, 10, 20, 30)
hot = sigmoidmf(temp, 0.3, 28)

low = trapmf(hum, 0, 0, 25, 50)
medium = gaussmf(hum, 50, 15)
high = sigmoidmf(hum, 0.12, 60)

slow = trapmf(speed, 0, 0, 25, 50)
moderate = trimf(speed, 25, 50, 75)
fast = sigmoidmf(speed, 0.12, 60)

T = 25
H = 70

print("Temperature:", T)
print("Cold membership:", cold[T])
print("Warm membership:", warm[T])
print("Hot membership:", hot[T])

print("\nHumidity:", H)
print("Low membership:", low[H])
print("Medium membership:", medium[H])
print("High membership:", high[H])

print("\nSpeed membership at 50:")
print("Slow:", slow[50])
print("Moderate:", moderate[50])
print("Fast:", fast[50])