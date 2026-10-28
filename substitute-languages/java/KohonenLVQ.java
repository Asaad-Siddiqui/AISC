// Exp 6: Kohonen SOM and LVQ
// Same algorithm as exp6_kohonen_lvq.py, plain arrays, no numpy/matplotlib.
// Plots are replaced by printed weights/accuracy (see below).
// Random numbers come from java.util.Random, so Part 2/3 data differ
// from numpy's - the algorithm is the same, not bit-identical data.
import java.util.*;

public class KohonenLVQ {

    static int argmin(double[] d) {
        int j = 0;
        for (int i = 1; i < d.length; i++) if (d[i] < d[j]) j = i;
        return j;
    }

    static double dist2(double[] a, double[] b) {
        double s = 0;
        for (int i = 0; i < a.length; i++) { double d = a[i] - b[i]; s += d * d; }
        return s;
    }

    static String round3(double[] v) {
        StringBuilder sb = new StringBuilder("[");
        for (int i = 0; i < v.length; i++) {
            if (i > 0) sb.append(" ");
            sb.append(String.format("%.3f", v[i]));
        }
        sb.append("]");
        return sb.toString();
    }

    public static void main(String[] args) {
        // Part 1: SOM on 4 vectors, 2 neurons
        double[][] X = {{1,1,0,0},{0,0,0,1},{1,0,0,0},{0,0,1,1}};
        double[][] W = {{0.2,0.6,0.5,0.9},{0.8,0.4,0.7,0.3}};
        double a = 0.6;
        for (int ep = 1; ep <= 5; ep++) {
            System.out.printf("%nEpoch %d, alpha=%.4f%n", ep, a);
            for (int i = 0; i < X.length; i++) {
                double[] D = new double[W.length];
                for (int j = 0; j < W.length; j++) D[j] = dist2(W[j], X[i]);
                int j = argmin(D);
                for (int k = 0; k < W[j].length; k++) W[j][k] += a * (X[i][k] - W[j][k]);
                System.out.println("  x" + (i + 1) + " -> D=" + round3(D) + ", winner=" + (j + 1));
            }
            System.out.println("  W1=" + round3(W[0]));
            System.out.println("  W2=" + round3(W[1]));
            a /= 2;
        }
        Map<Integer, List<String>> cl = new LinkedHashMap<>();
        cl.put(1, new ArrayList<>()); cl.put(2, new ArrayList<>());
        for (int i = 0; i < X.length; i++) {
            double[] D = new double[W.length];
            for (int j = 0; j < W.length; j++) D[j] = dist2(W[j], X[i]);
            cl.get(argmin(D) + 1).add("x" + (i + 1));
        }
        System.out.println("\nFinal clusters: {1: " + cl.get(1) + ", 2: " + cl.get(2) + "}");

        // Part 2: SOM on 2D random points (seed 1, as specified)
        Random rng1 = new Random(1);
        double[][] pts = new double[200][2];
        for (int i = 0; i < 200; i++) { pts[i][0] = rng1.nextDouble(); pts[i][1] = rng1.nextDouble(); }
        int n = 4;
        double[][] w = new double[n][2];
        for (int j = 0; j < n; j++) { w[j][0] = rng1.nextDouble(); w[j][1] = rng1.nextDouble(); }
        double alpha = 0.5;
        int R = 1;
        for (int ep = 0; ep < 30; ep++) {
            for (double[] p : pts) {
                double[] D = new double[n];
                for (int j = 0; j < n; j++) D[j] = dist2(w[j], p);
                int win = argmin(D);
                for (int j = 0; j < n; j++)
                    if (Math.abs(j - win) <= R)
                        for (int k = 0; k < 2; k++) w[j][k] += alpha * (p[k] - w[j][k]);
            }
            alpha *= 0.9;
            if (ep == 15) R = 0;
        }
        System.out.println("\nPart 2 SOM final weights (instead of som_plot.png):");
        for (int j = 0; j < n; j++) System.out.println("  w" + (j + 1) + "=" + round3(w[j]));

        // Part 3: LVQ (seed 2, as specified)
        Random rng2 = new Random(2);
        double[][] A = new double[50][2];
        double[][] B = new double[50][2];
        for (int i = 0; i < 50; i++) { A[i][0] = rng2.nextGaussian() * 0.5; A[i][1] = rng2.nextGaussian() * 0.5; }
        for (int i = 0; i < 50; i++) { B[i][0] = rng2.nextGaussian() * 0.5 + 3; B[i][1] = rng2.nextGaussian() * 0.5 + 3; }
        double[][] data = new double[100][2];
        int[] labels = new int[100];
        for (int i = 0; i < 50; i++) { data[i] = A[i]; labels[i] = 0; }
        for (int i = 0; i < 50; i++) { data[50 + i] = B[i]; labels[50 + i] = 1; }
        double[][] proto = {data[0].clone(), data[50].clone()};
        int[] pcls = {0, 1};
        double la = 0.3;
        for (int ep = 0; ep < 20; ep++) {
            for (int i = 0; i < data.length; i++) {
                double[] D = new double[2];
                for (int j = 0; j < 2; j++) D[j] = dist2(proto[j], data[i]);
                int j = argmin(D);
                double sign = (pcls[j] == labels[i]) ? 1 : -1;
                for (int k = 0; k < 2; k++) proto[j][k] += la * (data[i][k] - proto[j][k]) * sign;
            }
            la *= 0.9;
        }
        int correct = 0;
        for (int i = 0; i < data.length; i++) {
            double[] D = new double[2];
            for (int j = 0; j < 2; j++) D[j] = dist2(proto[j], data[i]);
            if (pcls[argmin(D)] == labels[i]) correct++;
        }
        System.out.println("\nLVQ prototypes: proto0=" + round3(proto[0]) + " proto1=" + round3(proto[1]));
        System.out.printf("%nLVQ accuracy = %.1f %%%n", 100.0 * correct / data.length);
    }
}
