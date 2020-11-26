minimax(GameState, Player, Level, Move) :-
    minimaxStrength(GameState, Player, Level, 0, _, Move).

minimaxStrength(GameState, Player, 0, Strength, NewStrength, Move) :-
    valid_moves(GameState, Player, ListOfMoves),
    random_member(Move, ListOfMoves),
    value(GameState, Player, Strength1),
    NewStrength is Strength + Strength1.

minimaxStrength(GameState, Player, 1, Strength, NewStrength, Move) :-
    valid_moves(GameState, Player, ListOfMoves),
    best_moves(GameState, Player, ListOfMoves, BestMoves),
    random_member(Move, BestMoves),
    move(GameState, Move, GS1),
    value(GS1, Player, Value),
    NewStrength is Strength + Value.

best_moves(_, _, [], []).
best_moves(GameState, Player, Moves, BestMoves) :-
    moves_values(GameState, Player, Moves, Values),
    keysort(Values, V1),
    reverse(V1, V2),
    only_best_moves(V2, BestMoves).

only_best_moves([V-GS-Rowi-Coli-Rowf-Colf | T], Res) :-
    only_best_moves([V-GS-Rowi-Coli-Rowf-Colf | T], V, Res).

only_best_moves([], _, []).
only_best_moves([V-_-Rowi-Coli-Rowf-Colf | T], V, [Rowi-Coli-Rowf-Colf | TR]) :-
    !, only_best_moves(T, V, TR).
only_best_moves(_, _, []).

moves_values(_, _, [], []).
moves_values(GameState, Player, [Ri-Ci-Rf-Cf|T], [HV|TV]) :-
    move(GameState, Ri-Ci-Rf-Cf, GS1),
    value(GS1, Player, Value),
    HV = Value-GS1-Ri-Ci-Rf-Cf,
    moves_values(GameState, Player, T, TV).