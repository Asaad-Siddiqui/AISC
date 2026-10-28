// Exp 8: Associative Memory using a Discrete Hopfield Network
// Same algorithm as hopfield.py, plain arrays.
// Fixed seed 42 (Python file used unseeded random; seed 42 makes
// the Java run reproducible). No external libraries.
import java.util.*;

public class Hopfield {

    static final String[] NAMES = {"T", "L", "X"};
    static final int[][][] PATTERNS = {
        {{1,1,1,1,1},{-1,-1,1,-1,-1},{-1,-1,1,-1,-1},{-1,-1,1,-1,-1},{-1,-1,1,-1,-1}},
        {{1,-1,-1,-1,-1},{1,-1,-1,-1,-1},{1,-1,-1,-1,-1},{1,-1,-1,-1,-1},{1,1,1,1,1}},
        {{1,-1,-1,-1,1},{-1,1,-1,1,-1},{-1,-1,1,-1,-1},{-1,1,-1,1,-1},{1,-1,-1,-1,1}}
    };

    static int[] flatten(int[][] p) {
        int[] out = new int[25];
        for (int r = 0; r < 5; r++) for (int c = 0; c < 5; c++) out[r * 5 + c] = p[r][c];
        return out;
    }

    static double energy(int[] y, int[][] W) {
        double s = 0;
        for (int i = 0; i < 25; i++) for (int j = 0; j < 25; j++) s += y[i] * W[i][j] * y[j];
        return -0.5 * s;
    }

    static void show(int[] y) {
        for (int r = 0; r < 5; r++) {
            StringBuilder sb = new StringBuilder();
            for (int c = 0; c < 5; c++) {
                if (c > 0) sb.append(" ");
                sb.append(y[r * 5 + c] == 1 ? "#" : ".");
            }
            System.out.println(sb);
        }
    }

    public static void main(String[] args) {
        int[][] P = new int[3][25];
        for (int k = 0; k < 3; k++) P[k] = flatten(PATTERNS[k]);
        int[][] W = new int[25][25];
        for (int i = 0; i < 25; i++)
            for (int j = 0; j < 25; j++) {
                int s = 0;
                for (int k = 0; k < 3; k++) s += P[k][i] * P[k][j];
                W[i][j] = s;
            }
        for (int i = 0; i < 25; i++) W[i][i] = 0;

        Random rng = new Random(42);
        for (int k = 0; k < 3; k++) {
            int[] original = P[k].clone();
            int[] y = original.clone();
            // Flip 4 pixels, no replacement: shuffle 0..24, take first 4
            List<Integer> ids = new ArrayList<>();
            for (int i = 0; i < 25; i++) ids.add(i);
            Collections.shuffle(ids, rng);
            for (int t = 0; t < 4; t++) y[ids.get(t)] *= -1;

            System.out.println("\nStored pattern: " + NAMES[k]);
            System.out.println("Before recall:");
            show(y);

            for (int sweep = 0; sweep < 20; sweep++) {
                int[] old = y.clone();
                List<Integer> perm = new ArrayList<>();
                for (int i = 0; i < 25; i++) perm.add(i);
                Collections.shuffle(perm, rng);
                for (int i : perm) {
                    int net = 0;
                    for (int j = 0; j < 25; j++) net += W[i][j] * y[j];
                    y[i] = net >= 0 ? 1 : -1;
                }
                if (Arrays.equals(old, y)) break;
            }
            System.out.println("After recall:");
            show(y);
            System.out.println("Energy: " + energy(y, W));
            System.out.println("Exact recall: " + (Arrays.equals(y, original) ? "True" : "False"));
        }
    }
}
