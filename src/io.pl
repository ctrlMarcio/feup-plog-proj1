/** <module> Input / Output

Coordinates all operations that deal with reading and writing.
*/

%!      write_header is det.
%
%       Writes the header of the game.
%       True always.
write_header :-
    write('  _______ _                     _____                                                                               '), nl,
    write(' |__   __| |                   |  __ \\                                                                              '), nl,
    write('    | |  | |__  _ __ ___  ___  | |  | |_ __ __ _  __ _  ___  _ __  ___                                              '), nl,
    write('    | |  | ''_ \\| ''__/ _ \\/ _ \\ | |  | | ''__/ _` |/ _` |/ _ \\| ''_ \\/ __|                                             '), nl,
    write('    | |  | | | | | |  __/  __/ | |__| | | | (_| | (_| | (_) | | | \\__ \\                                             '), nl,
    write('  __|_|_ |_|_|_|_|  \\___|\\___| |_____/|_|  \\__,_|\\__, |\\___/|_| |_|___/        _      _           _ _           _   '), nl,
    write(' |  \\/  | /_/          (_)         ___    | |     __/ |                       | |    (_)         (_) |         | |  '), nl,
    write(' | \\  / | __ _ _ __ ___ _  ___    ( _ )   | |    |___/ ___  _ __   ___  _ __  | |     _ _ __ ___  _| |_ ___  __| |  '), nl,
    write(' | |\\/| |/ _` | ''__/ __| |/ _ \\   / _ \\/\\ | |    / _ \\/ _ \\| ''_ \\ / _ \\| ''__| | |    | | ''_ ` _ \\| | __/ _ \\/ _` |  '), nl,
    write(' | |  | | (_| | | | (__| | (_) | | (_>  < | |___|  __/ (_) | | | | (_) | |    | |____| | | | | | | | ||  __/ (_| |_ '), nl,
    write(' |_|  |_|\\__,_|_|  \\___|_|\\___/   \\___/\\/ |______\\___|\\___/|_| |_|\\___/|_|    |______|_|_| |_| |_|_|\\__\\___|\\__,_(_)'), nl,
    nl, nl.

%!      write_board(+Board:list) is det.
%
%       Writes a horizontal border, followed by the actual board (game state) and the next player.
%       True when the board is well defined.
%
%       @arg Board          the board to be written
write_board(Board) :-
    write_border,
    board_height(Rows),
    write_pieces(Board, Rows),
    write_columns_names(1).

%!      write_end_board(+Board:list, +Winner) is det.
%
%       Writes a horizontal border, followed by the actual board (game state) and and indication to the winner of the
%       game.
%       True when the board is well defined.
%
%       @arg Board          the board to be written
%       @arg Winner         the winner of the game
write_end_board(Board, Winner) :-
    write_border,
    board_height(Rows),
    write_pieces(Board, Rows),
    write_winner(Winner).

% TODO
ask_move(Board, Player, Row1-Col1, Row2-Col2) :-
    write_next_player(Player),
    get PiecePosition asking 'What piece will you move?\nExample: a-1: ',
    get_move(Board, Player, PiecePosition, Row1-Col1, Row2-Col2).

%!      repeat_string(+String:string, +Amount:int) is det.
%
%       Writes a string a given number of times.
%       True when the amount is non negative.
repeat_string(_, 0) :-
    nl.
repeat_string(String, Amount) :-
    Amount > 0,
    write(String),
    Amount1 is Amount - 1,
    repeat_string(String, Amount1).

%!      write_pieces(+Board:list, +Rows:int) is det.
%
%       Writes the board withtout a top border.
%       True when the board is well defined.
%
%       @arg Board      the board to be written
write_pieces([], 0).
write_pieces([H|T], Rows) :-
    write('|'), write_array(H), write('  '),
    board_height(Height),
    RowNumber is Height - Rows + 1,
    write(RowNumber), nl,
    write_line,
    Rows1 is Rows - 1,
    write_pieces(T, Rows1).

%!      write_array(+Array:list) is det.
%
%       Writes the elements of a board row with the appropriate padding and separator.
%       True when the board is weel defind.
%
%       @arg Array      the board row to be written
write_array([]).
write_array([H|T]) :-
    write(' '), write(H), write(' |'),
    write_array(T).

write_columns_names(Column) :-
    board_width(TotalColumns),
    Column > TotalColumns,
    !, nl, nl.
write_columns_names(Column) :-
    write('   '),
    letter(Column, Letter),
    write(Letter),
    write(' '),
    Next is Column + 1,
    write_columns_names(Next).

%!      write_next_player(+Player) is det.
%
%       Writes an indication to the next player.
%       True when the Player is defined.
%
%       @arg Player     the next player
write_next_player(Player):-
    write('Next player: '), write(Player), nl, nl.

%!      write_winner(+Player) is det.
%
%       Writes an indication to the winner of the game.
%       True when the Player is defined.
%
%       @arg Player     the winner of the game
write_winner(Player):-
    write(Player), write(' won!!'), nl, nl.

%!      write_border is det.
%
%       Writes an appropriated size border in underscores ('_').
%       True when the board width is well defined.
write_border :-
    board_width(Width),
    Amount is Width * 5 + 1,
    repeat_string('_', Amount).

%!      write_line is det.
%
%       Writes an appropriated size border in hyphens underscores ('-').
%       True when the board width is well defined.
write_line :-
    board_width(Width),
    Amount is Width * 5 + 1,
    repeat_string('-', Amount).

% TODO
get_move(Board, Player, ReadableCoordinates, Row1-Col1, Row2-Col2) :-
    readable_to_coordinates(ReadableCoordinates, Row1-Col1),
    valid_moves(Board, Player, Row1-Col1, ListOfPossibleMoves),
    possible_move_representation(PossibleMove),
    insert_multiple_matrix(PossibleMove, Board, ListOfPossibleMoves, DemoMatrix),
    write_board(DemoMatrix),
    get Move asking 'Where to? ',
    readable_to_coordinates(Move, Row2-Col2),
    Row2-Col2 in ListOfPossibleMoves.

% TODO
readable_to_coordinates(Cola-Row, Row-Col) :-
    letter(Col, Cola).

% TODO
clear_piece(Board, Row-Col, NewBoard) :-
    empty(EmptyCell),
    insert_matrix(EmptyCell, Board, Row, Col, NewBoard).