import heapq

GOAL = (1, 2, 3, 4, 5, 6, 7, 8, 0)

def misplaced(s):
    return sum(s[i] != GOAL[i] and s[i] != 0
               for i in range(9))

def manhattan(s):
    d = 0
    for i, v in enumerate(s):
        if v:
            j = GOAL.index(v)
            d += abs(i // 3 - j // 3) + abs(i % 3 - j % 3)
    return d

def solve(h):
    start = (1, 2, 3, 4, 0, 6, 7, 5, 8)
    pq = [(h(start), 0, start, [])]
    best = {start: 0}
    closed = set()
    expanded = 0

    while pq:
        f, g, s, path = heapq.heappop(pq)

        if s in closed:
            continue
        closed.add(s)
        expanded += 1

        if s == GOAL:
            for state in path + [s]:
                for i in range(0, 9, 3):
                    print(state[i:i+3])
                print()
            print("Moves:", g, "Nodes expanded:", expanded)
            return expanded

        z = s.index(0)
        for move, dz in [("Up", -3), ("Down", 3),
                         ("Left", -1), ("Right", 1)]:
            nz = z + dz
            if not 0 <= nz < 9:
                continue
            if move == "Left" and z % 3 == 0:
                continue
            if move == "Right" and z % 3 == 2:
                continue

            t = list(s)
            t[z], t[nz] = t[nz], t[z]
            t = tuple(t)
            ng = g + 1

            if t not in best or ng < best[t]:
                best[t] = ng
                heapq.heappush(
                    pq, (ng + h(t), ng, t, path + [s])
                )

    print("No solution found.")
    return expanded

print("Misplaced Tiles:")
n1 = solve(misplaced)

print("Manhattan Distance:")
n2 = solve(manhattan)

print("Comparison:", n1, n2)