# Lab codes from the zip — notes, test results, and things to fix before the exam

> Note (2026-10-28, user request): this repo is now Prolog only.
> The `python/` files from the zip were removed from the repo, and
> `experiments/` was kept exactly as it was. The Python test results
> below are kept here for reference only — the Python files themselves
> are no longer in the repo.

The files in `lab-prolog/` are the Prolog codes from
`aisc_lab_codes_0_cf1x.zip`, added verbatim (original filenames kept).
They are **additional** versions — they do **not** replace the
self-running Turbo Prolog files in `experiments/`, which are still the
complete demos for all 12 experiments.

All 8 Python files were run on 2026-10-28 with `MPLBACKEND=Agg`
(no plot window). The Prolog files in `lab-prolog/` have no `goal`
section, so they do not run by themselves — load them in Turbo Prolog
and fire the queries by hand (see below).

## Map: zip file → experiment

| Zip file in this repo | Experiment | Language | Runs? |
|---|---|---|---|
| `python/exp1_water_jug_dfid.py` | 1 Water Jug (DFID) | Python | Yes |
| `python/8puzzle.py` | 2 8-Puzzle (A*) | Python | Yes |
| `python/exp3_minimax_alphabeta.py` | 3 Min-Max + Alpha-Beta | Python | Yes |
| `python/perceptron.py` | 4 Perceptron | Python | Yes, but see XOR bug below |
| `lab-prolog/exp5.pro` | 5 List Processing | Turbo Prolog (definitions only) | Definitions only, no demo |
| `python/exp6_kohonen_lvq.py` | 6 Kohonen + LVQ | Python (numpy, matplotlib) | Yes |
| `lab-prolog/exp7.pro` | 7 Kinship | Turbo Prolog (definitions only) | Definitions only, no demo; see grandchild bug below |
| `python/hopfield.py` | 8 Hopfield | Python (numpy) | Yes |
| `python/mamdaniFuzzy.py` | 9 Mamdani Fuzzy | Python (numpy) | Yes, but fuzzification only — see below |
| `python/exp10_genetic_algorithm.py` | 10 Genetic Algorithm | Python (matplotlib) | Yes |
| `lab-prolog/exp11.pro` | 11 Food inference | Turbo Prolog (definitions only) | Definitions only, no demo |
| `lab-prolog/exp12.pro` | 12 Family inference | Turbo Prolog (definitions only) | Definitions only, no demo |

There is no Python version of Exp 5, 7, 11 or 12 in the zip, and no
lab-Prolog version of Exp 1, 2, 3, 4, 6, 8, 9 or 10. That is why the
two folders together cover all 12 experiments, but neither does alone.

## How to run the Python files

```bash
python3 python/exp1_water_jug_dfid.py
python3 python/8puzzle.py
# etc.
```

Exp 6 and Exp 10 need numpy and matplotlib:

```bash
pip install numpy matplotlib
```

Exp 6 saves `som_plot.png` in the folder you run it from and shows a
plot window; Exp 10 shows a convergence plot. On a machine without a
display, run with `MPLBACKEND=Agg python3 python/exp6_kohonen_lvq.py`
(then the plot window is skipped, but `som_plot.png` is still saved).

## How to use the lab-Prolog files

Load the file in Turbo Prolog (DOSBox, same as `experiments/`), then
type the query yourself — there is no `goal` section to run it for you.
Examples:

- `exp5.pro`: `sum([5,10,15,20], S).`, `len([5,10,15,20], N).`,
  `append([1,2], [3,4], C).`, `member(15, [5,10,15,20]).`,
  `delete(15, [5,10,15,20], D).`
- `exp7.pro`: `cousin(X, rohan).`, `ancestor(X, arjun).`,
  `sibling(X, amit).` — the family here is raj / amit / sunita /
  rohan / pooja / kiran / arjun / meera, not the tom / bob family in
  `experiments/07_kinship.pro`.
- `exp11.pro`: `likes(john, peanuts).`, `food(F).`, `eats(harry, barley).`
- `exp12.pro`: `grandparent(asha, chitra).`, `ancestor(asha, dev).`,
  `sibling(bala, gita).`

## Test results (Python, run 2026-10-28)

- **Exp 1:** depth 6 for 4 L / 3 L → 2 L and for 5 L / 3 L → 4 L;
  4 L / 2 L → 3 L has no solution. The path differs from
  `experiments/01_water_jug.pro` (a different valid route, ending
  (2, 3) for the first case) — same depth, same answer.
- **Exp 2:** moves 2, nodes expanded 3 for both heuristics — but this
  is a **different start and goal** from the exam paper: start
  (1, 2, 3, 4, 0, 6, 7, 5, 8), goal (1, 2, 3, 4, 5, 6, 7, 8, 0).
  The exam paper's start/goal are in `experiments/02_8_puzzle.pro`
  (cost 5). Do not quote "moves 2" for the exam paper's board.
- **Exp 3:** Tree 1: Min-Max 5, 8 leaves; Alpha-Beta 5, 5 leaves;
  best move left. Tree 2 (reversed): Min-Max 5, 8 leaves;
  Alpha-Beta 5, 7 leaves; best move right.
- **Exp 4:** AND converges (weights 1, 1, bias −1), OR converges
  (weights 1, 1, bias +1). See the XOR bug below.
- **Exp 6:** Part 1 clusters {x2, x4} and {x1, x3} (same clusters as
  `experiments/06_kohonen_lvq.pro`, winner numbers swapped);
  LVQ accuracy 100% on the random 2-D data in the file.
- **Exp 8:** exact recall True for T, L and X with 4 random flipped
  pixels; energies −280, −280, −276. Note the flipped pixels are
  random (`np.random.choice`), so the noisy input changes every run.
- **Exp 10:** this run reached best 11111 (x = 31, f = 961) in all
  three parameter runs (pop 6 / pm 0.02, pop 20 / pm 0.02,
  pop 6 / pm 0.2). The population is random, so a different run can
  give a different generation-0 table — the 961 best is not
  guaranteed on every run.

## ⚠️ Fix these before the exam — the zip files are kept verbatim, so these are NOT fixed in the files themselves

### 1. Exp 4 Perceptron — XOR target is actually XNOR

In `python/perceptron.py`, the gates are:

```python
"AND": [-1, -1, -1, 1],
"OR":  [-1, 1, 1, 1],
"XOR": [1, -1, -1, 1]   # ← this is XNOR, not XOR
```

For inputs (−1,−1), (−1,1), (1,−1), (1,1), XOR must be
`[-1, 1, 1, -1]`. The file as supplied still does not converge in
50 epochs (so the "XOR cannot be learned" conclusion still holds),
but its final predictions are [-1, -1, -1, 1] — that is AND, not XOR.
Change the XOR line to `[-1, 1, 1, -1]` before showing it to an
examiner.

### 2. Exp 7 Kinship — `grandchild` is written backwards

In `lab-prolog/exp7.pro`:

```prolog
grandchild(G,C) :- parent(G,P), parent(P,C).
```

That says G is the grand*parent* of C (G is parent of P, P is parent
of C). A grandchild should be:

```prolog
grandchild(G,C) :- parent(C,P), parent(P,G).
```

Use the corrected version for any grandchild query, or use
`experiments/07_kinship.pro`, which has it the right way round.

### 3. Exp 9 Fuzzy — fuzzification only, no controller output

`python/mamdaniFuzzy.py` defines triangular, trapezoidal, Gaussian
and sigmoid membership functions and prints memberships for
T = 25 °C, H = 70% — but it does **not** evaluate the rules, do
Mamdani clipping/aggregation, or defuzzify (no Centre of Gravity,
no Mean/Smallest/Largest-of-Max, no sweep, no crisp fan speed).
For the full controller, use `experiments/09_fuzzy_fan.pro`
(28 °C / 65% → about 58.4% by Centre of Gravity).

### 4. Lab-Prolog files have no demo output

`lab-prolog/exp5.pro`, `exp7.pro`, `exp11.pro` and `exp12.pro`
contain predicates and clauses only. If the examiner asks for the
printed answers, either fire the queries above by hand, or use the
matching self-running file in `experiments/`, which prints them.
