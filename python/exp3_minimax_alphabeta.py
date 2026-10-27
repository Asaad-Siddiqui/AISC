# Exp 3: Min-Max with Alpha-Beta pruning
INF = float("inf")

def minimax(n, mx, c):
    if not isinstance(n, list): c[0] += 1; return n
    v = [minimax(ch, not mx, c) for ch in n]
    return max(v) if mx else min(v)

def alphabeta(n, mx, a, b, c, d=0):
    pad = "  " * d
    if not isinstance(n, list): c[0] += 1; print(f"{pad}Leaf {n}"); return n
    best = -INF if mx else INF
    for i, ch in enumerate(n):
        v = alphabeta(ch, not mx, a, b, c, d+1)
        if mx: best = max(best, v); a = max(a, best)
        else:  best = min(best, v); b = min(b, best)
        if a >= b:
            if i < len(n)-1: print(f"{pad}  >> PRUNED")
            break
    print(f"{pad}{'MAX' if mx else 'MIN'}: a={a}, b={b}, ret={best}")
    return best

def run(t, title):
    print(f"\n===== {title}: {t} =====")
    c1, c2 = [0], [0]
    mm = minimax(t, True, c1)
    print("--- Alpha-Beta trace ---")
    ab = alphabeta(t, True, -INF, INF, c2)
    vals = [minimax(ch, False, [0]) for ch in t]
    move = "left" if vals.index(max(vals)) == 0 else "right"
    print(f"\nMinMax={mm} leaves={c1[0]}, AlphaBeta={ab} leaves={c2[0]}")
    print(f"Best move: {move} branch")

rev = lambda n: [rev(c) for c in reversed(n)] if isinstance(n, list) else n
t1 = [[[3,5],[6,9]],[[1,2],[0,-1]]]
run(t1, "Tree 1")
run(rev(t1), "Tree 2 (reversed)")
print("\nGood ordering -> more pruning -> fewer leaf evaluations.")
