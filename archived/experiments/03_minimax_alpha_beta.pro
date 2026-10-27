% Experiment 3: Min-Max with Alpha-Beta Pruning
% Turbo Prolog for DOSBox. Load, Compile, Run - the goal runs itself.
% Tree: root MAX, level 1 MIN, level 2 MAX, leaves left to right
% 3, 5, 6, 9, 1, 2, 0, -1. Change the leaf numbers for a new tree.

domains
  tree = leaf(integer); mx(tree, tree); mn(tree, tree)
  ilist = integer*

predicates
  app(ilist, ilist, ilist)
  len(ilist, integer)
  in_int(integer, ilist)
  diff(ilist, ilist, ilist)
  max2(integer, integer, integer)
  min2(integer, integer, integer)
  minimax(tree, integer, ilist)
  alphabeta(tree, integer, integer, integer, ilist)
  show(string, integer, ilist)
  run_tree(string, tree)
  run

clauses
  app([], L, L).
  app([H|T], L, [H|R]) :- app(T, L, R).
  len([], 0).
  len([_|T], N) :- len(T, N1), N = N1 + 1.
  in_int(X, [X|_]).
  in_int(X, [_|T]) :- in_int(X, T).
  diff([], _, []).
  diff([H|T], Vis, Rest) :- in_int(H, Vis), !, diff(T, Vis, Rest).
  diff([H|T], Vis, [H|Rest]) :- diff(T, Vis, Rest).
  max2(A, B, A) :- A >= B.
  max2(A, B, B) :- A < B.
  min2(A, B, A) :- A <= B.
  min2(A, B, B) :- A > B.

  minimax(leaf(V), V, [V]).
  minimax(mx(L, R), VL, Vis) :- minimax(L, VL, VLs), minimax(R, VR, VRs), VL >= VR, app(VLs, VRs, Vis).
  minimax(mx(L, R), VR, Vis) :- minimax(L, VL, VLs), minimax(R, VR, VRs), VL < VR, app(VLs, VRs, Vis).
  minimax(mn(L, R), VL, Vis) :- minimax(L, VL, VLs), minimax(R, VR, VRs), VL <= VR, app(VLs, VRs, Vis).
  minimax(mn(L, R), VR, Vis) :- minimax(L, VL, VLs), minimax(R, VR, VRs), VL > VR, app(VLs, VRs, Vis).

  alphabeta(leaf(V), _, _, V, [V]) :- write("Leaf "), write(V), nl.
  alphabeta(mx(L, R), Alpha, Beta, VL, VisL) :-
    alphabeta(L, Alpha, Beta, VL, VisL), VL >= Beta,
    write("MAX: right branch PRUNED, value "), write(VL), nl.
  alphabeta(mx(L, R), Alpha, Beta, V, Vis) :-
    alphabeta(L, Alpha, Beta, VL, VisL), VL < Beta,
    max2(Alpha, VL, Alpha1),
    alphabeta(R, Alpha1, Beta, VR, VisR),
    app(VisL, VisR, Vis), max2(VL, VR, V),
    write("MAX: value "), write(V), nl.
  alphabeta(mn(L, R), Alpha, Beta, VL, VisL) :-
    alphabeta(L, Alpha, Beta, VL, VisL), VL <= Alpha,
    write("MIN: right branch PRUNED, value "), write(VL), nl.
  alphabeta(mn(L, R), Alpha, Beta, V, Vis) :-
    alphabeta(L, Alpha, Beta, VL, VisL), VL > Alpha,
    min2(Beta, VL, Beta1),
    alphabeta(R, Alpha, Beta1, VR, VisR),
    app(VisL, VisR, Vis), min2(VL, VR, V),
    write("MIN: value "), write(V), nl.

  show(Name, V, Vis) :-
    write(Name), write(" value = "), write(V),
    write(", leaves evaluated = "), len(Vis, N), write(N), nl.

  run_tree(Name, Tree) :-
    write("=== "), write(Name), write(" ==="), nl,
    minimax(Tree, VM, VisM), show("Min-Max", VM, VisM),
    alphabeta(Tree, -1000, 1000, VA, VisA), show("Alpha-Beta", VA, VisA),
    diff([3, 5, 6, 9, 1, 2, 0, -1], VisA, Pruned),
    write("Pruned leaves: "), write(Pruned), nl, nl.

  run :-
    T1 = mx(mn(mx(leaf(3), leaf(5)), mx(leaf(6), leaf(9))),
             mn(mx(leaf(1), leaf(2)), mx(leaf(0), leaf(-1)))),
    run_tree("Tree 1", T1),
    write("Root = 5, best move = left branch."), nl,
    write("Alpha-Beta evaluates 5 leaves; 9 and the (0,-1) subtree are pruned."), nl, nl,
    T2 = mx(mn(mx(leaf(-1), leaf(0)), mx(leaf(2), leaf(1))),
             mn(mx(leaf(9), leaf(6)), mx(leaf(5), leaf(3)))),
    run_tree("Tree 2 (reversed leaves)", T2),
    write("Note: node ordering changes how much is pruned."), nl.

goal
  run.
