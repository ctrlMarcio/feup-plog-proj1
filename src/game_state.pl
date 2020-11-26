% TODO
% Board-Player-PlayerPieces-OpponentPieces-CaveL-CaveM-CaveR
game_state_construct([_, _, _, _, _, _, _]).
game_state_construct(Board, Player, PlayerPieces, OpponentPieces, CaveL, CaveM, CaveR, GameState) :-
    game_state_construct(GS1),
    set_game_state(GS1, board, Board, GS2),
    set_game_state(GS2, current_player, Player, GS3),
    set_game_state(GS3, player_pieces, PlayerPieces, GS4),
    set_game_state(GS4, opponent_pieces, OpponentPieces, GS5),
    set_game_state(GS5, cave_l, CaveL, GS6),
    set_game_state(GS6, cave_m, CaveM, GS7),
    set_game_state(GS7, cave_r, CaveR, GameState).

game_state(GameState, Attribute, Value) :-
    F =.. [Attribute, GameState, Value, _], F.

game_state(_, []).
game_state(GameState, [H-V|T]) :-
    game_state(GameState, H, V),
    game_state(GameState, T).

set_game_state(GameState, Attribute, Value, NewGameState) :-
    F =.. [Attribute, GameState, _, N], F,
   update_value(GameState, Value, N, NewGameState).

set_game_state(GameState, [], GameState).
set_game_state(GameState, [H-V|T], NewGameState) :-
    set_game_state(GameState, H, V, GS1),
    set_game_state(GS1, T, NewGameState).

dashed_game_state([H], H).
dashed_game_state([H|T], Dashed) :-
    dashed_game_state(T, Dashed1),
    Dashed = H-Dashed1.

board(GameState, X, 1)              :- nth1(1, GameState, X).
current_player(GameState, X, 2)     :- nth1(2, GameState, X).
player_pieces(GameState, X, 3)      :- nth1(3, GameState, X).
opponent_pieces(GameState, X, 4)    :- nth1(4, GameState, X).
cave_l(GameState, X, 5)             :- nth1(5, GameState, X).
cave_m(GameState, X, 6)             :- nth1(6, GameState, X).
cave_r(GameState, X, 7)             :- nth1(7, GameState, X).
caves(GameState, X, _)              :- cave_l(GameState, L, _), cave_m(GameState, M, _), cave_r(GameState, R, _), X = L-M-R.
