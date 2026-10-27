# Exp 10: Genetic Algorithm, maximise f(x)=x^2, x in 0..31 (5-bit)
import random, matplotlib.pyplot as plt

fit = lambda c: int(c,2)**2
mutate = lambda c, pm: "".join(b if random.random()>pm else str(1-int(b)) for b in c)

def run(ps=6, pm=0.02, pc=0.8, gens=50, table=False):
    pop = ["".join(random.choice("01") for _ in range(5)) for _ in range(ps)]
    bh, ah, bc = [], [], max(pop, key=fit)
    for g in range(gens):
        f = [fit(c) for c in pop]; t, av = sum(f), sum(f)/len(f)
        bh.append(max(f)); ah.append(av); bc = max([bc]+pop, key=fit)
        if table and g == 0:
            print("Chrom   x   f(x)  Prob   Exp")
            for c, fi in zip(pop, f):
                print(f"{c}  {int(c,2):2d}  {fi:4d}  {fi/t:.3f}  {fi/av:.2f}")
        new = []
        while len(new) < ps:
            p1, p2 = random.choices(pop, weights=[x+1e-9 for x in f], k=2)
            if random.random() < pc:
                cut = random.randint(1,4); p1, p2 = p1[:cut]+p2[cut:], p2[:cut]+p1[cut:]
            new += [mutate(p1,pm), mutate(p2,pm)]
        pop = new[:ps]
    return bc, bh, ah

print("=== Run 1: pop=6, pm=0.02 ===")
b1, bh1, ah1 = run(6, 0.02, table=True)
print(f"Best={b1}, x={int(b1,2)}, f={fit(b1)}")
for g in range(0,50,10): print(f"Gen {g+1:2d}: best={bh1[g]}, avg={ah1[g]:.1f}")

print("\n=== Run 2: pop=20, pm=0.02 ===")
b2, bh2, ah2 = run(20, 0.02)
print(f"Best={b2}, f={fit(b2)}, avg={ah2[-1]:.1f}")

print("\n=== Run 3: pop=6, pm=0.2 ===")
b3, bh3, ah3 = run(6, 0.2)
print(f"Best={b3}, f={fit(b3)}, avg={ah3[-1]:.1f}")

plt.plot(ah1, label="avg(6,0.02)"); plt.plot(ah2, label="avg(20,0.02)")
plt.plot(ah3, label="avg(6,0.2)"); plt.plot(bh1, "k--", label="best(6,0.02)")
plt.xlabel("Gen"); plt.ylabel("Fitness"); plt.title("Convergence"); plt.legend(); plt.show()
