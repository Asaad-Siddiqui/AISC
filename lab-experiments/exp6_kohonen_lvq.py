# Exp 6: Kohonen SOM and LVQ
import numpy as np, matplotlib.pyplot as plt

# Part 1: SOM on 4 vectors, 2 neurons
X = np.array([[1,1,0,0],[0,0,0,1],[1,0,0,0],[0,0,1,1]], dtype=float)
W = np.array([[0.2,0.6,0.5,0.9],[0.8,0.4,0.7,0.3]])
a = 0.6
for ep in range(1, 6):
    print(f"\nEpoch {ep}, alpha={a:.4f}")
    for i, x in enumerate(X, 1):
        D = ((W-x)**2).sum(1); j = D.argmin()
        W[j] += a*(x-W[j])
        print(f"  x{i} -> D={np.round(D,3)}, winner={j+1}")
    print(f"  W1={np.round(W[0],3)}\n  W2={np.round(W[1],3)}")
    a /= 2
cl = {1:[], 2:[]}
for i, x in enumerate(X, 1): cl[((W-x)**2).sum(1).argmin()+1].append(f"x{i}")
print("\nFinal clusters:", cl)

# Part 2: SOM on 2D random points
np.random.seed(1); pts = np.random.rand(200,2)
n = 4; w = np.random.rand(n,2); a, R = 0.5, 1
for ep in range(30):
    for p in pts:
        win = ((w-p)**2).sum(1).argmin()
        for j in range(n):
            if abs(j-win) <= R: w[j] += a*(p-w[j])
    a *= 0.9
    if ep == 15: R = 0
plt.figure()
plt.scatter(pts[:,0], pts[:,1], s=8, label="data")
plt.plot(w[:,0], w[:,1], "ro-", label="SOM weights")
plt.title("SOM: data & weights"); plt.legend(); plt.savefig("som_plot.png")

# Part 3: LVQ
np.random.seed(2)
A = np.random.randn(50,2)*0.5; B = np.random.randn(50,2)*0.5+[3,3]
data, labels = np.vstack([A,B]), np.array([0]*50+[1]*50)
proto, pcls = np.array([data[0], data[50]]), np.array([0,1])
a = 0.3
for ep in range(20):
    for x, c in zip(data, labels):
        j = ((proto-x)**2).sum(1).argmin()
        proto[j] += a*(x-proto[j]) * (1 if pcls[j]==c else -1)
    a *= 0.9
pred = [pcls[((proto-x)**2).sum(1).argmin()] for x in data]
print("\nLVQ accuracy = %.1f %%" % (100*np.mean(np.array(pred)==labels)))
plt.show()
