/* Exp 8: Associative Memory using a Discrete Hopfield Network
 * Port of hopfield.py. Patterns T/L/X, 5x5, flip 4 pixels with srand(42),
 * asynchronous update up to 20 sweeps, energy, exact recall.
 * Compile: gcc -O2 -o hopfield hopfield.c -lm
 * Run: ./hopfield
 */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

static const int PAT[3][25] = {
    /* T */
    { 1, 1, 1, 1, 1, -1,-1, 1,-1,-1, -1,-1, 1,-1,-1, -1,-1, 1,-1,-1, -1,-1, 1,-1,-1},
    /* L */
    { 1,-1,-1,-1,-1,  1,-1,-1,-1,-1,  1,-1,-1,-1,-1,  1,-1,-1,-1,-1,  1, 1, 1, 1, 1},
    /* X */
    { 1,-1,-1,-1, 1, -1, 1,-1, 1,-1, -1,-1, 1,-1,-1, -1, 1,-1, 1,-1,  1,-1,-1,-1, 1}
};
static const char *NAMES[3] = {"T", "L", "X"};
static int W[25][25];

static void show(const int *y) {
    for (int r = 0; r < 5; r++) {
        for (int c = 0; c < 5; c++)
            printf("%s%s", y[r * 5 + c] == 1 ? "#" : ".", c < 4 ? " " : "");
        printf("\n");
    }
}

static double energy(const int *y) {
    double s = 0;
    for (int i = 0; i < 25; i++)
        for (int j = 0; j < 25; j++)
            s += (double)W[i][j] * y[i] * y[j];
    return -0.5 * s;
}

/* Shuffle 0..24 with Fisher-Yates using rand(). */
static void shuffle25(int *p) {
    for (int i = 0; i < 25; i++) p[i] = i;
    for (int i = 24; i > 0; i--) {
        int j = rand() % (i + 1);
        int t = p[i]; p[i] = p[j]; p[j] = t;
    }
}

int main(void) {
    /* W = P^T P, diagonal 0 */
    for (int i = 0; i < 25; i++)
        for (int j = 0; j < 25; j++) {
            int s = 0;
            for (int k = 0; k < 3; k++) s += PAT[k][i] * PAT[k][j];
            W[i][j] = (i == j) ? 0 : s;
        }

    srand(42);
    for (int pi = 0; pi < 3; pi++) {
        int original[25], y[25];
        memcpy(original, PAT[pi], sizeof(original));
        memcpy(y, original, sizeof(y));

        /* Flip 4 pixels: first 4 of a shuffled index list */
        int perm[25];
        shuffle25(perm);
        for (int k = 0; k < 4; k++) y[perm[k]] *= -1;

        printf("\nStored pattern: %s\n", NAMES[pi]);
        printf("Before recall:\n");
        show(y);

        for (int sweep = 0; sweep < 20; sweep++) {
            int old[25];
            memcpy(old, y, sizeof(old));
            int order[25];
            shuffle25(order);
            for (int k = 0; k < 25; k++) {
                int i = order[k];
                int net = 0;
                for (int j = 0; j < 25; j++) net += W[i][j] * y[j];
                y[i] = net >= 0 ? 1 : -1;
            }
            if (memcmp(old, y, sizeof(old)) == 0) break;
        }

        printf("After recall:\n");
        show(y);
        printf("Energy: %.1f\n", energy(y));
        printf("Exact recall: %s\n", memcmp(y, original, sizeof(y)) == 0 ? "True" : "False");
    }
    return 0;
}
