import numpy as np

patterns = {
    "T": np.array([
        [1, 1, 1, 1, 1],
        [-1, -1, 1, -1, -1],
        [-1, -1, 1, -1, -1],
        [-1, -1, 1, -1, -1],
        [-1, -1, 1, -1, -1]
    ]),
    "L": np.array([
        [1, -1, -1, -1, -1],
        [1, -1, -1, -1, -1],
        [1, -1, -1, -1, -1],
        [1, -1, -1, -1, -1],
        [1, 1, 1, 1, 1]
    ]),
    "X": np.array([
        [1, -1, -1, -1, 1],
        [-1, 1, -1, 1, -1],
        [-1, -1, 1, -1, -1],
        [-1, 1, -1, 1, -1],
        [1, -1, -1, -1, 1]
    ])
}

P = np.array([p.flatten() for p in patterns.values()])
W = P.T @ P
np.fill_diagonal(W, 0)

def energy(y):
    return -0.5 * y @ W @ y

def show(y):
    for row in y.reshape(5, 5):
        print(" ".join("#" if v == 1 else "." for v in row))

for name, pattern in patterns.items():
    original = pattern.flatten()
    y = original.copy()

    # Introduce noise by flipping 4 pixels
    ids = np.random.choice(25, 4, replace=False)
    y[ids] *= -1

    print("\nStored pattern:", name)
    print("Before recall:")
    show(y)

    for sweep in range(20):
        old = y.copy()

        for i in np.random.permutation(25):
            net = W[i] @ y
            y[i] = 1 if net >= 0 else -1

        if np.array_equal(old, y):
            break

    print("After recall:")
    show(y)
    print("Energy:", energy(y))
    print("Exact recall:", np.array_equal(y, original))