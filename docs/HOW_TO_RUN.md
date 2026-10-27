# How to run these files in DOSBox + Turbo Prolog (Windows)

## Why DOSBox?

Turbo Prolog is a 16-bit DOS program. It will NOT run directly on 64-bit
Windows. DOSBox emulates DOS, so it runs fine there.

## 1. Put the files in one folder

- Install DOSBox on Windows — https://www.dosbox.com/download.php?main=1
  (in the setup video this is DOSBox 0.74-3, `DOSBox0.74-3-win32-installer.exe`).
- Make a folder called `TPROLOG`, for example `C:\TPROLOG`.
- Extract the Prolog-Binary ZIP into it, so it contains the Turbo Prolog
  2.0 files, including `PROLOG.EXE` and `PROLOG.OVL`:
  https://github.com/lifaet/Prolog-Binary (Code → Download ZIP).
- Copy the experiment `.pro` files from `experiments/` in this repo into
  the **same** folder:

```
C:\TPROLOG\PROLOG.EXE
C:\TPROLOG\PROLOG.OVL
C:\TPROLOG\01_water_jug.pro
... (all other .pro files in the same folder)
```

## 2. Start DOSBox and mount that folder

In the DOSBox window type:

```
mount c c:\tprolog
c:
prolog
```

If DOSBox says `Directory C:\TPROLOG doesn't exist`, check the folder
name and path on Windows and try the mount command again. Restarting
DOSBox after extracting the files also helps.

## 3. Load, compile and run one file

In Turbo Prolog:

- **Files** menu → **Load**, pick the file, e.g. `01_water_jug.pro`
- **Compile** menu → **Compile** (or press **F9**)
- **Run** menu → **Run**

Every file has a `goal` section, so Run prints the answer by itself.
You do NOT need to type a query for the normal demo.

## 4. If the examiner asks a different question

- For a different jug size/target: change the numbers in `run` in
  file 01, e.g. `solve(5, 3, 4)`.
- For a different 8-puzzle start: change `start_board` in file 02.
- For a different game tree: change the leaf numbers in file 03.
- For a different person/relation in files 07, 11, 12: change the
  goal at the bottom of the file to that query, e.g.
  `goal cousin(X, sam).`
  then Compile and Run again.

See [EXAMINER_VARIATIONS.md](EXAMINER_VARIATIONS.md) for the exact edit
for every variation in the exam paper.

## 5. If there is a compile error

- Check you loaded the `.pro` file itself, not this `.md` file.
- Turbo Prolog is case-sensitive for variables: variables start
  with a capital letter, names like `sam` start with small letters.
- Re-compile after every edit. An old compiled version does not
  pick up your change by itself.

## Expected outputs (so you can check you got the right answer)

- **01 Water Jug:** `(0,0) (0,3) (3,0) (3,3) (4,2) (0,2) (2,0)` at depth 6.
  Also solves 5 L / 3 L → 4 L, and 4 L / 2 L → 3 L has no solution.
- **02 8-Puzzle:** Optimal cost 5, blank moves up, up, left, down, right.
  Manhattan expands fewer or equal nodes than misplaced.
- **03 Minimax:** Root = 5, best move = left. Min-Max checks 8 leaves,
  Alpha-Beta checks 5 leaves (9 and the (0,−1) subtree pruned).
- **04 Perceptron:** AND and OR converge in 3 epochs (w = 1, 1).
  AND bias = −1, OR bias = +1. XOR never converges in 50 epochs.
- **05 Lists:** `[5,10,15,20]` sum = 50, length = 4, `[1,2]+[3,4] = [1,2,3,4]`.
- **06 Kohonen:** Winners for x1..x4 = 2, 1, 2, 1, so clusters {x1, x3} and {x2, x4}.
  LVQ accuracy on the 4 labelled inputs = 4/4.
- **07 Kinship:** Cousins of sam = jack, sara. Grandchildren of tom =
  sam, emma, jack, sara. Mary is aunt of sam, emma.
- **08 Hopfield:** T with 2 pixels flipped is recalled exactly.
  Energy falls from about −188 to about −280.
- **09 Fuzzy Fan:** At 28 °C and 65% humidity, fan speed is about 58.4%
  (Centre of Gravity). The sweep shows speed rising with temp.
- **10 GA:** Best = 11111 (x = 31, f = 961), reached by generation 1
  from the given starting population.
- **11 Food:** John likes peanuts = yes. Harry eats barley = yes.
  Foods include apple, mango, peanuts, rice, chicken,
  burger, cheese, poha, oatmeal, barley, carrot.
- **12 Family:** Asha is grandparent of Chitra = yes, ancestor of Dev = yes.
  Bala and Gita are siblings = yes. Gita grandparent of
  Dev = no. Dev ancestor of Asha = no.
  Grandparent pairs: (asha, chitra), (bala, dev).
