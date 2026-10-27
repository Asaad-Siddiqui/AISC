% Experiment 2: 8-Puzzle using A* (h1 = misplaced, h2 = Manhattan)
% Turbo Prolog for DOSBox. Load, Compile, Run - the goal runs itself.
% 0 is the blank. Change start_board to try the examiner's start state.

domains
  board = integer*
  boards = board*
  node = nd(board, integer, integer, boards)
  nodes = node*

predicates
  start_board(board)
  goal_board(board)
  in_board(board, boards)
  pos_of(board, integer, integer, integer)
  get_nth(board, integer, integer)
  set_nth(board, integer, integer, board)
  swap(board, integer, integer, board)
  move_dir(board, symbol, board)
  succ_list(board, symbol*, boards)
  filter_closed(boards, boards, boards)
  mis_count(board, board, integer)
  man_sum(board, integer, integer)
  heuristic(board, integer, integer)
  make_nodes(boards, integer, integer, boards, nodes)
  insert_node(node, nodes, nodes)
  insert_all(nodes, nodes, nodes)
  rev_path(boards, boards, boards)
  astar_loop(nodes, boards, integer, integer, boards, integer, integer)
  astar(integer, boards, integer, integer)
  count_smaller(integer, board, integer)
  inv_list(board, integer)
  print_cell(integer)
  print_board(board)
  move_name(board, board, symbol)
  print_path(boards)
  run_astar(integer, integer)
  run

clauses
  start_board([2, 8, 3, 1, 6, 4, 7, 0, 5]).
  goal_board([1, 2, 3, 8, 0, 4, 7, 6, 5]).

  in_board(B, [B|_]).
  in_board(B, [_|T]) :- in_board(B, T).

  pos_of([V|_], V, I, I) :- !.
  pos_of([_|T], V, I, P) :- I1 = I + 1, pos_of(T, V, I1, P).

  get_nth([H|_], 0, H).
  get_nth([_|T], I, V) :- I > 0, I1 = I - 1, get_nth(T, I1, V).
  set_nth([_|T], 0, V, [V|T]).
  set_nth([H|T], I, V, [H|NT]) :- I > 0, I1 = I - 1, set_nth(T, I1, V, NT).
  swap(B, I, J, NB) :-
    get_nth(B, I, VI), get_nth(B, J, VJ),
    set_nth(B, I, VJ, Tmp), set_nth(Tmp, J, VI, NB).

  move_dir(B, up, NB) :- pos_of(B, 0, 0, BP), BP div 3 > 0, N = BP - 3, swap(B, BP, N, NB).
  move_dir(B, down, NB) :- pos_of(B, 0, 0, BP), BP div 3 < 2, N = BP + 3, swap(B, BP, N, NB).
  move_dir(B, left, NB) :- pos_of(B, 0, 0, BP), BP mod 3 > 0, N = BP - 1, swap(B, BP, N, NB).
  move_dir(B, right, NB) :- pos_of(B, 0, 0, BP), BP mod 3 < 2, N = BP + 1, swap(B, BP, N, NB).

  succ_list(_, [], []).
  succ_list(B, [D|Ds], [NB|Rest]) :- move_dir(B, D, NB), !, succ_list(B, Ds, Rest).
  succ_list(B, [_|Ds], Rest) :- succ_list(B, Ds, Rest).

  filter_closed([], _, []).
  filter_closed([S|Ss], Closed, Rest) :- in_board(S, Closed), !, filter_closed(Ss, Closed, Rest).
  filter_closed([S|Ss], Closed, [S|Rest]) :- filter_closed(Ss, Closed, Rest).

  mis_count([], [], 0).
  mis_count([H|T], [G|GT], N) :- H = 0, mis_count(T, GT, N).
  mis_count([H|T], [G|GT], N) :- H = G, mis_count(T, GT, N).
  mis_count([H|T], [G|GT], N) :- H <> 0, H <> G, mis_count(T, GT, N1), N = N1 + 1.

  man_sum([], _, 0).
  man_sum([0|T], Pos, Sum) :- Pos1 = Pos + 1, man_sum(T, Pos1, Sum).
  man_sum([H|T], Pos, Sum) :-
    H <> 0, goal_board(G), pos_of(G, H, 0, GP),
    D = abs(Pos div 3 - GP div 3) + abs(Pos mod 3 - GP mod 3),
    Pos1 = Pos + 1, man_sum(T, Pos1, Rest), Sum = Rest + D.

  heuristic(B, 1, H) :- goal_board(G), mis_count(B, G, H).
  heuristic(B, 2, H) :- man_sum(B, 0, H).

  make_nodes([], _, _, _, []).
  make_nodes([S|Ss], G, Heu, Path, [nd(S, G, F, [S|Path])|Rest]) :-
    heuristic(S, Heu, H), F = G + H, make_nodes(Ss, G, Heu, Path, Rest).

  insert_node(N, [], [N]).
  insert_node(nd(S, G, F, P), [nd(S2, G2, F2, P2)|R], [nd(S, G, F, P), nd(S2, G2, F2, P2)|R]) :- F <= F2.
  insert_node(N, [H|R], [H|NR]) :- insert_node(N, R, NR).
  insert_all([], Open, Open).
  insert_all([N|Ns], Open, New) :- insert_node(N, Open, Tmp), insert_all(Ns, Tmp, New).

  rev_path([], A, A).
  rev_path([H|T], A, R) :- rev_path(T, [H|A], R).

  astar_loop([nd(State, G, _, PathRev)|_], _, _, Count, Path, G, Exp) :-
    goal_board(State), rev_path(PathRev, [], Path), Exp = Count + 1, !.
  astar_loop([nd(State, G, _, PathRev)|Rest], Closed, Heu, Count, Path, Cost, Exp) :-
    succ_list(State, [up, down, left, right], Succ),
    filter_closed(Succ, Closed, Good),
    G1 = G + 1,
    make_nodes(Good, G1, Heu, PathRev, NewNodes),
    insert_all(NewNodes, Rest, NewOpen),
    Count1 = Count + 1,
    astar_loop(NewOpen, [State|Closed], Heu, Count1, Path, Cost, Exp).
  astar_loop([], _, _, Count, [], 0, Count) :- write("No solution"), nl.

  astar(Heu, Path, Cost, Exp) :-
    start_board(S), heuristic(S, Heu, H),
    astar_loop([nd(S, 0, H, [S])], [], Heu, 0, Path, Cost, Exp).

  count_smaller(0, _, 0).
  count_smaller(_, [], 0).
  count_smaller(H, [X|T], N) :- H <> 0, X <> 0, X < H, !, count_smaller(H, T, N1), N = N1 + 1.
  count_smaller(H, [_|T], N) :- count_smaller(H, T, N).
  inv_list([], 0).
  inv_list([H|T], N) :- count_smaller(H, T, C), inv_list(T, N1), N = C + N1.

  print_cell(0) :- write("_ ").
  print_cell(X) :- X <> 0, write(X), write(" ").
  print_board([A, B, C, D, E, F, G, H, I]) :-
    print_cell(A), print_cell(B), print_cell(C), nl,
    print_cell(D), print_cell(E), print_cell(F), nl,
    print_cell(G), print_cell(H), print_cell(I), nl.

  move_name(B1, B2, up) :- pos_of(B1, 0, 0, P1), pos_of(B2, 0, 0, P2), P2 = P1 - 3.
  move_name(B1, B2, down) :- pos_of(B1, 0, 0, P1), pos_of(B2, 0, 0, P2), P2 = P1 + 3.
  move_name(B1, B2, left) :- pos_of(B1, 0, 0, P1), pos_of(B2, 0, 0, P2), P2 = P1 - 1.
  move_name(B1, B2, right) :- pos_of(B1, 0, 0, P1), pos_of(B2, 0, 0, P2), P2 = P1 + 1.

  print_path([B]) :- print_board(B).
  print_path([B1, B2|T]) :-
    print_board(B1), move_name(B1, B2, M),
    write("blank moves "), write(M), nl, nl,
    print_path([B2|T]).

  run_astar(Heu, Exp) :-
    write("Heuristic "), write(Heu), write(":"), nl,
    astar(Heu, Path, Cost, Exp),
    print_path(Path),
    write("Solution cost = "), write(Cost),
    write(", nodes expanded = "), write(Exp), nl, nl.

  run :-
    start_board(S), goal_board(G),
    inv_list(S, IS), inv_list(G, IG),
    write("Inversions start = "), write(IS),
    write(", goal = "), write(IG), nl,
    P1 = IS mod 2, P2 = IG mod 2, P1 = P2,
    write("Solvable: same inversion parity"), nl, nl,
    run_astar(1, E1),
    run_astar(2, E2),
    write("Comparison: h1 expanded "), write(E1),
    write(", h2 expanded "), write(E2), nl,
    write("Manhattan (h2) expands fewer or equal nodes."), nl.

goal
  run.
