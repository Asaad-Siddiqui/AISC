// Exp 9: Mamdani Fuzzy Controller (fuzzification, as in mamdaniFuzzy.py)
// Exact same formulas as the Python file. No external libraries.
public class MamdaniFuzzy {

    static double trimf(double x, double a, double b, double c) {
        return Math.max(0, Math.min((x - a) / (b - a + 1e-9), (c - x) / (c - b + 1e-9)));
    }

    static double trapmf(double x, double a, double b, double c, double d) {
        return Math.max(0, Math.min(Math.min((x - a) / (b - a + 1e-9), 1), (d - x) / (d - c + 1e-9)));
    }

    static double gaussmf(double x, double mean, double sigma) {
        return Math.exp(-0.5 * Math.pow((x - mean) / sigma, 2));
    }

    static double sigmoidmf(double x, double a, double c) {
        return 1.0 / (1.0 + Math.exp(-a * (x - c)));
    }

    public static void main(String[] args) {
        double[] temp = new double[41];
        for (int i = 0; i <= 40; i++) temp[i] = i;
        double[] hum = new double[101];
        for (int i = 0; i <= 100; i++) hum[i] = i;
        double[] speed = new double[101];
        for (int i = 0; i <= 100; i++) speed[i] = i;

        double[] cold = new double[41], warm = new double[41], hot = new double[41];
        for (int i = 0; i <= 40; i++) {
            cold[i] = trapmf(temp[i], 0, 0, 10, 20);
            warm[i] = trimf(temp[i], 10, 20, 30);
            hot[i] = sigmoidmf(temp[i], 0.3, 28);
        }
        double[] low = new double[101], medium = new double[101], high = new double[101];
        for (int i = 0; i <= 100; i++) {
            low[i] = trapmf(hum[i], 0, 0, 25, 50);
            medium[i] = gaussmf(hum[i], 50, 15);
            high[i] = sigmoidmf(hum[i], 0.12, 60);
        }
        double[] slow = new double[101], moderate = new double[101], fast = new double[101];
        for (int i = 0; i <= 100; i++) {
            slow[i] = trapmf(speed[i], 0, 0, 25, 50);
            moderate[i] = trimf(speed[i], 25, 50, 75);
            fast[i] = sigmoidmf(speed[i], 0.12, 60);
        }

        int T = 25, H = 70;
        System.out.println("Temperature: " + T);
        System.out.println("Cold membership: " + cold[T]);
        System.out.println("Warm membership: " + warm[T]);
        System.out.println("Hot membership: " + hot[T]);

        System.out.println("\nHumidity: " + H);
        System.out.println("Low membership: " + low[H]);
        System.out.println("Medium membership: " + medium[H]);
        System.out.println("High membership: " + high[H]);

        System.out.println("\nSpeed membership at 50:");
        System.out.println("Slow: " + slow[50]);
        System.out.println("Moderate: " + moderate[50]);
        System.out.println("Fast: " + fast[50]);
    }
}
