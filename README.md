# AISC — Lab Experiments

Watch This video for Setup Guide
[![Watch the video](https://drive.google.com/thumbnail?id=1wa-sR1ihq7bdVwgV2fhC3w5HD45C7OZ9&sz=w1000)](https://drive.google.com/file/d/1wa-sR1ihq7bdVwgV2fhC3w5HD45C7OZ9/view)

Click the preview above to watch how to run Prolog: download and install DOSBox, set up Turbo Prolog, mount the folder, and load, compile and run a file.

## Table of Contents

| # | File | Experiment |
|---|------|------------|
| 1 | [lab-experiments/exp1_water_jug_dfid.py](lab-experiments/exp1_water_jug_dfid.py) | Water Jug Problem using Depth First Iterative Deepening |
| 2 | [lab-experiments/8puzzle.py](lab-experiments/8puzzle.py) | 8-Puzzle using A* search |
| 3 | [lab-experiments/exp3_minimax_alphabeta.py](lab-experiments/exp3_minimax_alphabeta.py) | Min-Max search with Alpha-Beta pruning |
| 4 | [lab-experiments/perceptron.py](lab-experiments/perceptron.py) | Single Layer Perceptron |
| 5 | [lab-experiments/exp5.pro](lab-experiments/exp5.pro) | List Processing |
| 6 | [lab-experiments/exp6_kohonen_lvq.py](lab-experiments/exp6_kohonen_lvq.py) | Kohonen Self-Organising Map and Learning Vector Quantisation |
| 7 | [lab-experiments/exp7.pro](lab-experiments/exp7.pro) | Kinship Domain |
| 8 | [lab-experiments/hopfield.py](lab-experiments/hopfield.py) | Associative Memory using a Discrete Hopfield Network |
| 9 | [lab-experiments/mamdaniFuzzy.py](lab-experiments/mamdaniFuzzy.py) | Mamdani Fuzzy Controller |
| 10 | [lab-experiments/exp10_genetic_algorithm.py](lab-experiments/exp10_genetic_algorithm.py) | Genetic Algorithm for Function Optimisation |
| 11 | [lab-experiments/exp11.pro](lab-experiments/exp11.pro) | Simple inference and resolutions — food |
| 12 | [lab-experiments/exp12.pro](lab-experiments/exp12.pro) | Simple inference and resolutions — family |

## Guide

### Prolog files (.pro)

Use Windows with DOSBox and Turbo Prolog 2.0.

1. Make a folder on Windows, for example `C:\TPROLOG`.
2. Put the Turbo Prolog files (`PROLOG.EXE`, `PROLOG.OVL`) and the
   `.pro` file you want to run into that same folder.
3. In DOSBox, type:
   ```
   mount c c:\tprolog
   c:
   prolog
   ```
4. In Turbo Prolog, go to Files, Load the `.pro` file, then Compile
   (F9), then Run.

The files `exp5.pro`, `exp7.pro`, `exp11.pro` and `exp12.pro` have
no `goal` section, so they do not run by themselves. Load them and
fire the query yourself, for example:

- `exp5.pro`: `sum([5,10,15,20], S).`, `len([5,10,15,20], N).`,
  `append([1,2], [3,4], C).`, `member(15, [5,10,15,20]).`,
  `delete(15, [5,10,15,20], D).`
- `exp7.pro`: `cousin(X, rohan).`, `ancestor(X, arjun).`,
  `sibling(X, amit).`
- `exp11.pro`: `likes(john, peanuts).`, `food(F).`,
  `eats(harry, barley).`
- `exp12.pro`: `grandparent(asha, chitra).`, `ancestor(asha, dev).`,
  `sibling(bala, gita).`

Re-compile after every edit.

### Python files (.py)

Run a file with:

```
python3 lab-experiments/<file>.py
```

For example:

```
python3 lab-experiments/exp1_water_jug_dfid.py
python3 lab-experiments/8puzzle.py
```

The files `exp6_kohonen_lvq.py` and `exp10_genetic_algorithm.py`
need numpy and matplotlib:

```
pip install numpy matplotlib
```

`exp6_kohonen_lvq.py` saves `som_plot.png` in the folder you run it
from and shows a plot. `exp10_genetic_algorithm.py` shows a
convergence plot.

## Install Turbo Prolog (Prolog Binary)

The Prolog compiler itself is in this repo, in
[prolog-binary/](prolog-binary/). It is Turbo Prolog 2.0, from
https://github.com/lifaet/Prolog-Binary — the same source used in
the setup video at the top. See the `LICENSE` file in that folder.
The main files are `PROLOG.EXE` and `PROLOG.OVL`; copy the whole
folder, not just the `.EXE` on its own.

1. Download this repo (or just the `prolog-binary/` folder) and
   copy all its files to a folder on Windows, for example
   `C:\Prolog`.
2. Copy the `.pro` file you want to run from `lab-experiments/`
   into that same folder.
3. Download and install DOSBox from
   https://www.dosbox.com/download.php?main=1
   (or follow the setup video at the top of this README).
4. Open DOSBox and type:
   ```
   MOUNT c "C:\Prolog"
   c:
   PROLOG.EXE
   ```
5. In Turbo Prolog, go to Files, Load the `.pro` file, then
   Compile (F9), then Run.

## Substitute languages (Java and C, offline)

The 8 Python programs in `lab-experiments/` are also written in
Java and C, in [substitute-languages/](substitute-languages/).
These are optional alternatives to the Python versions — use them
if Python, numpy or matplotlib are not available, or if there is
no internet to install them. Both versions use only their standard
library, so nothing needs to be downloaded.

| Python file | Java file | C file |
|---|---|---|
| `exp1_water_jug_dfid.py` | `java/WaterJugDFID.java` | `c/exp1_water_jug_dfid.c` |
| `8puzzle.py` | `java/EightPuzzle.java` | `c/8puzzle.c` |
| `exp3_minimax_alphabeta.py` | `java/MinimaxAlphaBeta.java` | `c/exp3_minimax_alphabeta.c` |
| `perceptron.py` | `java/Perceptron.java` | `c/perceptron.c` |
| `exp6_kohonen_lvq.py` | `java/KohonenLVQ.java` | `c/exp6_kohonen_lvq.c` |
| `hopfield.py` | `java/Hopfield.java` | `c/hopfield.c` |
| `mamdaniFuzzy.py` | `java/MamdaniFuzzy.java` | `c/mamdaniFuzzy.c` |
| `exp10_genetic_algorithm.py` | `java/GeneticAlgorithm.java` | `c/exp10_genetic_algorithm.c` |

Java (no Maven, no downloads):

```
javac substitute-languages/java/WaterJugDFID.java
java -cp substitute-languages/java WaterJugDFID
```

C (no external libraries, only `-lm`):

```
gcc -O2 -o waterjug substitute-languages/c/exp1_water_jug_dfid.c -lm
./waterjug
```

The plots from the Python versions are printed as numbers instead
(final SOM weights, LVQ accuracy, GA best/average fitness), and the
random programs use fixed seeds, so the random points in Exp 6
Parts 2–3 and the GA populations differ from a numpy/Python run —
the algorithms, parameters and final results (for example LVQ
100%, GA best 11111 / 961) are the same.
