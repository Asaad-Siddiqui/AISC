// Exp 10: Genetic Algorithm, maximise f(x)=x^2, x in 0..31 (5-bit)
// Same algorithm as exp10_genetic_algorithm.py, plain Java.
// One Random(42) continuing across runs (Python used the global random
// module continuing across runs). Plots are replaced by printed numbers.
import java.util.*;

public class GeneticAlgorithm {

    static final Random RNG = new Random(42);

    static int fit(String c) {
        int x = Integer.parseInt(c, 2);
        return x * x;
    }

    static String mutate(String c, double pm) {
        StringBuilder sb = new StringBuilder();
        for (int i = 0; i < c.length(); i++) {
            char b = c.charAt(i);
            sb.append(RNG.nextDouble() > pm ? b : (b == '0' ? '1' : '0'));
        }
        return sb.toString();
    }

    static String choiceWeighted(List<String> pop, List<Integer> f) {
        double total = 0;
        for (int v : f) total += v + 1e-9;
        double r = RNG.nextDouble() * total;
        double cum = 0;
        for (int i = 0; i < pop.size(); i++) {
            cum += f.get(i) + 1e-9;
            if (r < cum) return pop.get(i);
        }
        return pop.get(pop.size() - 1);
    }

    static String maxChrom(List<String> pop) {
        String best = pop.get(0);
        for (String c : pop) if (fit(c) > fit(best)) best = c;
        return best;
    }

    static class RunResult {
        String bc;
        List<Integer> bh = new ArrayList<>();
        List<Double> ah = new ArrayList<>();
    }

    static RunResult run(int ps, double pm, double pc, int gens, boolean table) {
        List<String> pop = new ArrayList<>();
        for (int i = 0; i < ps; i++) {
            StringBuilder sb = new StringBuilder();
            for (int k = 0; k < 5; k++) sb.append(RNG.nextInt(2) == 0 ? '0' : '1');
            pop.add(sb.toString());
        }
        RunResult res = new RunResult();
        String bc = maxChrom(pop);
        for (int g = 0; g < gens; g++) {
            List<Integer> f = new ArrayList<>();
            for (String c : pop) f.add(fit(c));
            int t = 0;
            for (int v : f) t += v;
            double av = (double) t / f.size();
            int bestF = Collections.max(f);
            res.bh.add(bestF);
            res.ah.add(av);
            // bc = max([bc] + pop, first max wins)
            List<String> cand = new ArrayList<>();
            cand.add(bc); cand.addAll(pop);
            bc = maxChrom(cand);
            if (table && g == 0) {
                System.out.println("Chrom   x   f(x)  Prob   Exp");
                for (int i = 0; i < pop.size(); i++) {
                    String c = pop.get(i);
                    int fi = f.get(i);
                    System.out.printf("%s  %2d  %4d  %.3f  %.2f%n",
                            c, Integer.parseInt(c, 2), fi, (double) fi / t, fi / av);
                }
            }
            List<String> next = new ArrayList<>();
            while (next.size() < ps) {
                String p1 = choiceWeighted(pop, f);
                String p2 = choiceWeighted(pop, f);
                if (RNG.nextDouble() < pc) {
                    int cut = RNG.nextInt(4) + 1; // 1..4
                    String n1 = p1.substring(0, cut) + p2.substring(cut);
                    String n2 = p2.substring(0, cut) + p1.substring(cut);
                    p1 = n1; p2 = n2;
                }
                next.add(mutate(p1, pm));
                next.add(mutate(p2, pm));
            }
            pop = new ArrayList<>(next.subList(0, ps));
        }
        res.bc = bc;
        return res;
    }

    public static void main(String[] args) {
        System.out.println("=== Run 1: pop=6, pm=0.02 ===");
        RunResult r1 = run(6, 0.02, 0.8, 50, true);
        System.out.println("Best=" + r1.bc + ", x=" + Integer.parseInt(r1.bc, 2) + ", f=" + fit(r1.bc));
        for (int g = 0; g < 50; g += 10)
            System.out.printf("Gen %2d: best=%d, avg=%.1f%n", g + 1, r1.bh.get(g), r1.ah.get(g));

        System.out.println("\n=== Run 2: pop=20, pm=0.02 ===");
        RunResult r2 = run(20, 0.02, 0.8, 50, false);
        System.out.println("Best=" + r2.bc + ", f=" + fit(r2.bc) + ", avg=" + String.format("%.1f", r2.ah.get(r2.ah.size() - 1)));

        System.out.println("\n=== Run 3: pop=6, pm=0.2 ===");
        RunResult r3 = run(6, 0.2, 0.8, 50, false);
        System.out.println("Best=" + r3.bc + ", f=" + fit(r3.bc) + ", avg=" + String.format("%.1f", r3.ah.get(r3.ah.size() - 1)));
    }
}
