predicates
  parent(symbol,symbol)
  grandparent(symbol,symbol)
  ancestor(symbol,symbol)
  sibling(symbol,symbol)

clauses
  parent(asha,bala).
  parent(asha,gita).
  parent(bala,chitra).
  parent(chitra,dev).

  grandparent(X,Z) :- parent(X,Y), parent(Y,Z).

  ancestor(X,Z) :- parent(X,Z).
  ancestor(X,Z) :- parent(X,Y), ancestor(Y,Z).

  sibling(X,Y) :- parent(P,X), parent(P,Y), X<>Y.