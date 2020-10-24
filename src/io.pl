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

%!      write_board(+Board:list, +NextPlayer) is det.
%
%       Writes a horizontal border, followed by the actual board (game state) and the next player.
%       True when the board is well defined.
%
%       @arg Board          the board to be written
%       @arg NextPlayer     the next player to play
write_board(Board, NextPlayer) :-
    write_border,
    write_pieces(Board),
    write_next_player(NextPlayer).

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

%!      write_pieces(+Board:list) is det.
%
%       Writes the board withtout a top border.
%       True when the board is well defined.
%
%       @arg Board      the board to be written
write_pieces([]).
write_pieces([H|T]) :-
    write('|'), write_array(H), nl,
    write_line,
    write_pieces(T).

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

%       @tbd
write_next_player(Player):-
    write('Todo menina Leonor m Gomes'), write(Player), nl,
    write('está a dar write de player para nao dar erro chato de singleton btw'), nl.

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
