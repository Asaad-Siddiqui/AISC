/* Exp 10: Genetic Algorithm, maximise f(x)=x^2, x in 0..31 (5-bit)
 * Port of exp10_genetic_algorithm.py. No plotting: best/avg are printed.
 * Random numbers differ from Python (expected): C rand() with srand(42)
 * once, continuing across all three runs.
 * Compile: gcc -O2 -o exp10_genetic_algorithm exp10_genetic_algorithm.c -lm
 * Run: ./exp10_genetic_algorithm
 */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct { char s[6]; } Chrom; /* 5 bits + NUL */

static double uni(void) { return rand() / (double)RAND_MAX; }

static int chrom_val(const char *c) {
    int v = 0;
    for (int i = 0; i < 5; i++) v = v * 2 + (c[i] - '0');
    return v;
}
static int fit(const char *c) { int x = chrom_val(c); return x * x; }

static void mutate(char *c, double pm) {
    for (int i = 0; i < 5; i++)
        if (uni() <= pm) c[i] = (c[i] == '0') ? '1' : '0';
    /* Python: keep if random() > pm, flip otherwise; uni() <= pm flips. */
}

/* Weighted choice with replacement, weights f+1e-9, as in random.choices. */
static int weighted_choice(Chrom *pop, const int *f, int ps) {
    double total = 0;
    for (int i = 0; i < ps; i++) total += f[i] + 1e-9;
    double r = uni() * total, acc = 0;
    for (int i = 0; i < ps; i++) {
        acc += f[i] + 1e-9;
        if (r <= acc) return i;
    }
    return ps - 1;
}

typedef struct {
    char best[6];
    int bh[50];
    double ah[50];
} Result;

static Result run(int ps, double pm, double pc, int gens, int table) {
    Chrom pop[20], newpop[20];
    for (int i = 0; i < ps; i++) {
        for (int k = 0; k < 5; k++) pop[i].s[k] = uni() < 0.5 ? '0' : '1';
        pop[i].s[5] = '\0';
    }
    /* bc = max(pop, key=fit) initially (first max on ties) */
    char bc[6];
    strcpy(bc, pop[0].s);
    for (int i = 1; i < ps; i++)
        if (fit(pop[i].s) > fit(bc)) strcpy(bc, pop[i].s);

    Result res;
    for (int g = 0; g < gens; g++) {
        int f[20], t = 0;
        for (int i = 0; i < ps; i++) { f[i] = fit(pop[i].s); t += f[i]; }
        double av = (double)t / ps;
        int mx = f[0];
        for (int i = 1; i < ps; i++) if (f[i] > mx) mx = f[i];
        res.bh[g] = mx; res.ah[g] = av;
        /* bc = max([bc]+pop, key=fit): bc first, so ties keep bc */
        for (int i = 0; i < ps; i++)
            if (fit(pop[i].s) > fit(bc)) strcpy(bc, pop[i].s);
        if (table && g == 0) {
            printf("Chrom   x   f(x)  Prob   Exp\n");
            for (int i = 0; i < ps; i++)
                printf("%s  %2d  %4d  %.3f  %.2f\n",
                       pop[i].s, chrom_val(pop[i].s), f[i],
                       (double)f[i] / t, (double)f[i] / av);
        }
        int nn = 0;
        while (nn < ps) {
            char p1[6], p2[6];
            strcpy(p1, pop[weighted_choice(pop, f, ps)].s);
            strcpy(p2, pop[weighted_choice(pop, f, ps)].s);
            if (uni() < pc) {
                int cut = 1 + rand() % 4; /* randint(1,4) */
                char q1[6], q2[6];
                memcpy(q1, p1, cut); memcpy(q1 + cut, p2 + cut, 5 - cut); q1[5] = '\0';
                memcpy(q2, p2, cut); memcpy(q2 + cut, p1 + cut, 5 - cut); q2[5] = '\0';
                strcpy(p1, q1); strcpy(p2, q2);
            }
            mutate(p1, pm); mutate(p2, pm);
            /* Python: new += [p1, p2]; pop = new[:ps] */
            if (nn < ps) strcpy(newpop[nn++].s, p1);
            if (nn < ps) strcpy(newpop[nn++].s, p2);
        }
        for (int i = 0; i < ps; i++) strcpy(pop[i].s, newpop[i].s);
    }
    strcpy(res.best, bc);
    return res;
}

int main(void) {
    srand(42);
    printf("=== Run 1: pop=6, pm=0.02 ===\n");
    Result r1 = run(6, 0.02, 0.8, 50, 1);
    printf("Best=%s, x=%d, f=%d\n", r1.best, chrom_val(r1.best), fit(r1.best));
    for (int g = 0; g < 50; g += 10)
        printf("Gen %2d: best=%d, avg=%.1f\n", g + 1, r1.bh[g], r1.ah[g]);

    printf("\n=== Run 2: pop=20, pm=0.02 ===\n");
    Result r2 = run(20, 0.02, 0.8, 50, 0);
    printf("Best=%s, f=%d, avg=%.1f\n", r2.best, fit(r2.best), r2.ah[49]);

    printf("\n=== Run 3: pop=6, pm=0.2 ===\n");
    Result r3 = run(6, 0.2, 0.8, 50, 0);
    printf("Best=%s, f=%d, avg=%.1f\n", r3.best, fit(r3.best), r3.ah[49]);
    return 0;
}
