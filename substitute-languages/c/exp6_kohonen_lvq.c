/* Exp 6: Kohonen SOM and LVQ
 * Port of exp6_kohonen_lvq.py. No plotting: Part 2 prints final weights
 * instead of som_plot.png, Part 3 prints LVQ accuracy.
 * Random numbers differ from numpy (expected): C rand() with the same
 * seeds and the same algorithm, Box-Muller for normals.
 * Compile: gcc -O2 -o exp6_kohonen_lvq exp6_kohonen_lvq.c -lm
 * Run: ./exp6_kohonen_lvq
 */
#include <stdio.h>
#include <stdlib.h>
#include <math.h>

static double uni(void) {
    return rand() / (double)RAND_MAX;
}

/* Box-Muller, one cached spare value, like a standard normal stream. */
static int have_spare = 0;
static double spare;
static double randn(void) {
    if (have_spare) { have_spare = 0; return spare; }
    double u1 = uni();
    while (u1 <= 0.0) u1 = uni();
    double u2 = uni();
    double r = sqrt(-2.0 * log(u1));
    double th = 2.0 * M_PI * u2;
    spare = r * sin(th); have_spare = 1;
    return r * cos(th);
}

int main(void) {
    /* ---- Part 1: SOM on 4 vectors, 2 neurons ---- */
    double X[4][4] = {{1,1,0,0},{0,0,0,1},{1,0,0,0},{0,0,1,1}};
    double W[2][4] = {{0.2,0.6,0.5,0.9},{0.8,0.4,0.7,0.3}};
    double a = 0.6;
    for (int ep = 1; ep <= 5; ep++) {
        printf("\nEpoch %d, alpha=%.4f\n", ep, a);
        for (int i = 0; i < 4; i++) {
            double D[2];
            for (int j = 0; j < 2; j++) {
                double s = 0;
                for (int k = 0; k < 4; k++) {
                    double d = W[j][k] - X[i][k]; s += d * d;
                }
                D[j] = s;
            }
            int win = D[1] < D[0] ? 1 : 0; /* argmin, first on tie */
            for (int k = 0; k < 4; k++) W[win][k] += a * (X[i][k] - W[win][k]);
            printf("  x%d -> D=[%.3f %.3f], winner=%d\n",
                   i + 1, D[0], D[1], win + 1);
        }
        printf("  W1=[%.3f %.3f %.3f %.3f]\n  W2=[%.3f %.3f %.3f %.3f]\n",
               W[0][0], W[0][1], W[0][2], W[0][3],
               W[1][0], W[1][1], W[1][2], W[1][3]);
        a /= 2.0;
    }
    /* Final clusters */
    int cl1[4], cl2[4], n1 = 0, n2 = 0;
    for (int i = 0; i < 4; i++) {
        double D[2];
        for (int j = 0; j < 2; j++) {
            double s = 0;
            for (int k = 0; k < 4; k++) {
                double d = W[j][k] - X[i][k]; s += d * d;
            }
            D[j] = s;
        }
        if (D[1] < D[0]) cl2[n2++] = i + 1; else cl1[n1++] = i + 1;
    }
    printf("\nFinal clusters: {1: [");
    for (int i = 0; i < n1; i++) printf("'x%d'%s", cl1[i], i + 1 < n1 ? ", " : "");
    printf("], 2: [");
    for (int i = 0; i < n2; i++) printf("'x%d'%s", cl2[i], i + 1 < n2 ? ", " : "");
    printf("]}\n");

    /* ---- Part 2: SOM on 2D random points ---- */
    srand(1);
    double pts[200][2];
    for (int i = 0; i < 200; i++) { pts[i][0] = uni(); pts[i][1] = uni(); }
    double w[4][2];
    for (int j = 0; j < 4; j++) { w[j][0] = uni(); w[j][1] = uni(); }
    double a2 = 0.5;
    int R = 1;
    for (int ep = 0; ep < 30; ep++) {
        for (int i = 0; i < 200; i++) {
            int win = 0; double best = 1e300;
            for (int j = 0; j < 4; j++) {
                double dx = w[j][0] - pts[i][0], dy = w[j][1] - pts[i][1];
                double d = dx * dx + dy * dy;
                if (d < best) { best = d; win = j; }
            }
            for (int j = 0; j < 4; j++) {
                if (abs(j - win) <= R) {
                    w[j][0] += a2 * (pts[i][0] - w[j][0]);
                    w[j][1] += a2 * (pts[i][1] - w[j][1]);
                }
            }
        }
        a2 *= 0.9;
        if (ep == 15) R = 0;
    }
    printf("\nPart 2 final SOM weights (no plot):\n");
    for (int j = 0; j < 4; j++)
        printf("  w%d = [%.4f %.4f]\n", j + 1, w[j][0], w[j][1]);

    /* ---- Part 3: LVQ ---- */
    srand(2);
    have_spare = 0;
    double data[100][2];
    int labels[100];
    for (int i = 0; i < 50; i++) {
        data[i][0] = randn() * 0.5; data[i][1] = randn() * 0.5; labels[i] = 0;
    }
    for (int i = 0; i < 50; i++) {
        data[50 + i][0] = randn() * 0.5 + 3.0;
        data[50 + i][1] = randn() * 0.5 + 3.0;
        labels[50 + i] = 1;
    }
    double proto[2][2] = {{data[0][0], data[0][1]}, {data[50][0], data[50][1]}};
    int pcls[2] = {0, 1};
    double a3 = 0.3;
    for (int ep = 0; ep < 20; ep++) {
        for (int i = 0; i < 100; i++) {
            int win = 0; double best = 1e300;
            for (int j = 0; j < 2; j++) {
                double dx = proto[j][0] - data[i][0], dy = proto[j][1] - data[i][1];
                double d = dx * dx + dy * dy;
                if (d < best) { best = d; win = j; }
            }
            double sgn = (pcls[win] == labels[i]) ? 1.0 : -1.0;
            proto[win][0] += a3 * (data[i][0] - proto[win][0]) * sgn;
            proto[win][1] += a3 * (data[i][1] - proto[win][1]) * sgn;
        }
        a3 *= 0.9;
    }
    int correct = 0;
    for (int i = 0; i < 100; i++) {
        int win = 0; double best = 1e300;
        for (int j = 0; j < 2; j++) {
            double dx = proto[j][0] - data[i][0], dy = proto[j][1] - data[i][1];
            double d = dx * dx + dy * dy;
            if (d < best) { best = d; win = j; }
        }
        if (pcls[win] == labels[i]) correct++;
    }
    printf("\nLVQ accuracy = %.1f %%\n", 100.0 * correct / 100.0);
    return 0;
}
