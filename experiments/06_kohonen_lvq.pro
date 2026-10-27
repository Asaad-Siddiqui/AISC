% Experiment 6: Kohonen SOM + LVQ (competitive learning)
% Turbo Prolog for DOSBox. Load, Compile, Run - the goal runs itself.
% Inputs x1=(1,1,0,0) x2=(0,0,0,1) x3=(1,0,0,0) x4=(0,0,1,1)
% Two output neurons, alpha starts 0.6 and is halved after every epoch, R = 0
% (only the winner is updated). LVQ is shown at the end.

domains
  vec = real*
  vecs = vec*
  lab = l(vec, integer)
  labs = lab*
  ilist = integer*

predicates
  dist2(vec, vec, real)
  winner(vec, vec, vec, integer)
  update_vec(vec, vec, real, vec)
  epoch_inputs(vecs, vec, vec, real, vec, vec, ilist)
  print_vec(vec)
  print_epoch(integer, real, ilist, vec, vec)
  decide(vecs, integer, integer, real, vec, vec, vec, vec)
  epochs(vecs, integer, integer, real, vec, vec, vec, vec)
  final_winners(vecs, vec, vec, ilist)
  winner_class(integer, integer)
  acc(labs, vec, vec, integer, integer)
  print_list_int(ilist)
  run

clauses
  dist2([], [], 0.0).
  dist2([X|Xs], [Y|Ys], D) :- dist2(Xs, Ys, D1), Diff = X - Y, D = D1 + Diff * Diff.

  winner(X, W1, W2, 1) :- dist2(X, W1, D1), dist2(X, W2, D2), D1 <= D2.
  winner(X, W1, W2, 2) :- dist2(X, W1, D1), dist2(X, W2, D2), D1 > D2.

  update_vec([], [], _, []).
  update_vec([W|Ws], [X|Xs], A, [NW|Ns]) :- NW = W + A * (X - W), update_vec(Ws, Xs, A, Ns).

  epoch_inputs([], W1, W2, _, W1, W2, []).
  epoch_inputs([X|Xs], W1, W2, A, NW1, NW2, [1|Wins]) :-
    winner(X, W1, W2, 1), update_vec(W1, X, A, U1), epoch_inputs(Xs, U1, W2, A, NW1, NW2, Wins).
  epoch_inputs([X|Xs], W1, W2, A, NW1, NW2, [2|Wins]) :-
    winner(X, W1, W2, 2), update_vec(W2, X, A, U2), epoch_inputs(Xs, W1, U2, A, NW1, NW2, Wins).

  print_vec([]) :- nl.
  print_vec([H|T]) :- write(H), write(" "), print_vec(T).
  print_list_int([]) :- nl.
  print_list_int([H|T]) :- write(H), write(" "), print_list_int(T).

  print_epoch(Ep, A, Wins, W1, W2) :-
    write("Epoch "), write(Ep), write(", alpha="), write(A), write(", winners x1..x4 = "),
    print_list_int(Wins),
    write("W1 = "), print_vec(W1),
    write("W2 = "), print_vec(W2).

  decide(_, Ep, Max, _, W1, W2, W1, W2) :- Ep >= Max.
  decide(Inputs, Ep, Max, Alpha, W1, W2, FW1, FW2) :-
    Ep < Max, Ep1 = Ep + 1, Alpha1 = Alpha / 2.0,
    epochs(Inputs, Ep1, Max, Alpha1, W1, W2, FW1, FW2).
  epochs(Inputs, Ep, Max, Alpha, W1, W2, FW1, FW2) :-
    epoch_inputs(Inputs, W1, W2, Alpha, NW1, NW2, Wins),
    print_epoch(Ep, Alpha, Wins, NW1, NW2),
    decide(Inputs, Ep, Max, Alpha, NW1, NW2, FW1, FW2).

  final_winners([], _, _, []).
  final_winners([X|Xs], W1, W2, [Win|Wins]) :- winner(X, W1, W2, Win), final_winners(Xs, W1, W2, Wins).

  winner_class(1, 2).
  winner_class(2, 1).

  acc([], _, _, 0, 0).
  acc([l(X, C)|Rest], W1, W2, Corr, Total) :-
    winner(X, W1, W2, Win), winner_class(Win, C),
    acc(Rest, W1, W2, Corr1, Total1), Corr = Corr1 + 1, Total = Total1 + 1.
  acc([l(X, C)|Rest], W1, W2, Corr, Total) :-
    winner(X, W1, W2, Win), winner_class(Win, WC), WC <> C,
    acc(Rest, W1, W2, Corr, Total1), Total = Total1 + 1.

  run :-
    Inputs = [[1.0, 1.0, 0.0, 0.0], [0.0, 0.0, 0.0, 1.0], [1.0, 0.0, 0.0, 0.0], [0.0, 0.0, 1.0, 1.0]],
    W1 = [0.2, 0.6, 0.5, 0.9], W2 = [0.8, 0.4, 0.7, 0.3],
    epochs(Inputs, 1, 3, 0.6, W1, W2, FW1, FW2),
    final_winners(Inputs, FW1, FW2, Wins),
    write("Final winners x1..x4 = "), print_list_int(Wins),
    write("Clusters: {x1, x3} and {x2, x4} (same winner = same cluster)"), nl, nl,
    write("LVQ: prototype 1 has class 2, prototype 2 has class 1."), nl,
    Labs = [l([1.0, 1.0, 0.0, 0.0], 1), l([0.0, 0.0, 0.0, 1.0], 2),
            l([1.0, 0.0, 0.0, 0.0], 1), l([0.0, 0.0, 1.0, 1.0], 2)],
    acc(Labs, FW1, FW2, Corr, Total),
    write("LVQ accuracy = "), write(Corr), write("/"), write(Total), nl,
    write("LVQ correct case: x1 (class 1, winner 2) moves TOWARD x1:"), nl,
    update_vec(FW2, [1.0, 1.0, 0.0, 0.0], 0.3, Toward), write("W2 -> "), print_vec(Toward),
    write("LVQ wrong case: x1 labelled class 2 (winner 2, class 1) moves AWAY:"), nl,
    update_vec(FW2, [1.0, 1.0, 0.0, 0.0], -0.3, Away), write("W2 -> "), print_vec(Away).

goal
  run.
