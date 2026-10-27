% Experiment 1: Water Jug Problem - Depth First Iterative Deepening
% Turbo Prolog for DOSBox. Load it, Compile, Run - the goal runs itself.
% Change the numbers in run to try the examiner's capacities/target.
% State = s(X, Y): X in jug A, Y in jug B. Goal = 2 litres in jug A.

domains
  st = s(integer, integer)
  sts = st*

predicates
  move(integer, integer, integer, integer, integer, integer)
  inpath(st, sts)
  dfs(integer, integer, integer, integer, integer, integer, sts, sts)
  rev(sts, sts, sts)
  print_states(sts)
  dfid(integer, integer, integer, integer, integer)
  solve(integer, integer, integer)
  run

clauses
  % fill B first, then fill A - this gives the textbook path for 4,3,2
  move(CA, CB, X, Y, X, CB) :- Y < CB.
  move(CA, CB, X, Y, CA, Y) :- X < CA.
  move(CA, CB, X, Y, X + Y, 0) :- Y > 0, X < CA, X + Y <= CA.
  move(CA, CB, X, Y, CA, X + Y - CA) :- Y > 0, X < CA, X + Y > CA.
  move(CA, CB, X, Y, 0, X + Y) :- X > 0, Y < CB, X + Y <= CB.
  move(CA, CB, X, Y, X + Y - CB, CB) :- X > 0, Y < CB, X + Y > CB.
  move(CA, CB, X, Y, 0, Y) :- X > 0.
  move(CA, CB, X, Y, X, 0) :- Y > 0.

  inpath(S, [S|_]).
  inpath(S, [_|T]) :- inpath(S, T).

  dfs(X, _, _, _, Goal, _, Path, Path) :- X = Goal.
  dfs(X, Y, CA, CB, Goal, Limit, Seen, Path) :-
    Limit > 0,
    move(CA, CB, X, Y, NX, NY),
    not inpath(s(NX, NY), Seen),
    Limit1 = Limit - 1,
    dfs(NX, NY, CA, CB, Goal, Limit1, [s(NX, NY)|Seen], Path).

  rev([], A, A).
  rev([H|T], A, R) :- rev(T, [H|A], R).

  print_states([]) :- nl.
  print_states([s(X, Y)|T]) :-
    write("("), write(X), write(","), write(Y), write(") "),
    print_states(T).

  dfid(Limit, Max, CA, CB, Goal) :-
    Limit <= Max,
    dfs(0, 0, CA, CB, Goal, Limit, [s(0, 0)], Rev),
    rev(Rev, [], Path),
    write("Goal at depth "), write(Limit), write(": "),
    print_states(Path), !.
  dfid(Limit, Max, CA, CB, Goal) :-
    Limit <= Max,
    Limit1 = Limit + 1,
    dfid(Limit1, Max, CA, CB, Goal).
  dfid(Limit, Max, _, _, _) :-
    Limit > Max,
    write("No solution"), nl.

  solve(CA, CB, Goal) :-
    write("Jugs "), write(CA), write(" and "), write(CB),
    write(", target "), write(Goal), write(" in jug A: "), nl,
    Max = (CA + 1) * (CB + 1),
    dfid(0, Max, CA, CB, Goal).

  run :-
    solve(4, 3, 2),
    solve(5, 3, 4),
    solve(4, 2, 3).

goal
  run.
