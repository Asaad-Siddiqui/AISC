% Experiment 11: Simple Inference and Resolution (food)
% Turbo Prolog for DOSBox. Load, Compile, Run - the goal runs itself.
% (vii) needs no separate clause: it follows from (iv) + (viii),
% because Anil eats those things and Anil is alive.

predicates
  food(symbol)
  eats(symbol, symbol)
  alive(symbol)
  likes(symbol, symbol)
  check1
  check2
  check3
  run

clauses
  food(apple). food(vegetable). food(mango). food(grape). food(peanuts). food(rice). food(chicken).
  eats(anil, burger). eats(anil, cheese). eats(anil, poha).
  eats(anil, oatmeal). eats(anil, barley). eats(anil, carrot).
  alive(anil).

  food(X) :- eats(P, X), alive(P).
  likes(john, X) :- food(X).
  eats(harry, X) :- eats(anil, X).

  check1 :- likes(john, peanuts), !, write("a) Yes, John likes peanuts."), nl.
  check1 :- write("a) No, John does not like peanuts."), nl.
  check2 :- eats(harry, barley), !, write("c) Yes, Harry eats barley."), nl.
  check2 :- write("c) No, Harry does not eat barley."), nl.
  check3 :- likes(john, burger), !, write("Yes, John likes burger too (Anil eats it and is alive, so it is food)."), nl.
  check3 :- write("No, John does not like burger."), nl.

  run :-
    write("b) Foods: "),
    food(F), write(F), write(" "), fail.
  run :-
    write("Harry eats: "),
    eats(harry, X), write(X), write(" "), fail.
  run :-
    check1, check2, check3.

goal
  run.
