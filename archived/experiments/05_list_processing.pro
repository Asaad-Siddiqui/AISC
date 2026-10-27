% Experiment 5: List Processing
% Turbo Prolog for DOSBox. Load, Compile, Run - the goal runs itself.
% Change the lists in run to try the examiner's numbers.

domains
  ilist = integer*

predicates
  sum_list(ilist, integer)
  len(ilist, integer)
  app(ilist, ilist, ilist)
  member(integer, ilist)
  check(integer, ilist)
  delete_elem(integer, ilist, ilist)
  print_list(ilist)
  run

clauses
  sum_list([], 0).
  sum_list([H|T], S) :- sum_list(T, S1), S = H + S1.

  len([], 0).
  len([_|T], N) :- len(T, N1), N = N1 + 1.

  app([], L, L).
  app([H|T], L, [H|R]) :- app(T, L, R).

  member(X, [X|_]).
  member(X, [_|T]) :- member(X, T).

  check(X, L) :- member(X, L), !, write(X), write(" is in the list"), nl.
  check(X, _) :- write(X), write(" is NOT in the list"), nl.

  delete_elem(_, [], []).
  delete_elem(X, [X|T], T) :- !.
  delete_elem(X, [H|T], [H|R]) :- delete_elem(X, T, R).

  print_list([]) :- nl.
  print_list([H|T]) :- write(H), write(" "), print_list(T).

  run :-
    L = [5, 10, 15, 20],
    write("List: "), print_list(L),
    sum_list(L, S), write("a) Sum = "), write(S), nl,
    len(L, N), write("b) Length = "), write(N), nl,
    app([1, 2], [3, 4], C), write("c) [1,2] + [3,4] = "), print_list(C),
    write("e) Membership: "), check(15, L),
    write("e) Membership: "), check(99, L),
    write("f) Elements: "), print_list(L),
    delete_elem(15, L, D), write("g) After deleting 15: "), print_list(D).

goal
  run.
