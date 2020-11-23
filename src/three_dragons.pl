/** <module> Three Dragons

Initial file, reponsible to start and keep the game running.
*/

:-use_module(library(lists)).

:-include('game.pl').
:-include('pieces.pl').
:-include('util/operators.pl').
:-include('util/util.pl').
:-include('io/io.pl').
:-include('io/menu.pl').

% TODO
play :-
    write_header,
    initial(GameState),
    play(GameState).

% TODO
play(GameState) :-
    game_over(GameState, Winner), !,
    % TODO show board
    write(Winner), write(' won ihihihiihih'), nl.

play(GameState) :-
    GameState = Board-Player-PlayerPieces-_-_-_-_, % its cleaner this way
    repeat, % repeat the question in case the input is wrong
        display_game(Board),
        ask_move(Board, Player, Rowi-Coli-Rowf-Colf),
        move(GameState, Rowi-Coli-Rowf-Colf, NewBoard-Player-PlayerPieces-NewOpponentPieces-NewCaveL-NewCaveM-NewCaveR),
        !,
    next_player(Player, NextPlayer),
    play(NewBoard-NextPlayer-NewOpponentPieces-PlayerPieces-NewCaveL-NewCaveM-NewCaveR).

% TODO
initial(Board-Player-PlayerPieces-OpponentPieces-CaveL-CaveM-CaveR) :-
    init_board(Board),
    first_player(Player),
    initial_amount(PlayerPieces),
    initial_amount(OpponentPieces),
    left_cave(CaveL, 1, 1),
    large_cave(CaveM, 1, 5),
    right_cave(CaveR, 1, 9).

%!      display_game(+GameState:list) is det.
%
%       Displays a game state and an indication to the next player.
%       True always
%
%       @arg GameState          the game state to show. A list of list
display_game(GameState) :-
    write_board(GameState).

% TODO
valid_moves(Board-_-_-_, Player, ListOfMoves) :-
    all_valid_moves(Board, Player, 1-1, ListOfMoves), write(ListOfMoves).

% TODO
move(Board-Player-PlayerPieces-OpponentPieces-CaveL-CaveM-CaveR, Row1-Col1-Row2-Col2, NewBoard-Player-NewPlayerPieces-NewOpponentPieces-NewCaveL-NewCaveM-NewCaveR) :-
    % TODO verify move
    get_matrix(Board, Row1, Col1, Piece),
    insert_matrix(Piece, Board, Row2, Col2, Board1),
    clear_piece(Board1, Row1-Col1, Board2),

    check_if_captures(Board2, Row2-Col2, Player, OpponentPieces, Board3, NewOpponentPieces),
    summon_dragon(Board3, Row2-Col2, Player, PlayerPieces, CaveL-CaveM-CaveR, NewBoard, NewPlayerPieces, NewCaveL-NewCaveM-NewCaveR).

% TODO
game_over(_-Player-_-1-_-_, Player).
