/** <module> Game

Responsible for all game related predicates.
*/

/* The board dimensions */

% use an odd width if possible to avoid errors
board_width(9).
board_height(9).

:-include('util.pl').
:-include('pieces.pl').
:-use_module(library(lists)).

%!      init_board(-Board:list) is det.
%
%       True whenever the board_witdth and board_height are larger than 4 and the widht is odd.
%
%       @arg Board      the board to init. A list of lists
init_board(Board) :-
    second_player(Second),
    init_board_half(Second, Half1),

    init_middle_row(MiddleRow),
    append(Half1, [MiddleRow], Board1),

    first_player(First),
    init_board_half(First, Half2Reversed),
    reverse(Half2Reversed, Half2),

    append(Board1, Half2, Board).

%!      empty_board(-Board:list) is det.
%
%       Gets an empty board.
%       True whenever the board_witdth and board_height are larger than 4 and the widht is odd.
%
%       @arg Board      the board to init. A list of lists
empty_board(Board) :-
    empty(Cell),
    init_board_half(Cell, Half1),

    init_middle_row(MiddleRow),
    append(Half1, [MiddleRow], Board1),

    init_board_half(Cell, Half2Reversed),
    reverse(Half2Reversed, Half2),

    append(Board1, Half2, Board).

% TODO
find_piece(Board, Player, Piece, Row-Col) :-
    Row1-Col1 = 1-1,
    find_piece1(Board, Player, Piece, Row1-Col1, Row-Col).

% TODO
possible_moves(Board, Row-Col, List) :-
    possible_move_up(Board, Row-Col, RU-CU),
    possible_move_right(Board, Row-Col, RR-CR),
    possible_move_down(Board, Row-Col, RD-CD),
    possible_move_left(Board, Row-Col, RL-CL),
    L = [RU-CU, RR-CR, RD-CD, RL-CL],
    delete(L, Row-Col, L1),
    sort(L1, List). % sort removes duplicates uwu

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%  Private predicates below  %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% TODO
possible_move_up(Board, Row-Col, RU-CU) :-
    empty(Empty),
    NextRow is Row - 1,
    get_matrix(Board, NextRow, Col, X),
    X == Empty, !,
    possible_move_up(Board, NextRow-Col, RU-CU).
possible_move_up(_, Row-Col, Row-Col).

% TODO
possible_move_right(Board, Row-Col, RR-CR) :-
    empty(Empty),
    NextCol is Col + 1,
    get_matrix(Board, Row, NextCol, X),
    X == Empty, !,
    possible_move_right(Board, Row-NextCol, RR-CR).
possible_move_right(_, Row-Col, Row-Col).

% TODO
possible_move_down(Board, Row-Col, RD-CD) :-
    empty(Empty),
    NextRow is Row + 1,
    get_matrix(Board, NextRow, Col, X),
    X == Empty, !,
    possible_move_down(Board, NextRow-Col, RD-CD).
possible_move_down(_, Row-Col, Row-Col).

% TODO
possible_move_left(Board, Row-Col, RL-CL) :-
    empty(Empty),
    NextCol is Col - 1,
    get_matrix(Board, Row, NextCol, X),
    X == Empty, !,
    possible_move_left(Board, Row-NextCol, RL-CL).
possible_move_left(_, Row-Col, Row-Col).

% TODO
find_piece1([H|_], Player, Piece, Row1-Col1, Row-Col) :-
    find_piece_row(H, Player, Piece, Row1-Col1, Row-Col).
find_piece1([_|T], Player, Piece, Row1-Col1, Row-Col) :-
    Row2 is Row1 + 1,
    find_piece1(T, Player, Piece, Row2-Col1, Row-Col).

% TODO
find_piece_row([H|_], Player, H, Row-Col, Row-Col) :-
    color_value(H, Player, _).
find_piece_row([_|T], Player, Piece, Row1-Col1, Row-Col) :-
    Col2 is Col1 + 1,
    find_piece_row(T, Player, Piece, Row1-Col2, Row-Col).

%!      init_board_half(+Color:string, -Half:list) is det.
%
%       True whenever the board_witdth and board_height are larger than 4 and the widht is odd.
%
%       @arg Color      the color that the pieces have in the respective half
%       @arg Half       the half to init. A list of lists
init_board_half(Color, Half) :-
    % first row
    init_border_row(Color, Row1),

    % second row
    init_second_row(Color, Row2),
    append([Row1], [Row2], PiecesHalf),
    
    % number of empty rows
    board_height(Height),
    EmptyRowsAmount is div(Height - 1, 2) - 2,

    % adds the empty rows
    init_empty_row(EmptyRow),
    fill_list(EmptyRow, EmptyRowsAmount, AllEmptyRows),

    append(PiecesHalf, AllEmptyRows, Half).

%!      init_middle_row(-Row:list) is det.
%
%       True always.
%
%       @arg Row        the row to init that represents the middle row of a board
init_middle_row(Row) :-
    small_cave(SC, 1),
    large_cave(LC, 1),
    empty(Empty),
    Row1 = [SC],

    board_width(Width),
    EmptyCellsAmount is div((Width - 1), 2) - 1,
    fill_list(Empty, EmptyCellsAmount, EmptyCells),
    append(Row1, EmptyCells, Row2),

    append(Row2, [LC], Row3),

    append(Row3, EmptyCells, Row4),

    append(Row4, [SC], Row).

%!      init_border_row(+Color:string, -Row:list) is det.
%
%       True always.
%
%       @arg Color      the color that the pieces have in the row
%       @arg Row        the row to init that represents the closest row to its plyer (being it on the top or bottom)
init_border_row(Color, Row) :-
    mountain(Mountain),
    Row1 = [Mountain],

    color_value(C3, Color, 3),
    append(Row1, [C3], Row2),
    
    board_width(Width),
    W2Size is Width - 4,
    color_value(C2, Color, 2),
    fill_list(C2, W2Size, W2List),
    append(Row2, W2List, Row3),

    append(Row3, [C3], Row4),

    append(Row4, [Mountain], Row).

%!      init_second_row(+Color:string, -Row:list) is det.
%
%       True whenever the board_witdth and board_height are larger than 4 and the widht is odd.
%
%       @arg Color      the color that the pieces have in the row
%       @arg Row        the row to init that represents the 2nd closest row to its plyer (being it on the top or bottom)
init_second_row(Color, Row) :-
    % verifies if the width of the board is odd
    board_width(Width),
    odd(Width),

    % gets the values to fill
    empty(Empty),
    EmptyCells is div((Width - 1), 2),
    color_value(C4, Color, 4),

    fill_list(Empty, EmptyCells, EmptyCellsList),
    Row1 = EmptyCellsList,

    append(Row1, [C4], Row2),

    append(Row2, Row1, Row).

%!      init_empty_row(-Row:list) is det.
%
%       True always.
%
%       @arg Row        the row to init that represents one of the empty rows of the board
init_empty_row(Row) :-
    empty(Empty),
    board_width(Width),

    fill_list(Empty, Width, Row).
