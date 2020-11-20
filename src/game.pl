/** <module> Game

Responsible for all game related predicates.
*/

/* The board dimensions */

% use an odd width if possible to avoid errors
board_width(9).
board_height(9).

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
all_valid_moves(_, _, Row-_, []) :-
    board_height(Height),
    Row > Height.
all_valid_moves(Board, Player, Row-Col, ListOfMoves) :-
    Col1 is Col + 1,
    board_height(Height),
    Col1 =< Height, !,
    possible_moves(Board, Player, Row-Col, List1),
    all_valid_moves(Board, Player, Row-Col1, List2),
    append(List1, List2, ListOfMoves).
all_valid_moves(Board, Player, Row-Col, ListOfMoves) :-
    Row1 is Row + 1,
    possible_moves(Board, Player, Row-Col, List1),
    all_valid_moves(Board, Player, Row1-0, List2),
    append(List1, List2, ListOfMoves).

% TODO
possible_moves(Board, Player, Row-Col, List) :-
    Row-Col on Board is_of Player,
    possible_moves_up(Board, Row-Col, Row-Col, ListUp),
    possible_moves_right(Board, Row-Col, Row-Col, ListRight),
    possible_moves_down(Board, Row-Col, Row-Col, ListDown),
    possible_moves_left(Board, Row-Col, Row-Col, ListLeft),
    append(ListUp, ListRight, List1),
    append(List1, ListDown, List2),
    append(List2, ListLeft, List3),
    delete(List3, Row-Col-Row-Col, List4),  % deletes self position
    sort(List4, List).                 % sort removes duplicates uwu
possible_moves(_, _, _, []).

% TODO
check_if_captures(Board, Row-Col, Player, OpponentPieces, NewBoard, NewOpponentPieces) :-
    LesserStrength = [],
    get_matrix(Board, Row, Col, Piece),
    % TODO remove player, Piece is enough
    capture_surrounded_up(Board, Row-Col, Piece, Player, OpponentPieces, LesserStrength, Board1, OPieces1, LS1),
    capture_surrounded_down(Board1, Row-Col, Piece, Player, OPieces1, LS1, Board2, OPieces2, LS2),
    capture_surrounded_left(Board2, Row-Col, Piece, Player, OPieces2, LS2, Board3, OPieces3, LS3),
    capture_surrounded_right(Board3, Row-Col, Piece, Player, OPieces3, LS3, Board4, OPieces4, LS),
    ask_capture_strength(Board4, Row-Col, OPieces4, LS, NewBoard, NewOpponentPieces).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%  Private predicates below  %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% TODO
possible_moves_up(Board, Row1-Col1, Row-Col, List) :-
    empty(Empty),
    NextRow is Row - 1,
    get_matrix(Board, NextRow, Col, X),
    X == Empty, !, % TODO prolog this
    possible_moves_up(Board, Row1-Col1, NextRow-Col, List1),
    List = [Row1-Col1-Row-Col | List1].
possible_moves_up(_, Row1-Col1, Row-Col, [Row1-Col1-Row-Col]).

% TODO
possible_moves_right(Board, Row1-Col1, Row-Col, List) :-
    empty(Empty),
    NextCol is Col + 1,
    get_matrix(Board, Row, NextCol, X),
    X == Empty, !,
    possible_moves_right(Board, Row1-Col1, Row-NextCol, List1),
    List = [Row1-Col1-Row-Col | List1].
possible_moves_right(_, Row1-Col1, Row-Col, [Row1-Col1-Row-Col]).

% TODO
possible_moves_down(Board, Row1-Col1, Row-Col, List) :-
    empty(Empty),
    NextRow is Row + 1,
    get_matrix(Board, NextRow, Col, X),
    X == Empty, !,
    possible_moves_down(Board, Row1-Col1, NextRow-Col, List1),
    List = [Row1-Col1-Row-Col | List1].
possible_moves_down(_, Row1-Col1, Row-Col, [Row1-Col1-Row-Col]).

% TODO
possible_moves_left(Board, Row1-Col1, Row-Col, List) :-
    empty(Empty),
    NextCol is Col - 1,
    get_matrix(Board, Row, NextCol, X),
    X == Empty, !,
    possible_moves_left(Board, Row1-Col1, Row-NextCol, List1),
    List = [Row1-Col1-Row-Col | List1].
possible_moves_left(_, Row1-Col1, Row-Col, [Row1-Col1-Row-Col]).

% TODO
find_piece(Board, Player, Piece, Row-Col) :-
    Row1-Col1 = 1-1,
    find_piece1(Board, Player, Piece, Row1-Col1, Row-Col).

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
    Width is_odd,

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

% TODO
valid_piece_moves(Board, Player, Row-Col, ListOfMoves) :-
    get_matrix(Board, Row, Col, Piece), % gets the piece in the Row-Col position
    color_value(Piece, Player, _),          % verifies if the piece belongs to the player
    possible_moves(Board, Player, Row-Col, ListOfMoves).

% TODO
clear_piece(Board, Row-Col, NewBoard) :-
    empty(EmptyCell),
    insert_matrix(EmptyCell, Board, Row, Col, NewBoard).

% TODO
capture_surrounded_up(Board, Row-Col, Piece, Player, OpponentPieces, LesserStrength, NewBoard, NewOpponentPieces, NewLesserStrength) :-
    Row1 is Row-1,
    Row2 is Row-2,
    clear_surrounded_cell(Board, Piece, Row1-Col, Row2-Col, Player, OpponentPieces, LesserStrength, NewBoard, NewOpponentPieces, NewLesserStrength).

capture_surrounded_right(Board, Row-Col, Piece, Player, OpponentPieces, LesserStrength, NewBoard, NewOpponentPieces, NewLesserStrength) :-
    Col1 is Col+1,
    Col2 is Col+2,
    clear_surrounded_cell(Board, Piece, Row-Col1, Row-Col2, Player, OpponentPieces, LesserStrength, NewBoard, NewOpponentPieces, NewLesserStrength).

capture_surrounded_down(Board, Row-Col, Piece, Player, OpponentPieces, LesserStrength, NewBoard, NewOpponentPieces, NewLesserStrength) :-
    Row1 is Row+1,
    Row2 is Row+2,
    clear_surrounded_cell(Board, Piece, Row1-Col, Row2-Col, Player, OpponentPieces, LesserStrength, NewBoard, NewOpponentPieces, NewLesserStrength).

capture_surrounded_left(Board, Row-Col, Piece, Player, OpponentPieces, LesserStrength, NewBoard, NewOpponentPieces, NewLesserStrength) :-
    Col1 is Col-1,
    Col2 is Col-2,
    clear_surrounded_cell(Board, Piece, Row-Col1, Row-Col2, Player, OpponentPieces, LesserStrength, NewBoard, NewOpponentPieces, NewLesserStrength).

% TODO
clear_surrounded_cell(Board, OwnPiece, Row-Col, Row2-Col2, Player, OpponentPieces, LesserStrength, NewBoard, NewOpponentPieces, NewLesserStrength) :-
    next_player(Player, OtherPlayer),
    get_matrix(Board, Row, Col, OpPiece),
    color_value(OpPiece, OtherPlayer, _),
    remove_piece(Board, OwnPiece, Row-Col, OpPiece, Row2-Col2, Player, OpponentPieces, LesserStrength, NewBoard, NewOpponentPieces, NewLesserStrength).

clear_surrounded_cell(Board, _, _, _, _, OpponentPieces, LesserStrength, Board, OpponentPieces, LesserStrength).

remove_piece(Board, _, Row-Col, _, Row2-Col2, Player, OpponentPieces, LesserStrength, NewBoard, NewOpponentPieces, LesserStrength) :-
    get_matrix(Board, Row2, Col2, Piece2),
    (color_value(Piece2, Player, _) ; object(Piece2)), !,
    clear_piece(Board, Row-Col, NewBoard),
    NewOpponentPieces is OpponentPieces - 1.
remove_piece(Board, OwnPiece, Row-Col, OpPiece, _, _, OpponentPieces, LesserStrength, Board, OpponentPieces, [Row-Col | LesserStrength]) :-
    color_value(OwnPiece, _, OwnStrength),
    color_value(OpPiece, _, OpStrength),
    OwnStrength > OpStrength, !.

% TODO
lower_strength(Board, Row-Col, NewBoard) :-
    get_matrix(Board, Row, Col, Piece),
    color_value(Piece, Player, Strength),
    Strength > 1,
    NewStrength is Strength - 1,
    color_value(NewPiece, Player, NewStrength),
    insert_matrix(NewPiece, Board, Row, Col, NewBoard).

% TODO
get_destinations([], []).
get_destinations([_-_-MR2-MC2 | MovesT], [MR2-MC2 | DestinationsT]) :-
    get_destinations(MovesT, DestinationsT).