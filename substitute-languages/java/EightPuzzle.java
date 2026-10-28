// Exp 2: 8-Puzzle using A* search
// Same algorithm as 8puzzle.py. No external libraries.
import java.util.*;

public class EightPuzzle {

    static final int[] GOAL = {1, 2, 3, 4, 5, 6, 7, 8, 0};

    static int misplaced(int[] s) {
        int c = 0;
        for (int i = 0; i < 9; i++) if (s[i] != GOAL[i] && s[i] != 0) c++;
        return c;
    }

    static int manhattan(int[] s) {
        int d = 0;
        for (int i = 0; i < 9; i++) {
            int v = s[i];
            if (v != 0) {
                int j = 0;
                for (int k = 0; k < 9; k++) if (GOAL[k] == v) { j = k; break; }
                d += Math.abs(i / 3 - j / 3) + Math.abs(i % 3 - j % 3);
            }
        }
        return d;
    }

    static String key(int[] s) { return Arrays.toString(s); }

    static int compareState(int[] a, int[] b) {
        for (int i = 0; i < 9; i++) {
            if (a[i] != b[i]) return Integer.compare(a[i], b[i]);
        }
        return 0;
    }

    static class Node {
        int f, g;
        int[] state;
        List<int[]> path;
        Node(int f, int g, int[] state, List<int[]> path) {
            this.f = f; this.g = g; this.state = state; this.path = path;
        }
    }

    // h: 0 = misplaced, 1 = manhattan
    static int solve(int h) {
        int[] start = {1, 2, 3, 4, 0, 6, 7, 5, 8};
        int h0 = (h == 0) ? misplaced(start) : manhattan(start);
        PriorityQueue<Node> pq = new PriorityQueue<>((a, b) -> {
            if (a.f != b.f) return Integer.compare(a.f, b.f);
            if (a.g != b.g) return Integer.compare(a.g, b.g);
            return compareState(a.state, b.state);
        });
        pq.add(new Node(h0, 0, start, new ArrayList<>()));
        Map<String, Integer> best = new HashMap<>();
        best.put(key(start), 0);
        Set<String> closed = new HashSet<>();
        int expanded = 0;

        String[] moves = {"Up", "Down", "Left", "Right"};
        int[] dz = {-3, 3, -1, 1};

        while (!pq.isEmpty()) {
            Node cur = pq.poll();
            int[] s = cur.state;
            int g = cur.g;
            if (closed.contains(key(s))) continue;
            closed.add(key(s));
            expanded++;

            if (Arrays.equals(s, GOAL)) {
                List<int[]> full = new ArrayList<>(cur.path);
                full.add(s);
                for (int[] state : full) {
                    for (int i = 0; i < 9; i += 3)
                        System.out.println("(" + state[i] + ", " + state[i + 1] + ", " + state[i + 2] + ")");
                    System.out.println();
                }
                System.out.println("Moves: " + g + ", Nodes expanded: " + expanded);
                return expanded;
            }

            int z = 0;
            for (int i = 0; i < 9; i++) if (s[i] == 0) { z = i; break; }
            for (int m = 0; m < 4; m++) {
                int nz = z + dz[m];
                if (nz < 0 || nz >= 9) continue;
                if (moves[m].equals("Left") && z % 3 == 0) continue;
                if (moves[m].equals("Right") && z % 3 == 2) continue;
                int[] t = s.clone();
                int tmp = t[z]; t[z] = t[nz]; t[nz] = tmp;
                int ng = g + 1;
                if (!best.containsKey(key(t)) || ng < best.get(key(t))) {
                    best.put(key(t), ng);
                    int hv = (h == 0) ? misplaced(t) : manhattan(t);
                    List<int[]> np = new ArrayList<>(cur.path);
                    np.add(s);
                    pq.add(new Node(ng + hv, ng, t, np));
                }
            }
        }
        System.out.println("No solution found.");
        return expanded;
    }

    public static void main(String[] args) {
        System.out.println("Misplaced Tiles:");
        int n1 = solve(0);
        System.out.println("Manhattan Distance:");
        int n2 = solve(1);
        System.out.println("Comparison: " + n1 + " " + n2);
    }
}
