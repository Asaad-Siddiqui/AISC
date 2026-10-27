import numpy as np

X = np.array([[-1, -1], [-1, 1], [1, -1], [1, 1]])

gates = {
    "AND": [-1, -1, -1, 1],
    "OR":  [-1, 1, 1, 1],
    "XOR": [1, -1, -1, 1]
}

def train(name, target):
    w = np.zeros(2)
    b = 0
    eta = 1

    for epoch in range(50):
        errors = 0

        for x, t in zip(X, target):
            y = 1 if np.dot(w, x) + b >= 0 else -1

            if y != t:
                w += eta * t * x
                b += eta * t
                errors += 1

        print(name, "Epoch:", epoch + 1,
              "Weights:", w, "Bias:", b, "Errors:", errors)

        if errors == 0:
            break

    print("Final weights:", w, "Bias:", b)
    print("Predictions:",
          [1 if np.dot(w, x) + b >= 0 else -1 for x in X])
    print()

for name, target in gates.items():
    train(name, target)