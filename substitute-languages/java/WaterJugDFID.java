// Exp 1: Water Jug Problem using DFID
// Same algorithm as exp1_water_jug_dfid.py. No external libraries.
import java.util.ArrayList;
import java.util.List;

public class WaterJugDFID {

    static class Step {
        String op;
        int x, y;
        Step(String op, int x, int y) { this.op = op; this.x = x; this.y = y; }
    }

    static class Result {
        List<Step> path;
        int nodes;
        Result(List<Step> path, int nodes) { this.path = path; this.nodes = nodes; }
    }

    // Depth-limited search. Returns null path when not found in this limit.
    static Result dls(List<Step> path, int lim, int a, int b, int t, int n) {
        Step last = path.get(path.size() - 1);
        int x = last.x, y = last.y;
        if (x == t) return new Result(path, n);
        if (lim == 0) return new Result(null, n);
        int p = Math.min(x, b - y);
        int q = Math.min(y, a - x);
        String[][] ops = {
            {"Fill A", String.valueOf(a), String.valueOf(y)},
            {"Fill B", String.valueOf(x), String.valueOf(b)},
            {"Empty A", "0", String.valueOf(y)},
            {"Empty B", String.valueOf(x), "0"},
            {"A->B", String.valueOf(x - p), String.valueOf(y + p)},
            {"B->A", String.valueOf(x + q), String.valueOf(y - q)}
        };
        for (String[] o : ops) {
            int sx = Integer.parseInt(o[1]);
            int sy = Integer.parseInt(o[2]);
            boolean seen = false;
            for (Step s : path) if (s.x == sx && s.y == sy) { seen = true; break; }
            if (!seen) {
                n += 1;
                List<Step> next = new ArrayList<>(path);
                next.add(new Step(o[0], sx, sy));
                Result r = dls(next, lim - 1, a, b, t, n);
                n = r.nodes;
                if (r.path != null) return r;
            }
        }
        return new Result(null, n);
    }

    static void dfid(int a, int b, int t) {
        System.out.println("\nJugs " + a + "L & " + b + "L, target=" + t + "L");
        for (int lim = 0; lim < (a + 1) * (b + 1) + 1; lim++) {
            List<Step> start = new ArrayList<>();
            start.add(new Step("Start", 0, 0));
            Result r = dls(start, lim, a, b, t, 0);
            if (r.path != null) {
                for (Step s : r.path)
                    System.out.printf("  %-8s -> (%d, %d)%n", s.op, s.x, s.y);
                System.out.println("Depth " + (r.path.size() - 1) + ", nodes=" + r.nodes);
                return;
            }
        }
        System.out.println("No solution");
    }

    public static void main(String[] args) {
        dfid(4, 3, 2);
        dfid(5, 3, 4);
        dfid(4, 2, 3);
    }
}
