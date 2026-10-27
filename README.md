# AISC — Practical Examination 2026-27

Short, easy Turbo Prolog programs for the Practical Examination 2026-27,
ready to run on Windows through DOSBox.

Every experiment is a separate, ready-made file. Load it in Turbo Prolog,
compile it, run it — no query to type, because each file already has its
own `goal` section that runs the demo by itself. You can edit one number
or name in a file and run it again for the examiner's variation; see
[docs/EXAMINER_VARIATIONS.md](docs/EXAMINER_VARIATIONS.md).

## ▶ Watch the setup first — video preview

Click the preview to watch the full video (5:37):

[![Setup guide preview — click to watch the full video](docs/setup-guide-thumbnail.png)](docs/setup-guide.mp4)

Animated preview (15 seconds, from the DOSBox mount step — click it for
the full video):

[![Setup guide preview — animated, click to watch the full video](docs/setup-guide-preview.gif)](docs/setup-guide.mp4)

The full video shows: download DOSBox, install it, set up Turbo Prolog
from Prolog-Binary, make the `TPROLOG` folder, mount it in DOSBox, and
load / compile (F9) / run a file. GitHub does not play a repo MP4 inline
in a README, so the animated preview above is what plays here — clicking
it opens the full `docs/setup-guide.mp4`.

## What's in this repo

| # | File | Experiment | What it does |
|---|------|------------|--------------|
| 1 | [experiments/01_water_jug.pro](experiments/01_water_jug.pro) | Water Jug Problem | Depth First Iterative Deepening (DFID) for 4 L / 3 L jugs, target 2 L in jug A |
| 2 | [experiments/02_8_puzzle.pro](experiments/02_8_puzzle.pro) | 8-Puzzle | A* search, misplaced-tiles vs Manhattan distance |
| 3 | [experiments/03_minimax_alpha_beta.pro](experiments/03_minimax_alpha_beta.pro) | Min-Max + Alpha-Beta | Depth-3 game tree, pruned branches counted |
| 4 | [experiments/04_perceptron.pro](experiments/04_perceptron.pro) | Single-Layer Perceptron | Learns AND and OR, cannot learn XOR |
| 5 | [experiments/05_list_processing.pro](experiments/05_list_processing.pro) | List Processing | Sum, length, concatenate, membership, print, delete |
| 6 | [experiments/06_kohonen_lvq.pro](experiments/06_kohonen_lvq.pro) | Kohonen SOM + LVQ | Competitive learning, 2 clusters, LVQ toward/away demo |
| 7 | [experiments/07_kinship.pro](experiments/07_kinship.pro) | Kinship Domain | Father, mother, sibling, cousin, uncle, aunt, ancestor — only male/female/parent are facts |
| 8 | [experiments/08_hopfield.pro](experiments/08_hopfield.pro) | Hopfield Network | Stores T, L, X (5×5) and recalls them from noisy input |
| 9 | [experiments/09_fuzzy_fan.pro](experiments/09_fuzzy_fan.pro) | Mamdani Fuzzy Controller | Fan speed from temperature + humidity |
| 10 | [experiments/10_genetic_algorithm.pro](experiments/10_genetic_algorithm.pro) | Genetic Algorithm | Maximises f(x) = x² for 0 ≤ x ≤ 31 with 5-bit chromosomes |
| 11 | [experiments/11_inference_food.pro](experiments/11_inference_food.pro) | Inference — Food | "John likes peanuts?", foods list, "Harry eats barley?" |
| 12 | [experiments/12_inference_family.pro](experiments/12_inference_family.pro) | Inference — Family | Grandparent, ancestor, sibling queries for Asha's family |

Guides:

- [docs/HOW_TO_RUN.md](docs/HOW_TO_RUN.md) — full run instructions and expected outputs
- [docs/EXAMINER_VARIATIONS.md](docs/EXAMINER_VARIATIONS.md) — the exact one-line edit for each examiner variation, and the 3 variations that need new code, not just a changed number
- [docs/setup-guide.mp4](docs/setup-guide.mp4) — video guide (5:37): download DOSBox, install it, set up Turbo Prolog, mount the folder, and load/compile/run a file. Preview files: [docs/setup-guide-thumbnail.png](docs/setup-guide-thumbnail.png) (clickable thumbnail, above) and [docs/setup-guide-preview.gif](docs/setup-guide-preview.gif) (animated preview)

## What you need

- **Windows** (Turbo Prolog is a 16-bit DOS program — it will not run
  directly on 64-bit Windows, which is why DOSBox is used)
- **DOSBox 0.74-3** — https://www.dosbox.com/download.php?main=1
- **Turbo Prolog 2.0** — from the Prolog-Binary repo used in the video:
  https://github.com/lifaet/Prolog-Binary
  (download it as a ZIP from Code → Download ZIP; this repo does **not**
  bundle `PROLOG.EXE` / `PROLOG.OVL` — you get those from Prolog-Binary)

## Quick start

### 1. Install DOSBox

Download and install DOSBox 0.74-3 from dosbox.com (in the video this is
the `DOSBox0.74-3-win32-installer.exe` from SourceForge). Open it once to
check it starts.

### 2. Make a `TPROLOG` folder

Create a folder on Windows called `TPROLOG`, for example `C:\TPROLOG`.

Extract the Prolog-Binary ZIP **into that folder**, so it contains the
Turbo Prolog 2.0 files, including `PROLOG.EXE` and `PROLOG.OVL`.

Then copy the experiment files you want into the **same** folder, for
example:

```
C:\TPROLOG\PROLOG.EXE
C:\TPROLOG\PROLOG.OVL
C:\TPROLOG\01_water_jug.pro
C:\TPROLOG\02_8_puzzle.pro
... (and so on)
```

### 3. Mount the folder in DOSBox and start Prolog

In the DOSBox window, type:

```
mount c c:\tprolog
c:
prolog
```

If DOSBox says the directory does not exist, check the folder name and
path on Windows, then try the mount command again (the video shows this
exact error and fix). Restarting DOSBox after extracting the files also
helps.

### 4. Load, compile, run

In Turbo Prolog, for any experiment file:

1. **Files** menu → **Load** → pick the `.pro` file
2. **Compile** (or press **F9**)
3. **Run**

The answer prints by itself — you do not need to type a query for the
normal demo. Re-compile after every edit; Turbo Prolog keeps the old
compiled version until you compile again.

Full steps, troubleshooting, and the expected output of every experiment
are in [docs/HOW_TO_RUN.md](docs/HOW_TO_RUN.md).

## Expected outputs (spot-check)

- **01 Water Jug:** `(0,0) (0,3) (3,0) (3,3) (4,2) (0,2) (2,0)` at depth 6.
  Also solves 5 L / 3 L → 4 L, and 4 L / 2 L → 3 L has no solution.
- **02 8-Puzzle:** optimal cost 5, blank moves up, up, left, down, right.
  Manhattan expands fewer or equal nodes than misplaced tiles.
- **03 Minimax:** root = 5, best move = left. Min-Max checks 8 leaves,
  Alpha-Beta checks 5 (leaf 9 and the (0,−1) subtree are pruned).
- **04 Perceptron:** AND and OR converge in 3 epochs (w = 1, 1;
  AND bias −1, OR bias +1). XOR never converges in 50 epochs.
- **05 Lists:** `[5,10,15,20]` → sum 50, length 4, `[1,2]+[3,4] = [1,2,3,4]`.
- **06 Kohonen:** winners for x1..x4 = 2, 1, 2, 1, so clusters
  {x1, x3} and {x2, x4}. LVQ accuracy on the 4 labelled inputs = 4/4.
- **07 Kinship:** cousins of sam = jack, sara; grandchildren of tom =
  sam, emma, jack, sara; mary is aunt of sam, emma.
- **08 Hopfield:** T with 2 pixels flipped is recalled exactly;
  energy falls from about −188 to about −280.
- **09 Fuzzy Fan:** at 28 °C and 65% humidity, fan speed ≈ 58.4%
  (Centre of Gravity). The sweep shows speed rising with temperature.
- **10 GA:** best = `11111` (x = 31, f = 961).
- **11 Food:** John likes peanuts = yes. Harry eats barley = yes.
- **12 Family:** Asha is grandparent of Chitra = yes, ancestor of Dev =
  yes. Bala and Gita are siblings = yes. Gita grandparent of Dev = no.
  Dev ancestor of Asha = no. Grandparent pairs: (asha, chitra), (bala, dev).

## Plots — what to say in the exam

Turbo Prolog prints numbers; it does not draw graphs. The files already
print the plot data, so draw the plot by hand from the printed output:

- Exp 4: decision line printed (x1+x2 = 1 / −1) + the 4 test points.
- Exp 6: winners + W1/W2 after each epoch printed.
- Exp 9: sweep points printed ("plot these points").
- Exp 10: best + average fitness per generation printed.

No file in this repo makes a plot file — do not claim one exists.

## Verification status — read this before the exam

The algorithms were logic-checked in Python before the Prolog was
written (water-jug depth-6 path, 8-puzzle cost 5, minimax root 5 with
5 alpha-beta leaves, perceptron AND/OR epoch 3 / XOR non-convergent,
Kohonen clusters {x1,x3}/{x2,x4}, Hopfield energy −188 to −280,
fuzzy fan ≈ 58.4% at 28 °C / 65%). They were **not** run inside
DOSBox/Turbo Prolog on the machine that built them. If any file errors
on Compile+Run in Turbo Prolog, note the exact error line — that file
can be fixed from it.

## Credits

- DOSBox — https://www.dosbox.com
- Turbo Prolog 2.0 binary used in the setup video —
  [lifaet/Prolog-Binary](https://github.com/lifaet/Prolog-Binary)
- Setup video in this repo (`docs/setup-guide.mp4`) shows the
  DOSBox install, the Prolog-Binary download, the `TPROLOG` folder,
  the DOSBox mount commands, and load → compile (F9) → run.
