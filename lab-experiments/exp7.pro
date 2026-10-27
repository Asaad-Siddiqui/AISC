predicates
  male(symbol)
  female(symbol)
  parent(symbol,symbol)
  father(symbol,symbol)
  mother(symbol,symbol)
  sibling(symbol,symbol)
  brother(symbol,symbol)
  sister(symbol,symbol)
  uncle(symbol,symbol)
  aunt(symbol,symbol)
  cousin(symbol,symbol)
  secondcousin(symbol,symbol)
  ancestor(symbol,symbol)
  grandchild(symbol,symbol)
  relative(symbol,symbol)

clauses
  male(raj). male(amit). male(rohan). male(kiran). male(arjun).
  female(sunita). female(pooja). female(meera).

  parent(raj,amit).
  parent(raj,sunita).
  parent(amit,rohan).
  parent(amit,pooja).
  parent(sunita,kiran).
  parent(rohan,arjun).
  parent(kiran,meera).

  father(X,Y) :- male(X), parent(X,Y).
  mother(X,Y) :- female(X), parent(X,Y).
  sibling(X,Y) :- parent(P,X), parent(P,Y), X<>Y.
  brother(X,Y) :- male(X), sibling(X,Y).
  sister(X,Y) :- female(X), sibling(X,Y).
  uncle(U,N) :- male(U), parent(P,N), sibling(U,P).
  aunt(A,N) :- female(A), parent(P,N), sibling(A,P).
  cousin(X,Y) :- parent(P,X), parent(Q,Y), sibling(P,Q).
  secondcousin(X,Y) :- parent(P,X), parent(Q,Y), cousin(P,Q).
  ancestor(X,Y) :- parent(X,Y).
  ancestor(X,Y) :- parent(X,Z), ancestor(Z,Y).
  grandchild(G,C) :- parent(G,P), parent(P,C).

  relative(X,Y) :- parent(X,Y).
  relative(X,Y) :- sibling(X,Y).
  relative(X,Y) :- uncle(X,Y).
  relative(X,Y) :- aunt(X,Y).