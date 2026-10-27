% Experiment 12: Simple Inference and Resolution (family)
% Turbo Prolog for DOSBox. Load, Compile, Run - the goal runs itself.

predicates
  parent(symbol, symbol)
  grandparent(symbol, symbol)
  ancestor(symbol, symbol)
  sibling(symbol, symbol)
  c1
  c2
  c4
  c5
  c6
  run

clauses
  parent(asha, bala). parent(asha, gita).
  parent(bala, chitra).
  parent(chitra, dev).

  grandparent(X, Z) :- parent(X, Y), parent(Y, Z).
  ancestor(X, Z) :- parent(X, Z).
  ancestor(X, Z) :- parent(X, Y), ancestor(Y, Z).
  sibling(X, Y) :- parent(P, X), parent(P, Y), X <> Y.

  c1 :- grandparent(asha, chitra), !, write("i) Yes, Asha is a grandparent of Chitra."), nl.
  c1 :- write("i) No."), nl.
  c2 :- ancestor(asha, dev), !, write("ii) Yes, Asha is an ancestor of Dev."), nl.
  c2 :- write("ii) No."), nl.
  c4 :- sibling(bala, gita), !, write("iv) Yes, Bala and Gita are siblings."), nl.
  c4 :- write("iv) No."), nl.
  c5 :- grandparent(gita, dev), !, write("v) Yes, Gita is a grandparent of Dev."), nl.
  c5 :- write("v) No, Gita is not a grandparent of Dev."), nl.
  c6 :- ancestor(dev, asha), !, write("vi) Yes, Dev is an ancestor of Asha."), nl.
  c6 :- write("vi) No, Dev is not an ancestor of Asha."), nl.

  run :-
    write("iii) Asha's descendants: "),
    ancestor(asha, D), write(D), write(" "), fail.
  run :-
    write("vii) Dev's ancestors: "),
    ancestor(A, dev), write(A), write(" "), fail.
  run :-
    write("viii) Bala's siblings: "),
    sibling(S, bala), write(S), write(" "), fail.
  run :-
    write("ix) Grandparent pairs (grandparent, grandchild): "),
    grandparent(GP, GC), write("("), write(GP), write(","), write(GC), write(") "), fail.
  run :-
    c1, c2, c4, c5, c6.

goal
  run.
