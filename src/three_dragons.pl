/** <module> Three Dragons

Initial file, reponsible to start and keep the game running.
*/

:-use_module(library(lists)).

:-include('game.pl').
:-include('io.pl').
:-include('pieces.pl').
:-include('util/operators.pl').
:-include('util/util.pl').

%!      play() is det.
%
%       True always.
%
%       @tbd
play :-
    write_header,
    initial(InitialBoard),
    first_player(FirstPlayer),
    second_player(SecondPlayer),
    initial_amount(Pieces),
    abolish(state/2),
    asserta(state(FirstPlayer, InitialBoard)),
    abolish(pieces/2),
    asserta(pieces(FirstPlayer, Pieces)),
    asserta(pieces(SecondPlayer, Pieces)),
    repeat,
        state(Player, Board),
        next_player(Player, NextPlayer),
        pieces(NextPlayer, OpponentPieces),
        display_game(Board),
        ask_move(Board, Player, Row1-Col1, Row2-Col2),
        move(Board, Row1-Col1, Row2-Col2, Player, OpponentPieces, NewBoard, NewOpponentPieces),
        retract(state(Player, Board)),
        asserta(state(NextPlayer, NewBoard)),
        retract(pieces(NextPlayer, OpponentPieces)),
        asserta(pieces(NextPlayer, NewOpponentPieces)),
        game_over(Player, NewOpponentPieces, Winner),
    % TODO show board
    write(Winner), write(' ganhou ihihihiihih'), nl.

%!      initial(-GameState:list) is det.
%
%       Initializes the game state.
%       True always
%
%       @arg GameState          the game state to initialize. A list of lists
initial(GameState) :-
    init_board(GameState).

%!      display_game(+GameState:list) is det.
%
%       Displays a game state and an indication to the next player.
%       True always
%
%       @arg GameState          the game state to show. A list of list
display_game(GameState) :-
    write_board(GameState).

% TODO
valid_moves(GameState, Player, Row-Col, ListOfMoves) :-
    get_matrix(GameState, Row, Col, Piece), % gets the piece in the Row-Col position
    color_value(Piece, Player, _),          % verifies if the piece belongs to the player
    possible_moves(GameState, Row-Col, ListOfMoves).

% TODO
move(Board, Row1-Col1, Row2-Col2, Player, OpponentPieces, NewBoard, NewOpponentPieces) :-
    % TODO verify move
    get_matrix(Board, Row1, Col1, Piece),
    insert_matrix(Piece, Board, Row2, Col2, Board1),
    clear_piece(Board1, Row1-Col1, Board2),
    
    check_if_eats(Board2, Row2-Col2, Player, OpponentPieces, NewBoard, NewOpponentPieces).

% TODO remove
game_over(Player, 1, Player).
