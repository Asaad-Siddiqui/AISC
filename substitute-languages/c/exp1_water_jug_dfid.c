/* Exp 1: Water Jug Problem using DFID
 * Port of exp1_water_jug_dfid.py. Standard library only.
 * Compile: gcc -O2 -o exp1_water_jug_dfid exp1_water_jug_dfid.c -lm
 * Run: ./exp1_water_jug_dfid
 */
#include <stdio.h>
#include <string.h>

static const char *OPS[6] = {"Fill A", "Fill B", "Empty A",
                             "Empty B", "A->B", "B->A"};

/* path states and op names, indexed by depth */
static int path_x[512], path_y[512];
static int path_op[512]; /* -1 for Start, else 0..5 */
static int path_len;

static int state_in_path(int x, int y, int len) {
    for (int i = 0; i < len; i++)
        if (path_x[i] == x && path_y[i] == y) return 1;
    return 0;
}

/* Depth-limited search. Returns 1 if a solution was found, with
 * path_len / path arrays holding the solution path. */
static int dls(int lim, int a, int b, int t, int *nodes) {
    int x = path_x[path_len - 1], y = path_y[path_len - 1];
    if (x == t) return 1;
    if (lim == 0) return 0;
    int p = x < (b - y) ? x : (b - y);       /* min(x, b-y) */
    int q = y < (a - x) ? y : (a - x);       /* min(y, a-x) */
    int succ[6][2] = {{a, y}, {x, b}, {0, y},
                      {x, 0}, {x - p, y + p}, {x + q, y - q}};
    for (int k = 0; k < 6; k++) {
        int sx = succ[k][0], sy = succ[k][1];
        if (state_in_path(sx, sy, path_len)) continue;
        (*nodes)++;
        path_x[path_len] = sx; path_y[path_len] = sy;
        path_op[path_len] = k; path_len++;
        if (dls(lim - 1, a, b, t, nodes)) return 1;
        path_len--; /* backtrack */
    }
    return 0;
}

static void dfid(int a, int b, int t) {
    printf("\nJugs %dL & %dL, target=%dL\n", a, b, t);
    int maxlim = (a + 1) * (b + 1);
    for (int lim = 0; lim <= maxlim; lim++) {
        path_x[0] = 0; path_y[0] = 0; path_op[0] = -1; path_len = 1;
        int nodes = 0;
        if (dls(lim, a, b, t, &nodes)) {
            for (int i = 0; i < path_len; i++) {
                if (path_op[i] < 0)
                    printf("  %-8s -> (%d, %d)\n", "Start", path_x[i], path_y[i]);
                else
                    printf("  %-8s -> (%d, %d)\n", OPS[path_op[i]], path_x[i], path_y[i]);
            }
            printf("Depth %d, nodes=%d\n", path_len - 1, nodes);
            return;
        }
    }
    printf("No solution\n");
}

int main(void) {
    dfid(4, 3, 2);
    dfid(5, 3, 4);
    dfid(4, 2, 3);
    return 0;
}
