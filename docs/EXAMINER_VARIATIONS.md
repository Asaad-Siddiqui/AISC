# Examiner variations — supplement to HOW_TO_RUN.md

For the 12 Turbo Prolog files in `experiments/` (Practical Examination 2026-27).
This does NOT replace HOW_TO_RUN.md. It only adds: the exact edit for
each examiner variation in the PDF, and the three variations that are
NOT a one-line edit.

HOW TO USE IT IN THE EXAM
- Load the file, edit ONE thing below, Compile, Run.
- Re-compile after every edit. Turbo Prolog keeps the old compiled
  version until you compile again.
- If the examiner asks a different question from the same experiment,
  change the goal/query at the bottom of the file (the `run` clauses),
  not the rules above it.

ONE-LINE EDITS (verified against the code in this folder)
01 Water Jug (01_water_jug.pro)
  Default run already shows three cases: solve(4,3,2), solve(5,3,4),
  and the no-solution case solve(4,2,3).
  New capacities/target: change one solve(...) line in `run`, e.g.
  solve(5,3,4) -> solve(3,5,2). Goal is always "target in jug A".

02 8-Puzzle (02_8_puzzle.pro)
  Change start_board([...]) — 9 numbers, 0 = blank — and, if the
  examiner gives a different goal, goal_board([...]) the same way.
  Both heuristics (misplaced + Manhattan) and the node counts print
  automatically for the new start. Solvability is checked by
  inversion count in the code.

03 Minimax / Alpha-Beta (03_minimax_alpha_beta.pro)
  New tree: change the leaf numbers in the tree T1 (left-to-right
  3,5,6,9,1,2,0,-1) and in the diff(...) line that counts pruned
  leaves. The file ALREADY runs a second, reversed tree (T2), so
  "repeat with reversed order" needs no edit — just point to it.

04 Perceptron (04_perceptron.pro)
  No edit needed for AND / OR / XOR: all three already run, with
  weights, bias and errors per epoch, and the decision line printed
  (AND: x1+x2=1, OR: x1+x2=-1). XOR runs 50 epochs and stays
  non-convergent, as the PDF requires.

05 Lists (05_list_processing.pro)
  Change L = [5,10,15,20] in `run` to the examiner's list, and the
  numbers in app([1,2],[3,4],C) / check(15,L) / delete_elem(15,L,D)
  to match. Query (d) in the PDF is a repeat of (b) length — the
  file prints length once; that covers both.

06 Kohonen + LVQ (06_kohonen_lvq.pro)
  Change Inputs = [...] and W1 / W2 in `run` for different vectors
  or starting weights. Alpha starts 0.6 and halves each epoch in
  the code; epochs(Inputs,1,3,0.6,...) sets the epoch count (3).
  LVQ labels are in Labs = [...] in `run`; the toward/away demo
  uses update_vec with +0.3 / -0.3 at the end of `run`.

07 Kinship (07_kinship.pro)
  All PDF queries (a)-(h) already run: cousins, ancestors,
  second cousins, relatives, grandchildren, siblings, aunt.
  New person: change the name in the `run` line, e.g.
  cousin(C,sam) -> cousin(C,emma). Only male/female/parent are
  facts; everything else is a rule, as the PDF requires.

08 Hopfield (08_hopfield.pro) — READ THIS ONE
  Default run demos ONLY: letter T, 2 pixels flipped (positions 1,2).
  The code itself supports any letter and any flip count, but the
  other cases are not run by default.
  To demo another case, copy the T block in `run`, replace T with
  L (l_pat) or X (x_pat), and add flip_at steps for k=4 or k=6,
  e.g. flip_at(L,1,Tmp1), flip_at(Tmp1,2,Tmp2),
  flip_at(Tmp2,3,Tmp3), flip_at(Tmp3,4,Bad) for 4 flips.
  Then sweeps(...) + check(...) print "Recalled exactly." or
  "Recall failed / spurious state." — report whichever it prints;
  do not claim recall succeeds before running it. Energy before
  and after is printed for every case.

09 Fuzzy Fan (09_fuzzy_fan.pro)
  Change Temp = 28.0, Hum = 65.0 in `run` for the examiner's values.
  Membership degrees, rule strengths, Centre-of-Gravity speed AND
  Mean/Smallest/Largest-of-Max all print automatically.
  The sweep at the end prints speed at 0,10,20,30,40 C at 65%
  humidity — change the sweep list and its humidity together if
  the examiner fixes a different humidity.

10 Genetic Algorithm (10_genetic_algorithm.pro)
  Change Pop = [...] in `run` for a different starting population,
  and gen_loop(Pop,0,50) to change the 50-generation limit.
  Crossover point is fixed at 4 in the crossover clause
  ([A1,A2,A3,A4,B5]); change that clause for a different point.
  Best + average fitness print every generation, so the
  convergence comparison is the printed table, not a separate run.

11 Food Inference (11_inference_food.pro)
  Change check1/check2 or the `run` queries: likes(john,peanuts),
  food(F) list, eats(harry,barley). "Whatever Anil eats is food"
  needs no extra clause — it follows from food(X) :- eats(P,X),
  alive(P) plus alive(anil).

12 Family Inference (12_inference_family.pro)
  Change the names in c1/c2/c4/c5/c6 or the `run` queries
  (descendants, ancestors, siblings, grandparent pairs).
  All nine PDF queries (i)-(ix) already run.

PLOTS — WHAT TO SAY IF THE EXAMINER ASKS
Turbo Prolog prints numbers, it does not draw graphs. The files
already print the plot data, so in the exam draw the plot by hand
from the printed output and say so:
  Exp 4: decision line printed (x1+x2=1 / -1) + the 4 test points.
  Exp 6: winners + W1/W2 after each epoch printed.
  Exp 9: sweep points printed ("plot these points").
  Exp 10: best + average fitness per generation printed.
Do not claim a plot file exists — none of the 12 files makes one.

NOT A ONE-LINE EDIT — NEEDS NEW CODE, NOT JUST A CHANGED NUMBER
  Exp 2, 15-puzzle extension: the board code is 3x3 (9 tiles).
    A 16-tile board needs the move/grid logic changed, not just
    a longer start_board list.
  Exp 3, Tic-Tac-Toe instead of a number tree: needs a board,
    move generator and win check; the current tree code only
    evaluates fixed leaf numbers.
  Exp 6, Iris / 2-D random data with a shrinking neighbourhood:
    the file uses fixed 4-D inputs, 2 neurons and R=0 (winner
    only). A map with a shrinking radius is a different program.
If the examiner sets one of these three, say it needs a new
variant — do not try to fake it by editing a number in the
existing file.

VERIFICATION STATUS (same as HOW_TO_RUN.txt)
Algorithms were logic-checked in Python before the Prolog was
written; they were NOT run inside DOSBox/Turbo Prolog on this
machine. If any file errors on Compile+Run in Turbo Prolog,
note the exact error line and that file can be fixed from it.
