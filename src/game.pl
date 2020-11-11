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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%  Private predicates below  %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

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
