// Exp 4: Single Layer Perceptron
// Same algorithm as perceptron.py, plain arrays, no numpy.
// NOTE: the XOR target is kept EXACTLY as in the Python file,
// [1,-1,-1,1] (which is in fact XNOR, not XOR). It is NOT "fixed" here.
import java.util.Arrays;

public class Perceptron {

    static final int[][] X = {{-1, -1}, {-1, 1}, {1, -1}, {1, 1}};

    // Mimic numpy float printing: 1.0 prints as "1.", 0.0 as "0."
    static String np(double v) {
        if (v == Math.floor(v)) return String.format("%d.", (long) v);
        return String.valueOf(v);
    }

    static String npArr(double[] w) {
        return "[" + np(w[0]) + " " + np(w[1]) + "]";
    }

    static void train(String name, int[] target) {
        double[] w = {0.0, 0.0};
        int b = 0;
        int eta = 1;

        for (int epoch = 0; epoch < 50; epoch++) {
            int errors = 0;
            for (int i = 0; i < X.length; i++) {
                int[] x = X[i];
                int t = target[i];
                double dot = w[0] * x[0] + w[1] * x[1] + b;
                int y = dot >= 0 ? 1 : -1;
                if (y != t) {
                    w[0] += eta * t * x[0];
                    w[1] += eta * t * x[1];
                    b += eta * t;
                    errors++;
                }
            }
            System.out.println(name + " Epoch: " + (epoch + 1)
                    + " Weights: " + npArr(w) + " Bias: " + b + " Errors: " + errors);
            if (errors == 0) break;
        }
        System.out.println("Final weights: " + npArr(w) + " Bias: " + b);
        int[] pred = new int[X.length];
        for (int i = 0; i < X.length; i++) {
            double dot = w[0] * X[i][0] + w[1] * X[i][1] + b;
            pred[i] = dot >= 0 ? 1 : -1;
        }
        System.out.println("Predictions: " + Arrays.toString(pred));
        System.out.println();
    }

    public static void main(String[] args) {
        train("AND", new int[]{-1, -1, -1, 1});
        train("OR", new int[]{-1, 1, 1, 1});
        train("XOR", new int[]{1, -1, -1, 1});
    }
}
