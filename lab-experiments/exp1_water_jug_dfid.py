# Exp 1: Water Jug Problem using DFID

def dls(path, lim, a, b, t, n):
    x, y = path[-1][1]
    if x == t: return path, n
    if lim == 0: return None, n
    p, q = min(x, b-y), min(y, a-x)
    for op, s in [("Fill A",(a,y)),("Fill B",(x,b)),("Empty A",(0,y)),
                  ("Empty B",(x,0)),("A->B",(x-p,y+p)),("B->A",(x+q,y-q))]:
        if s not in [v for _,v in path]:
            n += 1
            r, n = dls(path+[(op,s)], lim-1, a, b, t, n)
            if r: return r, n
    return None, n

def dfid(a, b, t):
    print(f"\nJugs {a}L & {b}L, target={t}L")
    for lim in range((a+1)*(b+1)+1):
        r, n = dls([("Start",(0,0))], lim, a, b, t, 0)
        if r:
            for op, s in r: print(f"  {op:8s} -> {s}")
            print(f"Depth {len(r)-1}, nodes={n}")
            return
    print("No solution")

dfid(4,3,2)
dfid(5,3,4)
dfid(4,2,3)
