% Experiment 10: Genetic Algorithm - maximise f(x) = x^2, 0 <= x <= 31
% Turbo Prolog for DOSBox. Load, Compile, Run - the goal runs itself.
% 5-bit chromosomes, population 6, single-point crossover (point 4),
% elitism (best 2 kept), mutation = flip the last bit of child 2.
% Change the initial population below to repeat with different parameters.

domains
  chrom = integer*
  pops = chrom*

predicates
  decode(chrom, integer)
  fitness(chrom, integer)
  sum_fit(pops, integer)
  best(pops, chrom, integer)
  insert_chrom(chrom, pops, pops)
  sort_pop(pops, pops)
  crossover(chrom, chrom, chrom, chrom)
  flip_bit(integer, integer)
  mutate(chrom, chrom)
  print_chrom(chrom)
  print_table(pops, integer)
  gen_loop(pops, integer, integer)
  decide_gen(pops, integer, integer, integer)
  run

clauses
  decode([B1, B2, B3, B4, B5], X) :- X = B1 * 16 + B2 * 8 + B3 * 4 + B4 * 2 + B5.
  fitness(C, F) :- decode(C, X), F = X * X.

  sum_fit([], 0).
  sum_fit([C|Rest], S) :- fitness(C, F), sum_fit(Rest, S1), S = F + S1.

  best([C], C, F) :- fitness(C, F).
  best([C|Rest], C, F1) :- best(Rest, _, F2), fitness(C, F1), F1 >= F2.
  best([C|Rest], B, F2) :- best(Rest, B, F2), fitness(C, F1), F1 < F2.

  insert_chrom(C, [], [C]).
  insert_chrom(C, [H|T], [C, H|T]) :- fitness(C, F1), fitness(H, F2), F1 >= F2.
  insert_chrom(C, [H|T], [H|R]) :- fitness(C, F1), fitness(H, F2), F1 < F2, insert_chrom(C, T, R).
  sort_pop([], []).
  sort_pop([C|Rest], Sorted) :- sort_pop(Rest, S1), insert_chrom(C, S1, Sorted).

  crossover([A1, A2, A3, A4, A5], [B1, B2, B3, B4, B5],
            [A1, A2, A3, A4, B5], [B1, B2, B3, B4, A5]).
  flip_bit(0, 1).
  flip_bit(1, 0).
  mutate([A, B, C, D, E], [A, B, C, D, NE]) :- flip_bit(E, NE).

  print_chrom([]).
  print_chrom([H|T]) :- write(H), print_chrom(T).
  print_table([], _).
  print_table([C|Rest], Total) :-
    decode(C, X), fitness(C, F), TR = Total + 0.0, Prob = F / TR,
    print_chrom(C), write("  x="), write(X), write("  f="), write(F),
    write("  p="), write(Prob), nl, print_table(Rest, Total).

  decide_gen(_, _, _, 961).
  decide_gen(_, Gen, Max, _) :- Gen >= Max.
  decide_gen(Pop, Gen, Max, BestF) :-
    BestF <> 961, Gen < Max,
    sort_pop(Pop, [P1, P2|_]),
    crossover(P1, P2, C1, C2), mutate(C2, MC2),
    NewPop = [P1, P2, C1, MC2, P1, P2],
    Gen1 = Gen + 1, gen_loop(NewPop, Gen1, Max).

  gen_loop(Pop, Gen, Max) :-
    best(Pop, _, BestF), sum_fit(Pop, Sum), Avg = Sum div 6,
    write("Generation "), write(Gen), write(": best fitness="), write(BestF),
    write(", average fitness="), write(Avg), nl,
    decide_gen(Pop, Gen, Max, BestF).

  run :-
    Pop = [[1, 1, 1, 0, 1], [1, 1, 0, 1, 1], [0, 1, 1, 1, 1],
           [1, 0, 1, 1, 1], [1, 1, 1, 1, 0], [0, 1, 0, 1, 0]],
    write("Generation 0 table (chromosome, x, fitness, selection probability):"), nl,
    sum_fit(Pop, Total), print_table(Pop, Total), nl,
    gen_loop(Pop, 0, 50),
    write("Expected best: 11111 (x=31, f=961). Average fitness rises over generations."), nl,
    write("To compare parameters, change the initial population or the crossover point and run again."), nl.

goal
  run.
