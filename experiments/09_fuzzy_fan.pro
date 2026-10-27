% Experiment 9: Mamdani Fuzzy Controller (fan speed)
% Turbo Prolog for DOSBox. Load, Compile, Run - the goal runs itself.
% Temperature 0-40 C (Cold, Warm, Hot), Humidity 0-100% (Low, Medium, High)
% Fan Speed 0-100% (Low, Medium, High). Three membership types are used:
% triangular, trapezoidal and Gaussian. AND = min, implication = min
% (clipping), aggregation = max, defuzzification = Centre of Gravity.
% The sweep at the end gives the points to plot (speed rises with temp).

predicates
  tri(real, real, real, real, real)
  trap(real, real, real, real, real, real)
  gauss(real, real, real, real)
  min2(real, real, real)
  max2(real, real, real)
  agg_at(real, real, real, real, real)
  centroid(real, real, real, real, real, real)
  max_loop(real, real, real, real, real, real)
  som_loop(real, real, real, real, real, real)
  lom_loop(real, real, real, real, real, real, real)
  fan_speed(real, real, real)
  sweep(real*, real)
  run

clauses
  tri(X, A, _, C, 0.0) :- X <= A.
  tri(X, _, _, C, 0.0) :- X >= C.
  tri(X, A, B, _, M) :- X > A, X < B, M = (X - A) / (B - A).
  tri(X, _, B, C, M) :- X >= B, X < C, M = (C - X) / (C - B).

  trap(X, A, _, _, D, 0.0) :- X <= A.
  trap(X, _, _, _, D, 0.0) :- X >= D.
  trap(X, _, B, C, _, 1.0) :- X >= B, X <= C.
  trap(X, A, B, _, _, M) :- X > A, X < B, M = (X - A) / (B - A).
  trap(X, _, _, C, D, M) :- X > C, X < D, M = (D - X) / (D - C).

  gauss(X, Mu, Sigma, G) :- D = (X - Mu) / Sigma, G = exp(0.0 - D * D).

  min2(A, B, A) :- A <= B.
  min2(A, B, B) :- A > B.
  max2(A, B, A) :- A >= B.
  max2(A, B, B) :- A < B.

  agg_at(X, LS, MS, HS, Agg) :-
    trap(X, 0.0, 0.0, 25.0, 50.0, ML),
    tri(X, 25.0, 50.0, 75.0, MM),
    trap(X, 50.0, 75.0, 100.0, 100.0, MH),
    min2(ML, LS, CL), min2(MM, MS, CM), min2(MH, HS, CH),
    max2(CL, CM, Tmp), max2(Tmp, CH, Agg).

  centroid(X, _, _, _, 0.0, 0.0) :- X > 100.0.
  centroid(X, LS, MS, HS, Num, Den) :-
    X <= 100.0, agg_at(X, LS, MS, HS, Agg),
    X1 = X + 5.0, centroid(X1, LS, MS, HS, Num1, Den1),
    Num = X * Agg + Num1, Den = Agg + Den1.

  max_loop(X, _, _, _, M, M) :- X > 100.0.
  max_loop(X, LS, MS, HS, M, Final) :-
    X <= 100.0, agg_at(X, LS, MS, HS, Agg), max2(M, Agg, M1),
    X1 = X + 5.0, max_loop(X1, LS, MS, HS, M1, Final).

  som_loop(X, _, _, _, _, 0.0) :- X > 100.0.
  som_loop(X, LS, MS, HS, Max, X) :- X <= 100.0, agg_at(X, LS, MS, HS, Max), !.
  som_loop(X, LS, MS, HS, Max, S) :- X <= 100.0, X1 = X + 5.0, som_loop(X1, LS, MS, HS, Max, S).

  lom_loop(X, _, _, _, _, Last, Last) :- X > 100.0.
  lom_loop(X, LS, MS, HS, Max, _, Final) :-
    X <= 100.0, agg_at(X, LS, MS, HS, Max), !,
    X1 = X + 5.0, lom_loop(X1, LS, MS, HS, Max, X, Final).
  lom_loop(X, LS, MS, HS, Max, Last, Final) :-
    X <= 100.0, X1 = X + 5.0, lom_loop(X1, LS, MS, HS, Max, Last, Final).

  fan_speed(Temp, Hum, Speed) :-
    trap(Temp, 0.0, 0.0, 10.0, 20.0, Cold),
    tri(Temp, 10.0, 25.0, 40.0, Warm),
    trap(Temp, 30.0, 35.0, 40.0, 40.0, Hot),
    trap(Hum, 0.0, 0.0, 20.0, 40.0, Low),
    gauss(Hum, 50.0, 20.0, Med),
    trap(Hum, 60.0, 80.0, 100.0, 100.0, High),
    min2(Warm, Low, R2), min2(Warm, Med, R3), min2(Warm, High, R4),
    max2(Cold, R2, LS), max2(R4, Hot, HS),
    centroid(0.0, LS, R3, HS, Num, Den), Speed = Num / Den.

  sweep([], _).
  sweep([T|Ts], H) :-
    fan_speed(T, H, S),
    write(T), write(" C -> fan "), write(S), write("%"), nl,
    sweep(Ts, H).

  run :-
    Temp = 28.0, Hum = 65.0,
    trap(Temp, 0.0, 0.0, 10.0, 20.0, Cold),
    tri(Temp, 10.0, 25.0, 40.0, Warm),
    trap(Temp, 30.0, 35.0, 40.0, 40.0, Hot),
    trap(Hum, 0.0, 0.0, 20.0, 40.0, Low),
    gauss(Hum, 50.0, 20.0, Med),
    trap(Hum, 60.0, 80.0, 100.0, 100.0, High),
    write("Temp 28 C: Cold="), write(Cold), write(", Warm="), write(Warm), write(", Hot="), write(Hot), nl,
    write("Humidity 65%: Low="), write(Low), write(", Medium="), write(Med), write(", High="), write(High), nl,
    min2(Warm, Low, R2), min2(Warm, Med, R3), min2(Warm, High, R4),
    write("Rules: R1="), write(Cold), write(", R2="), write(R2), write(", R3="), write(R3),
    write(", R4="), write(R4), write(", R5="), write(Hot), nl,
    max2(Cold, R2, LS), max2(R4, Hot, HS),
    write("Output strengths: Low="), write(LS), write(", Medium="), write(R3), write(", High="), write(HS), nl,
    fan_speed(Temp, Hum, Speed),
    write("Fan speed (Centre of Gravity) = "), write(Speed), write("%"), nl,
    max_loop(0.0, LS, R3, HS, 0.0, Mx),
    som_loop(0.0, LS, R3, HS, Mx, SoM),
    lom_loop(0.0, LS, R3, HS, Mx, 0.0, LoM),
    MoM = (SoM + LoM) / 2.0,
    write("Mean-of-Max="), write(MoM), write(", Smallest-of-Max="), write(SoM),
    write(", Largest-of-Max="), write(LoM), nl, nl,
    write("Sweep at humidity 65% (plot these points):"), nl,
    sweep([0.0, 10.0, 20.0, 30.0, 40.0], 65.0),
    write("Fan speed rises as temperature rises."), nl.

goal
  run.
