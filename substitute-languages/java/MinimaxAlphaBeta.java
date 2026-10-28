// Exp 3: Min-Max with Alpha-Beta pruning
// Same algorithm as exp3_minimax_alphabeta.py. No external libraries.
import java.util.*;

public class MinimaxAlphaBeta {

    // A tree node is either an Integer leaf or a List<Object> of children.
    static String fmtNum(double v) {
        if (Double.isInfinite(v)) return v < 0 ? "-inf" : "inf";
        if (v == Math.floor(v)) return String.valueOf((long) v);
        return String.valueOf(v);
    }

    static String fmtTree(Object n) {
        if (n instanceof Integer) return String.valueOf(n);
        @SuppressWarnings("unchecked")
        List<Object> list = (List<Object>) n;
        StringBuilder sb = new StringBuilder("[");
        for (int i = 0; i < list.size(); i++) {
            if (i > 0) sb.append(", ");
            sb.append(fmtTree(list.get(i)));
        }
        sb.append("]");
        return sb.toString();
    }

    static int minimax(Object n, boolean mx, int[] c) {
        if (n instanceof Integer) { c[0]++; return (Integer) n; }
        @SuppressWarnings("unchecked")
        List<Object> list = (List<Object>) n;
        List<Integer> v = new ArrayList<>();
        for (Object ch : list) v.add(minimax(ch, !mx, c));
        return mx ? Collections.max(v) : Collections.min(v);
    }

    static double alphabeta(Object n, boolean mx, double a, double b, int[] c, int d) {
        String pad = "  ".repeat(d);
        if (n instanceof Integer) {
            c[0]++;
            System.out.println(pad + "Leaf " + n);
            return (Integer) n;
        }
        @SuppressWarnings("unchecked")
        List<Object> list = (List<Object>) n;
        double best = mx ? Double.NEGATIVE_INFINITY : Double.POSITIVE_INFINITY;
        for (int i = 0; i < list.size(); i++) {
            double v = alphabeta(list.get(i), !mx, a, b, c, d + 1);
            if (mx) { best = Math.max(best, v); a = Math.max(a, best); }
            else { best = Math.min(best, v); b = Math.min(b, best); }
            if (a >= b) {
                if (i < list.size() - 1) System.out.println(pad + "  >> PRUNED");
                break;
            }
        }
        System.out.println(pad + (mx ? "MAX" : "MIN") + ": a=" + fmtNum(a) + ", b=" + fmtNum(b) + ", ret=" + fmtNum(best));
        return best;
    }

    static Object rev(Object n) {
        if (n instanceof Integer) return n;
        @SuppressWarnings("unchecked")
        List<Object> list = (List<Object>) n;
        List<Object> out = new ArrayList<>();
        for (int i = list.size() - 1; i >= 0; i--) out.add(rev(list.get(i)));
        return out;
    }

    static void run(Object t, String title) {
        System.out.println("\n===== " + title + ": " + fmtTree(t) + " =====");
        int[] c1 = {0}, c2 = {0};
        int mm = minimax(t, true, c1);
        System.out.println("--- Alpha-Beta trace ---");
        double ab = alphabeta(t, true, Double.NEGATIVE_INFINITY, Double.POSITIVE_INFINITY, c2, 0);
        @SuppressWarnings("unchecked")
        List<Object> top = (List<Object>) t;
        List<Integer> vals = new ArrayList<>();
        for (Object ch : top) vals.add(minimax(ch, false, new int[]{0}));
        int mx = Collections.max(vals);
        String move = vals.indexOf(mx) == 0 ? "left" : "right";
        System.out.println("\nMinMax=" + mm + " leaves=" + c1[0] + ", AlphaBeta=" + fmtNum(ab) + " leaves=" + c2[0]);
        System.out.println("Best move: " + move + " branch");
    }

    static List<Object> ints(int... xs) {
        List<Object> out = new ArrayList<>();
        for (int x : xs) out.add(x);
        return out;
    }

    @SafeVarargs
    static List<Object> nodes(List<Object>... xs) {
        List<Object> out = new ArrayList<>();
        for (List<Object> x : xs) out.add(x);
        return out;
    }

    public static void main(String[] args) {
        // t1 = [[[3,5],[6,9]],[[1,2],[0,-1]]]
        Object t1 = nodes(
            nodes(ints(3, 5), ints(6, 9)),
            nodes(ints(1, 2), ints(0, -1))
        );
        run(t1, "Tree 1");
        run(rev(t1), "Tree 2 (reversed)");
        System.out.println("\nGood ordering -> more pruning -> fewer leaf evaluations.");
    }
}
