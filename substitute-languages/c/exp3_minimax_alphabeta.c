/* Exp 3: Min-Max with Alpha-Beta pruning
 * Port of exp3_minimax_alphabeta.py. Standard library only.
 * Compile: gcc -O2 -o exp3_minimax_alphabeta exp3_minimax_alphabeta.c -lm
 * Run: ./exp3_minimax_alphabeta
 */
#include <stdio.h>
#include <math.h>
#include <string.h>

typedef struct Node {
    int is_leaf;
    int value;               /* leaf value */
    struct Node *ch[2];      /* internal: exactly 2 children */
} Node;

static Node *leaf(int v) {
    static Node pool[64];
    static int n = 0;
    Node *nd = &pool[n++];
    nd->is_leaf = 1; nd->value = v; nd->ch[0] = nd->ch[1] = NULL;
    return nd;
}
static Node *branch(Node *a, Node *b) {
    static Node pool[64];
    static int n = 0;
    Node *nd = &pool[n++];
    nd->is_leaf = 0; nd->value = 0; nd->ch[0] = a; nd->ch[1] = b;
    return nd;
}

static int minimax(Node *n, int mx, int *c) {
    if (n->is_leaf) { (*c)++; return n->value; }
    int v0 = minimax(n->ch[0], !mx, c);
    int v1 = minimax(n->ch[1], !mx, c);
    return mx ? (v0 > v1 ? v0 : v1) : (v0 < v1 ? v0 : v1);
}

static void print_ab(double v) {
    if (v == -INFINITY) printf("-inf");
    else if (v == INFINITY) printf("inf");
    else printf("%d", (int)v);
}

static int alphabeta(Node *n, int mx, double a, double b, int *c, int d) {
    if (n->is_leaf) {
        (*c)++;
        for (int i = 0; i < d; i++) printf("  ");
        printf("Leaf %d\n", n->value);
        return n->value;
    }
    double best = mx ? -INFINITY : INFINITY;
    for (int i = 0; i < 2; i++) {
        int v = alphabeta(n->ch[i], !mx, a, b, c, d + 1);
        if (mx) { if (v > best) best = v; if (best > a) a = best; }
        else    { if (v < best) best = v; if (best < b) b = best; }
        if (a >= b) {
            if (i < 1) {
                for (int k = 0; k < d; k++) printf("  ");
                printf("  >> PRUNED\n");
            }
            break;
        }
    }
    for (int i = 0; i < d; i++) printf("  ");
    printf("%s: a=", mx ? "MAX" : "MIN");
    print_ab(a);
    printf(", b=");
    print_ab(b);
    printf(", ret=%d\n", (int)best);
    return (int)best;
}

static void print_tree(Node *n) {
    if (n->is_leaf) { printf("%d", n->value); return; }
    printf("[");
    print_tree(n->ch[0]);
    printf(", ");
    print_tree(n->ch[1]);
    printf("]");
}

/* Reverse a tree: [rev(c) for c in reversed(children)] */
static Node *rev(Node *n) {
    if (n->is_leaf) return leaf(n->value);
    return branch(rev(n->ch[1]), rev(n->ch[0]));
}

static void run(Node *t, const char *title) {
    printf("\n===== %s: ", title);
    print_tree(t);
    printf(" =====\n");
    int c1 = 0, c2 = 0;
    int mm = minimax(t, 1, &c1);
    printf("--- Alpha-Beta trace ---\n");
    int ab = alphabeta(t, 1, -INFINITY, INFINITY, &c2, 0);
    int dummy = 0;
    int v0 = minimax(t->ch[0], 0, &dummy);
    int v1 = minimax(t->ch[1], 0, &dummy);
    const char *move = (v0 >= v1) ? "left" : "right";
    printf("\nMinMax=%d leaves=%d, AlphaBeta=%d leaves=%d\n", mm, c1, ab, c2);
    printf("Best move: %s branch\n", move);
}

int main(void) {
    /* t1 = [[[3,5],[6,9]],[[1,2],[0,-1]]] */
    Node *t1 = branch(
        branch(branch(leaf(3), leaf(5)), branch(leaf(6), leaf(9))),
        branch(branch(leaf(1), leaf(2)), branch(leaf(0), leaf(-1))));
    run(t1, "Tree 1");
    run(rev(t1), "Tree 2 (reversed)");
    printf("\nGood ordering -> more pruning -> fewer leaf evaluations.\n");
    return 0;
}
