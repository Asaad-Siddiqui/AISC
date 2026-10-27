predicates
  food(symbol)
  likes(symbol,symbol)
  eats(symbol,symbol)
  alive(symbol)

clauses
  food(apple). food(vegetable). food(mango).
  food(grape). food(peanuts). food(rice). food(chicken).
  food(X) :- eats(P,X), alive(P).

  likes(john,X) :- food(X).

  alive(anil).

  eats(anil,burger). eats(anil,cheese). eats(anil,poha).
  eats(anil,oatmeal). eats(anil,barley). eats(anil,carrot).
  eats(harry,X) :- eats(anil,X).