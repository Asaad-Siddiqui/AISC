% Experiment 8: Discrete Hopfield Network (auto-associative memory)
% Turbo Prolog for DOSBox. Load, Compile, Run - the goal runs itself.
% Patterns are 5x5 letters T, L, X. +1 = black (#), -1 = white (.).
% Weights are never stored as a matrix: W = sum of p*p^T with zero
% diagonal, so net(i) = sum over patterns of p(i) * (dot(p,y) - p(i)*y(i)).
% Recall is asynchronous: neurons are updated one at a time, 3 sweeps.

domains
  vec = integer*
  vecs = vec*

predicates
  dot(vec, vec, integer)
  nth(vec, integer, integer)
  set_nth(vec, integer, integer, vec)
  eq_vec(vec, vec)
  net_for(vecs, vec, integer, integer)
  update_all(vecs, vec, integer, vec)
  sweeps(vecs, vec, integer, vec)
  energy_sum(vecs, vec, integer)
  energy(vecs, vec, integer)
  flip_at(vec, integer, vec)
  print_cell(integer)
  print_grid(vec)
  check(vec, vec)
  t_pat(vec)
  l_pat(vec)
  x_pat(vec)
  run

clauses
  dot([], [], 0).
  dot([X|Xs], [Y|Ys], D) :- dot(Xs, Ys, D1), D = X * Y + D1.
  nth([H|_], 1, H).
  nth([_|T], I, V) :- I > 1, I1 = I - 1, nth(T, I1, V).
  set_nth([_|T], 1, V, [V|T]).
  set_nth([H|T], I, V, [H|NT]) :- I > 1, I1 = I - 1, set_nth(T, I1, V, NT).
  eq_vec([], []).
  eq_vec([H|T], [H|T1]) :- eq_vec(T, T1).

  net_for([], _, _, 0).
  net_for([P|Ps], Y, I, Net) :-
    dot(P, Y, Dot), nth(P, I, Pi), nth(Y, I, Yi),
    Term = Pi * (Dot - Pi * Yi),
    net_for(Ps, Y, I, Rest), Net = Term + Rest.

  update_all(_, Y, 26, Y).
  update_all(Pats, Y, I, Final) :-
    I <= 25, net_for(Pats, Y, I, Net),
    NV = 1, Net >= 0, set_nth(Y, I, NV, Y1), I1 = I + 1, update_all(Pats, Y1, I1, Final).
  update_all(Pats, Y, I, Final) :-
    I <= 25, net_for(Pats, Y, I, Net),
    Net < 0, set_nth(Y, I, -1, Y1), I1 = I + 1, update_all(Pats, Y1, I1, Final).

  sweeps(_, Y, 0, Y).
  sweeps(Pats, Y, N, Final) :- N > 0, update_all(Pats, Y, 1, Y1), N1 = N - 1, sweeps(Pats, Y1, N1, Final).

  energy_sum([], _, 0).
  energy_sum([P|Ps], Y, S) :- dot(P, Y, Dot), energy_sum(Ps, Y, S1), S = Dot * Dot - 25 + S1.
  energy(Pats, Y, E) :- energy_sum(Pats, Y, Sum), T = Sum div 2, E = 0 - T.

  flip_at(V, I, NV) :- nth(V, I, X), NX = 0 - X, set_nth(V, I, NX, NV).

  print_cell(1) :- write("# ").
  print_cell(-1) :- write(". ").
  print_grid([]).
  print_grid([A, B, C, D, E|Rest]) :-
    print_cell(A), print_cell(B), print_cell(C), print_cell(D), print_cell(E), nl,
    print_grid(Rest).

  check(A, B) :- eq_vec(A, B), !, write("Recalled exactly."), nl.
  check(_, _) :- write("Recall failed / spurious state."), nl.

  t_pat([1, 1, 1, 1, 1, -1, -1, 1, -1, -1, -1, -1, 1, -1, -1, -1, -1, 1, -1, -1, -1, -1, 1, -1, -1]).
  l_pat([1, -1, -1, -1, -1, 1, -1, -1, -1, -1, 1, -1, -1, -1, -1, 1, -1, -1, -1, -1, 1, 1, 1, 1, 1]).
  x_pat([1, -1, -1, -1, 1, -1, 1, -1, 1, -1, -1, -1, 1, -1, -1, -1, 1, -1, 1, -1, 1, -1, -1, -1, 1]).

  run :-
    t_pat(T), l_pat(L), x_pat(X), Pats = [T, L, X],
    write("Stored T:"), nl, print_grid(T),
    write("Stored L:"), nl, print_grid(L),
    write("Stored X:"), nl, print_grid(X),
    flip_at(T, 1, Tmp), flip_at(Tmp, 2, Bad),
    write("T with 2 pixels flipped:"), nl, print_grid(Bad),
    energy(Pats, Bad, E1), write("Energy before recall = "), write(E1), nl,
    sweeps(Pats, Bad, 3, Good),
    write("After recall:"), nl, print_grid(Good),
    energy(Pats, Good, E2), write("Energy after recall = "), write(E2), nl,
    check(T, Good),
    write("Energy never increases; it settles at a minimum."), nl.

goal
  run.
