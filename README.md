# AISC — Lab Experiments

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
