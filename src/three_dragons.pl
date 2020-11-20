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
    initial(GameState),
    play(GameState).

% TODO
play(GameState) :-
    game_over(GameState, Winner),
    % TODO show board
    write(Winner), write(' won ihihihiihih'), nl.

play(GameState) :-
    GameState = Board-Player-PlayerPieces-_, % its cleaner this way
    repeat, % repeat the question in case the input is wrong
        display_game(Board),
        ask_move(Board, Player, Row1-Col1-Row2-Col2),
        move(GameState, Row1-Col1-Row2-Col2, NewBoard-Player-PlayerPieces-NewOpponentPieces),
        !,
    next_player(Player, NextPlayer),
    play(NewBoard-NextPlayer-NewOpponentPieces-PlayerPieces).

% TODO
initial(Board-Player-PlayerPieces-OpponentPieces) :-
    write_header,
    init_board(Board),
    first_player(Player),
    initial_amount(PlayerPieces),
    initial_amount(OpponentPieces).

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
move(Board-Player-PlayerPieces-OpponentPieces, Row1-Col1-Row2-Col2, NewBoard-Player-PlayerPieces-NewOpponentPieces) :-
    % TODO verify move
    get_matrix(Board, Row1, Col1, Piece),
    insert_matrix(Piece, Board, Row2, Col2, Board1),
    clear_piece(Board1, Row1-Col1, Board2),

    check_if_captures(Board2, Row2-Col2, Player, OpponentPieces, NewBoard, NewOpponentPieces).

% TODO
game_over(_-Player-_-1, Player).
