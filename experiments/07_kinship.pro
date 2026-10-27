% Experiment 7: Kinship Domain
% Turbo Prolog for DOSBox. Load, Compile, Run - the goal runs itself.
% ONLY male, female and parent are facts. All other relations are rules.
% You can also type a query yourself, e.g. cousin(X, sam).

domains
  person = symbol

predicates
  male(person)
  female(person)
  parent(person, person)
  father(person, person)
  mother(person, person)
  sibling(person, person)
  brother(person, person)
  sister(person, person)
  cousin(person, person)
  second_cousin(person, person)
  uncle(person, person)
  aunt(person, person)
  ancestor(person, person)
  grandchild(person, person)
  relative(person, person)
  run

clauses
  male(tom). male(bob). male(sam). male(peter). male(jack). male(harry). male(alex).
  female(ann). female(mary). female(lisa). female(emma). female(sara). female(nina). female(rose).

  parent(tom, bob). parent(ann, bob).
  parent(tom, mary). parent(ann, mary).
  parent(bob, sam). parent(lisa, sam).
  parent(bob, emma). parent(lisa, emma).
  parent(mary, jack). parent(peter, jack).
  parent(mary, sara). parent(peter, sara).
  parent(sam, harry). parent(nina, harry).
  parent(jack, alex). parent(rose, alex).

  father(F, C) :- parent(F, C), male(F).
  mother(M, C) :- parent(M, C), female(M).
  sibling(X, Y) :- father(F, X), father(F, Y), X <> Y.
  brother(X, Y) :- sibling(X, Y), male(X).
  sister(X, Y) :- sibling(X, Y), female(X).
  cousin(X, Y) :- parent(P1, X), parent(P2, Y), sibling(P1, P2), X <> Y.
  second_cousin(X, Y) :- parent(P1, X), parent(P2, Y), cousin(P1, P2), X <> Y.
  uncle(X, Y) :- parent(P, Y), brother(P, X).
  aunt(X, Y) :- parent(P, Y), sister(P, X).
  uncle(X, Y) :- parent(P, Y), sister(P, A), parent(A, C), parent(X, C), male(X), X <> P.
  aunt(X, Y) :- parent(P, Y), brother(P, U), parent(U, C), parent(X, C), female(X), X <> P.
  ancestor(X, Y) :- parent(X, Y).
  ancestor(X, Y) :- parent(X, Z), ancestor(Z, Y).
  grandchild(G, GP) :- parent(P, G), parent(GP, P).
  relative(X, Y) :- parent(X, Y).
  relative(X, Y) :- sibling(X, Y).
  relative(X, Y) :- uncle(X, Y).
  relative(X, Y) :- aunt(X, Y).

  % Each run clause below prints one list with a fail loop, then
  % fails so Prolog moves on to the next run clause. The last one succeeds.

  run :-
    write("Cousins of sam: "),
    cousin(C, sam), write(C), write(" "), fail.
  run :-
    write("Ancestors of harry: "),
    ancestor(A, harry), write(A), write(" "), fail.
  run :-
    write("Second cousins of harry: "),
    second_cousin(S, harry), write(S), write(" "), fail.
  run :-
    write("Relatives of sam (parent, sibling, uncle, aunt): "),
    relative(R, sam), write(R), write(" "), fail.
  run :-
    write("Grandchildren of tom: "),
    grandchild(G, tom), write(G), write(" "), fail.
  run :-
    write("Siblings of bob: "),
    sibling(S, bob), write(S), write(" "), fail.
  run :-
    write("Mary is aunt of: "),
    aunt(mary, A), write(A), write(" "), fail.
  run :-
    father(F, sam), write("Father of sam = "), write(F), nl,
    mother(M, sam), write("Mother of sam = "), write(M), nl,
    brother(B, emma), write("Brother of emma = "), write(B), nl,
    sister(S, sam), write("Sister of sam = "), write(S), nl.

goal
  run.
