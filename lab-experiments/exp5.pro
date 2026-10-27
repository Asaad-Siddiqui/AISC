domains
  list = integer*

predicates
  sum(list,integer)
  len(list,integer)
  append(list,list,list)
  member(integer,list)
  show(list)
  delete(integer,list,list)

clauses
  sum([],0).
  sum([H|T],S) :- sum(T,S1), S=H+S1.

  len([],0).
  len([_|T],N) :- len(T,N1), N=N1+1.

  append([],L,L).
  append([H|T],L,[H|R]) :- append(T,L,R).

  member(X,[X|_]).
  member(X,[_|T]) :- member(X,T).

  show([]).
  show([H|T]) :- write(H," "), show(T).

  delete(_,[],[]).
  delete(X,[X|T],T).
  delete(X,[H|T],[H|R]) :- X<>H, delete(X,T,R).