/* Exp 2: 8-Puzzle using A* search
 * Port of 8puzzle.py. Priority queue = simple array + linear min scan.
 * Tie-breaking mirrors Python heapq on (f, g, state): smallest f, then
 * smallest g, then lexicographically smallest state.
 * Compile: gcc -O2 -o 8puzzle 8puzzle.c -lm
 * Run: ./8puzzle
 */
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

#define NPOOL 200000
#define NOPEN 200000
#define NBEST 200000

static const int GOAL[9] = {1, 2, 3, 4, 5, 6, 7, 8, 0};
static const int START[9] = {1, 2, 3, 4, 0, 6, 7, 5, 8};

typedef struct {
    int s[9];
    int g, f, parent; /* parent = pool index, -1 for start */
} Node;

static Node pool[NPOOL];
static int npool;
static int open_idx[NOPEN];
static int nopen;

/* best[]: encoded state -> best g seen (or -1) */
static int best_state[NBEST][9];
static int best_g[NBEST];
static int nbest;

static int misplaced(const int *s) {
    int d = 0;
    for (int i = 0; i < 9; i++)
        if (s[i] != GOAL[i] && s[i] != 0) d++;
    return d;
}

static int manhattan(const int *s) {
    int d = 0;
    for (int i = 0; i < 9; i++) {
        int v = s[i];
        if (v) {
            int j = v - 1; /* GOAL.index(v), since GOAL = 1..8,0 */
            d += abs(i / 3 - j / 3) + abs(i % 3 - j % 3);
        }
    }
    return d;
}

static int state_cmp(const int *a, const int *b) {
    for (int i = 0; i < 9; i++) {
        if (a[i] != b[i]) return a[i] < b[i] ? -1 : 1;
    }
    return 0;
}

static int state_eq(const int *a, const int *b) {
    return state_cmp(a, b) == 0;
}

/* Return index in best[] or -1. */
static int best_lookup(const int *s) {
    for (int i = 0; i < nbest; i++)
        if (state_eq(best_state[i], s)) return i;
    return -1;
}

static void best_set(const int *s, int g) {
    int i = best_lookup(s);
    if (i >= 0) { best_g[i] = g; return; }
    memcpy(best_state[nbest], s, sizeof(int) * 9);
    best_g[nbest] = g;
    nbest++;
}

static int solve(int (*h)(const int *)) {
    npool = 0; nopen = 0; nbest = 0;
    memcpy(pool[0].s, START, sizeof(int) * 9);
    pool[0].g = 0; pool[0].f = h(START); pool[0].parent = -1;
    npool = 1;
    open_idx[nopen++] = 0;
    best_set(START, 0);

    /* closed set: encoded states already expanded */
    static int closed_state[NBEST][9];
    int nclosed = 0;
    int expanded = 0;

    while (nopen > 0) {
        /* linear min scan over open list */
        int bestpos = 0;
        for (int i = 1; i < nopen; i++) {
            Node *a = &pool[open_idx[i]], *b = &pool[open_idx[bestpos]];
            int better = 0;
            if (a->f != b->f) better = a->f < b->f;
            else if (a->g != b->g) better = a->g < b->g;
            else better = state_cmp(a->s, b->s) < 0;
            if (better) bestpos = i;
        }
        int cur = open_idx[bestpos];
        open_idx[bestpos] = open_idx[--nopen];

        /* skip if already closed (Python: `if s in closed: continue`) */
        int is_closed = 0;
        for (int i = 0; i < nclosed; i++)
            if (state_eq(closed_state[i], pool[cur].s)) { is_closed = 1; break; }
        if (is_closed) continue;
        memcpy(closed_state[nclosed++], pool[cur].s, sizeof(int) * 9);
        expanded++;

        if (state_eq(pool[cur].s, GOAL)) {
            /* reconstruct path: pool chain from start to cur */
            int chain[10000], clen = 0;
            for (int p = cur; p >= 0; p = pool[p].parent) chain[clen++] = p;
            for (int ci = clen - 1; ci >= 0; ci--) {
                int *st = pool[chain[ci]].s;
                for (int i = 0; i < 9; i += 3)
                    printf("(%d, %d, %d)\n", st[i], st[i + 1], st[i + 2]);
                printf("\n");
            }
            printf("Moves: %d Nodes expanded: %d\n", pool[cur].g, expanded);
            return expanded;
        }

        int z = 0;
        while (pool[cur].s[z] != 0) z++;
        static const char *moves[4] = {"Up", "Down", "Left", "Right"};
        static const int dz[4] = {-3, 3, -1, 1};
        for (int m = 0; m < 4; m++) {
            int nz = z + dz[m];
            if (nz < 0 || nz >= 9) continue;
            if (strcmp(moves[m], "Left") == 0 && z % 3 == 0) continue;
            if (strcmp(moves[m], "Right") == 0 && z % 3 == 2) continue;
            int t[9];
            memcpy(t, pool[cur].s, sizeof(int) * 9);
            t[z] = t[nz]; t[nz] = 0;
            int ng = pool[cur].g + 1;
            int bi = best_lookup(t);
            if (bi < 0 || ng < best_g[bi]) {
                best_set(t, ng);
                memcpy(pool[npool].s, t, sizeof(int) * 9);
                pool[npool].g = ng;
                pool[npool].f = ng + h(t);
                pool[npool].parent = cur;
                open_idx[nopen++] = npool++;
            }
        }
    }
    printf("No solution found.\n");
    return expanded;
}

int main(void) {
    printf("Misplaced Tiles:\n");
    int n1 = solve(misplaced);
    printf("\nManhattan Distance:\n");
    int n2 = solve(manhattan);
    printf("\nComparison: %d %d\n", n1, n2);
    return 0;
}
