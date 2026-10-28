/* Exp 4: Single Layer Perceptron
 * Port of perceptron.py. Plain arrays, no numpy.
 * NOTE: the XOR target is kept exactly as in the Python original,
 * [1, -1, -1, 1] (which is XNOR, not XOR); it is NOT 'fixed' here.
 * Compile: gcc -O2 -o perceptron perceptron.c -lm
 * Run: ./perceptron
 */
#include <stdio.h>

static const int X[4][2] = {{-1, -1}, {-1, 1}, {1, -1}, {1, 1}};

static void train(const char *name, const int target[4]) {
    double w[2] = {0.0, 0.0};
    double b = 0.0;
    const double eta = 1.0;

    for (int epoch = 0; epoch < 50; epoch++) {
        int errors = 0;
        for (int i = 0; i < 4; i++) {
            double dot = w[0] * X[i][0] + w[1] * X[i][1] + b;
            int y = dot >= 0 ? 1 : -1;
            int t = target[i];
            if (y != t) {
                w[0] += eta * t * X[i][0];
                w[1] += eta * t * X[i][1];
                b += eta * t;
                errors++;
            }
        }
        printf("%s Epoch: %d Weights: [%.1f %.1f] Bias: %.0f Errors: %d\n",
               name, epoch + 1, w[0], w[1], b, errors);
        if (errors == 0) break;
    }
    printf("Final weights: [%.1f %.1f] Bias: %.0f\n", w[0], w[1], b);
    printf("Predictions: [");
    for (int i = 0; i < 4; i++) {
        double dot = w[0] * X[i][0] + w[1] * X[i][1] + b;
        int y = dot >= 0 ? 1 : -1;
        printf("%d%s", y, i < 3 ? ", " : "");
    }
    printf("]\n\n");
}

int main(void) {
    static const int AND_T[4] = {-1, -1, -1, 1};
    static const int OR_T[4]  = {-1, 1, 1, 1};
    static const int XOR_T[4] = {1, -1, -1, 1}; /* as given in Python */
    train("AND", AND_T);
    train("OR", OR_T);
    train("XOR", XOR_T);
    return 0;
}
