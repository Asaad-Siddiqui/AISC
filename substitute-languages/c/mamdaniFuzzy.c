/* Exp 9: Mamdani Fuzzy Controller (fuzzification part, as in Python)
 * Port of mamdaniFuzzy.py. Same trimf/trapmf/gaussmf/sigmoidmf formulas,
 * T=25, H=70, speed memberships at 50. No numpy.
 * Compile: gcc -O2 -o mamdaniFuzzy mamdaniFuzzy.c -lm
 * Run: ./mamdaniFuzzy
 */
#include <stdio.h>
#include <math.h>

static double dmax(double a, double b) { return a > b ? a : b; }
static double dmin(double a, double b) { return a < b ? a : b; }

static double trimf(double x, double a, double b, double c) {
    return dmax(0.0, dmin((x - a) / (b - a + 1e-9),
                          (c - x) / (c - b + 1e-9)));
}
static double trapmf(double x, double a, double b, double c, double d) {
    return dmax(0.0, dmin(dmin((x - a) / (b - a + 1e-9), 1.0),
                          (d - x) / (d - c + 1e-9)));
}
static double gaussmf(double x, double mean, double sigma) {
    double z = (x - mean) / sigma;
    return exp(-0.5 * z * z);
}
static double sigmoidmf(double x, double a, double c) {
    return 1.0 / (1.0 + exp(-a * (x - c)));
}

int main(void) {
    int T = 25, H = 70;
    printf("Temperature: %d\n", T);
    printf("Cold membership: %g\n", trapmf(T, 0, 0, 10, 20));
    printf("Warm membership: %g\n", trimf(T, 10, 20, 30));
    printf("Hot membership: %g\n", sigmoidmf(T, 0.3, 28));

    printf("\nHumidity: %d\n", H);
    printf("Low membership: %g\n", trapmf(H, 0, 0, 25, 50));
    printf("Medium membership: %g\n", gaussmf(H, 50, 15));
    printf("High membership: %g\n", sigmoidmf(H, 0.12, 60));

    printf("\nSpeed membership at 50:\n");
    printf("Slow: %g\n", trapmf(50, 0, 0, 25, 50));
    printf("Moderate: %g\n", trimf(50, 25, 50, 75));
    printf("Fast: %g\n", sigmoidmf(50, 0.12, 60));
    return 0;
}
