/** <module> Three Dragons

Initial file, reponsible to start and keep the game running.
*/

:-include('game.pl').
:-include('io.pl').

%!      play() is det.
%
%       True always.
%
%       @tbd
play :-
    write_header,
    initial(GameState),
    first_player(Player),
    display_game(GameState, Player).

%!      initial(-GameState:list) is det.
%
%       Initializes the game state.
%       True always
%
%       @arg GameState          the game state to initialize. A list of lists
initial(GameState) :-
    init_board(GameState).

%!      display_game(+GameState:list, Player) is det.
%
%       Displays a game state and an indication to the next player.
%       True always
%
%       @arg GameState          the game state to show. A list of list
%       @arg Player             the next player
display_game(GameState, Player) :-
    write_board(GameState, Player).

% TODO
valid_moves(GameState, Player, Row-Col, ListOfMoves) :-
    get_matrix(GameState, Row, Col, Piece), % gets the piece in the Row-Col position
    color_value(Piece, Player, _),          % verifies if the piece belongs to the player
    possible_moves(GameState, Row-Col, ListOfMoves).