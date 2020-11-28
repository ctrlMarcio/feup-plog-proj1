/** <module> Three Dragons

Initial file, reponsible to start and keep the game running.
*/

:-use_module(library(lists)).
:- use_module(library(random)).

:-include('game.pl').
:-include('pieces.pl').
:-include('players.pl').
:-include('game_state.pl').
:-include('minimax.pl').
:-include('util/operators.pl').
:-include('util/util.pl').
:-include('io/io.pl').
:-include('io/menu.pl').
:-include('io/initial_menu.pl').

% TODO
play :-
    initial_menu,
    initial(GameState),
    play(GameState).

% TODO
play(GameState) :-
    game_over(GameState, Winner), !,
    game_state(GameState, board, Board),
    display_game(Board),
    write(Winner), write(' won ihihihiihih'), nl.

play(GameState) :-
    game_state(GameState, board, Board),
    game_state(GameState, current_player, Player),
    repeat, % repeat the question in case the input is wrong
        display_game(Board),
        get_move(GameState, GameState1),
        !,
    next_player(Player, NextPlayer),
    game_state(GameState1, [player_pieces-OpponentPieces, opponent_pieces-PlayerPieces]),
    set_game_state(GameState1, [current_player-NextPlayer, player_pieces-PlayerPieces, opponent_pieces-OpponentPieces], NewGameState),
    play(NewGameState).

% TODO
initial(GameState) :-
    init_board(Board),
    player1(Player),
    initial_amount(PlayerPieces),
    initial_amount(OpponentPieces),
    cave(CaveL, 1, 1),
    cave(CaveM, 1, 5),
    cave(CaveR, 1, 9),
    game_state_construct(Board, Player, PlayerPieces, OpponentPieces, CaveL, CaveM, CaveR, GameState).

%!      display_game(+GameState:list) is det.
%
%       Displays a game state and an indication to the next player.
%       True always
%
%       @arg GameState          the game state to show. A list of list
display_game(GameState) :-
    write_header,
    write_board(GameState).

% TODO
valid_moves(GameState, Player, ListOfMoves) :-
    game_state(GameState, board, Board),
    game_state(GameState, current_player, Player),
    all_valid_moves(Board, Player, 1-1, ListOfMoves).

% TODO
% human
get_move(GameState, NewGameState) :-
    game_state(GameState, [board-Board, current_player-Player]),
    human(Level),
    player(Player, Level), !,
    ask_move(Board, Player, Rowi-Coli-Rowf-Colf),
    move(GameState, Rowi-Coli-Rowf-Colf, GameState1),
    ask_capture_strength(GameState1, Rowf-Colf, NewGameState).

get_move(GameState, NewGameState) :-
    game_state(GameState, [current_player-Player]),
    player(Player, Level),
    choose_move(GameState, Player, Level, Move),
    move(GameState, Move, NewGameState).

% TODO
move(GameState, Row1-Col1-Row2-Col2, NewGameState) :-
    % TODO verify move
    game_state(GameState, [board-Board, current_player-Player, player_pieces-PlayerPieces, opponent_pieces-OpponentPieces, caves-Caves]),

    get_matrix(Board, Row1, Col1, Piece),
    insert_matrix(Piece, Board, Row2, Col2, Board1),
    clear_piece(Board1, Row1-Col1, Board2),

    check_if_captures(Board2, Row2-Col2, Player, OpponentPieces, Board3, NewOpponentPieces),
    summon_dragon(Board3, Row2-Col2, Player, PlayerPieces, Caves, Board4, NewPlayerPieces, NewCaveL-NewCaveM-NewCaveR),
    reset_caves(Board4, Row1-Col1, Caves, NewBoard),

    set_game_state(GameState, [opponent_pieces-NewOpponentPieces, player_pieces-NewPlayerPieces, cave_l-NewCaveL, cave_m-NewCaveM, cave_r-NewCaveR, board-NewBoard], NewGameState).

% TODO
value(GameState, Player, Value) :-
    game_state(GameState, [current_player-Player, player_pieces-PlayerPieces, opponent_pieces-OpponentPieces]), !,
    Value is PlayerPieces - OpponentPieces.
value(GameState, _, Value) :-
    game_state(GameState, [player_pieces-PlayerPieces, opponent_pieces-OpponentPieces]), !,
    Value is OpponentPieces - PlayerPieces.

choose_move(GameState, Player, Level, Move) :-
    minimax(GameState, Player, Level, Move).

% TODO
game_over(GameState, Player) :-
    game_state(GameState, [current_player-Player, opponent_pieces-1]).
