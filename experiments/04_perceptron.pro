% Experiment 4: Single Layer Perceptron (AND, OR, XOR)
% Turbo Prolog for DOSBox. Load, Compile, Run - the goal runs itself.
% Bipolar inputs/targets (+1/-1), weights start at 0, learning rate = 1.
% Rule: if output <> target, w = w + t*x and b = b + t.

domains
  pat = p(integer, integer, integer)
  pats = pat*

predicates
  step(integer, integer)
  epoch(pats, integer, integer, integer, integer, integer, integer, integer)
  print_ep(integer, integer, integer, integer, integer, integer)
  decide(pats, integer, integer, integer, integer, integer, integer, integer, integer, integer, integer, integer, integer)
  train(pats, integer, integer, integer, integer, integer, integer, integer, integer, integer, integer, integer)
  test_list(pats, integer, integer, integer)
  and_data(pats)
  or_data(pats)
  xor_data(pats)
  run

clauses
  step(S, 1) :- S > 0.
  step(S, -1) :- S <= 0.

  epoch([], W1, W2, B, W1, W2, B, 0).
  epoch([p(X1, X2, T)|Rest], W1, W2, B, NW1, NW2, NB, Err) :-
    S = W1 * X1 + W2 * X2 + B, step(S, Y), Y = T,
    epoch(Rest, W1, W2, B, NW1, NW2, NB, Err).
  epoch([p(X1, X2, T)|Rest], W1, W2, B, NW1, NW2, NB, Err) :-
    S = W1 * X1 + W2 * X2 + B, step(S, Y), Y <> T,
    W1a = W1 + T * X1, W2a = W2 + T * X2, Ba = B + T,
    epoch(Rest, W1a, W2a, Ba, NW1, NW2, NB, Err1), Err = Err1 + 1.

  print_ep(1, Ep, W1, W2, B, Err) :-
    write("Epoch "), write(Ep), write(": w1="), write(W1),
    write(", w2="), write(W2), write(", b="), write(B),
    write(", errors="), write(Err), nl.
  print_ep(0, _, _, _, _, _).

  decide(_, Ep, _, W1, W2, B, 0, _, W1, W2, B, Ep, 0).
  decide(Data, Ep, Max, W1, W2, B, Err, Print, FW1, FW2, FB, Used, LastErr) :-
    Err <> 0, Ep < Max, Ep1 = Ep + 1,
    train(Data, Ep1, Max, W1, W2, B, Print, FW1, FW2, FB, Used, LastErr).
  decide(_, Ep, _, W1, W2, B, Err, _, W1, W2, B, Ep, Err) :- Err <> 0.

  train(Data, Ep, Max, W1, W2, B, Print, FW1, FW2, FB, Used, LastErr) :-
    epoch(Data, W1, W2, B, NW1, NW2, NB, Err),
    print_ep(Print, Ep, NW1, NW2, NB, Err),
    decide(Data, Ep, Max, NW1, NW2, NB, Err, Print, FW1, FW2, FB, Used, LastErr).

  test_list([], _, _, _).
  test_list([p(X1, X2, T)|Rest], W1, W2, B) :-
    S = W1 * X1 + W2 * X2 + B, step(S, Y),
    write("("), write(X1), write(","), write(X2),
    write(") target="), write(T), write(", output="), write(Y), nl,
    test_list(Rest, W1, W2, B).

  and_data([p(-1, -1, -1), p(-1, 1, -1), p(1, -1, -1), p(1, 1, 1)]).
  or_data([p(-1, -1, -1), p(-1, 1, 1), p(1, -1, 1), p(1, 1, 1)]).
  xor_data([p(-1, -1, -1), p(-1, 1, 1), p(1, -1, 1), p(1, 1, -1)]).

  run :-
    and_data(A), write("AND:"), nl,
    train(A, 1, 10, 0, 0, 0, 1, W1, W2, B, _, _),
    write("AND converged: w1="), write(W1), write(", w2="), write(W2), write(", b="), write(B), nl,
    write("Decision line: x1 + x2 = 1 (plot the 4 points, draw this line)"), nl,
    test_list(A, W1, W2, B), nl,
    or_data(O), write("OR:"), nl,
    train(O, 1, 10, 0, 0, 0, 1, V1, V2, VB, _, _),
    write("OR converged: w1="), write(V1), write(", w2="), write(V2), write(", b="), write(VB), nl,
    write("Decision line: x1 + x2 = -1"), nl,
    test_list(O, V1, V2, VB), nl,
    xor_data(X), write("XOR (50 epochs, no per-epoch print):"), nl,
    train(X, 1, 50, 0, 0, 0, 0, _, _, _, _, E),
    write("After 50 epochs errors are still "), write(E), write(" - XOR never converges."), nl,
    write("Reason: XOR is not linearly separable - no single straight line can separate it."), nl.

goal
  run.
