% TODO
minimax(GameState, Player, Player, 0, Strength, NewGameState) :-
    possible_game_states(GameState, Player, GameStates),
    random_member(NewGameState, GameStates),
    value(GameState, Player, Strength).

minimax(GameState, Player, Player, 1, Strength, NewGameState) :-
    possible_game_states(GameState, Player, GameStates),
    best_moves(GameState, Player, GameStates, BestMoves),
    random_member(Strength-NewGameState, BestMoves).
minimax(GameState, CurrentPlayer, Player, 1, Strength, NewGameState) :-
    CurrentPlayer \= Player,
    possible_game_states(GameState, Player, GameStates),
    best_moves(GameState, Player, GameStates, BestMoves),
    random_member(OpponentStrength-NewGameState, BestMoves),
    Strength is 0 - OpponentStrength.

minimax(GameState, _, Player, Level, Strength, NewGameState) :-
    Level > 1,
    possible_game_states(GameState, Player, AllGameStates),
    get_game_states_values(AllGameStates, Player, Level, Values),
    sort(Values, V1),
    reverse(V1, V2),
    select_only_best_moves_past_game_state(V2, BestMoves),
    random_member(Strength-NewGameState-_, BestMoves).

possible_game_states(GameState, Player, GameStates) :-
    valid_moves(GameState, Player, ListOfMoves),
    new_game_states(GameState, ListOfMoves, GameStates).

get_game_states_values([], _, _, []).
get_game_states_values([H|T], Player, Level, [V-H-HRes|TR]) :-
    Level1 is Level - 1,
    next_player(Player, Next),
    minimax(H, Player, Next, Level1, V, HRes),
    get_game_states_values(T, Player, Level, TR).

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
    select_only_best_moves(V2, BestMoves).

select_only_best_moves([V-GS | T], Res) :-
    select_only_best_moves([V-GS | T], V, Res).

select_only_best_moves([], _, []).
select_only_best_moves([V-GS | T], V, [V-GS | TR]) :-
    !, select_only_best_moves(T, V, TR).
select_only_best_moves(_, _, []).

select_only_best_moves_past_game_state([V-GS-GO | T], Res) :-
    select_only_best_moves_past_game_state([V-GS-GO | T], V, Res).
select_only_best_moves_past_game_state([], _, []).
select_only_best_moves_past_game_state([V-OGS-RGS | T], V, [V-OGS-RGS | TR]) :-
    !, select_only_best_moves_past_game_state(T, V, TR).
select_only_best_moves_past_game_state(_, _, []).

moves_values(_, _, [], []).
moves_values(GameState, Player, [GS|T], [Value-GS|TV]) :-
    value(GS, Player, Value),
    moves_values(GameState, Player, T, TV).