% TODO
minimax(GameState, Player, Level, NewGameState) :-
    minimaxStrength(GameState, Player, Level, 0, _, NewGameState).

minimaxStrength(GameState, Player, 0, Strength, NewStrength, NewGameState) :-
    valid_moves(GameState, Player, ListOfMoves),
    new_game_states(GameState, ListOfMoves, GameStates),
    random_member(NewGameState, GameStates),
    value(GameState, Player, Strength1),
    NewStrength is Strength + Strength1.

minimaxStrength(GameState, Player, 1, Strength, NewStrength, NewGameState) :-
    valid_moves(GameState, Player, ListOfMoves),
    new_game_states(GameState, ListOfMoves, GameStates),
    best_moves(GameState, Player, GameStates, BestMoves),
    random_member(NewGameState, BestMoves),
    value(NewGameState, Player, Value),
    NewStrength is Strength + Value.

new_game_states(_, [], []).
new_game_states(GameState, [Move|T], Res) :-
    Move = _Ri-_Ci-Rf-Cf,
    move(GameState, Move, GS),
    get_surrounded_lower_strength(GS, Rf-Cf, SurroundedLower),
    get_surrounded_lower_game_states(GS , Rf-Cf, SurroundedLower, GameStates),
    append([GS], GameStates, ListOfGS),
    new_game_states(GameState, T, T2),
    append(ListOfGS, T2, Res).

get_surrounded_lower_game_states(_, _, [], []).
get_surrounded_lower_game_states(GameState, OwnPos, [Pos|T], GameStates) :-
    actually_remove_strength(GameState, OwnPos, Pos, GS),
    get_surrounded_lower_game_states(GameState, OwnPos, T, T1),
    GameStates = [GS|T1].

best_moves(_, _, [], []).
best_moves(GameState, Player, GameStates, BestMoves) :-
    moves_values(GameState, Player, GameStates, Values),
    keysort(Values, V1),
    reverse(V1, V2),
    only_best_moves(V2, BestMoves).

only_best_moves([V-GS | T], Res) :-
    only_best_moves([V-GS | T], V, Res).

only_best_moves([], _, []).
only_best_moves([V-GS | T], V, [GS | TR]) :-
    !, only_best_moves(T, V, TR).
only_best_moves(_, _, []).

moves_values(_, _, [], []).
moves_values(GameState, Player, [GS|T], [Value-GS|TV]) :-
    value(GS, Player, Value),
    moves_values(GameState, Player, T, TV).