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

write_board(Board) :-
    write_border,
    write_pieces(Board).

write_pieces([]).
write_pieces([H|T]) :-
    write('|'), write_array(H), nl,
    write_line,
    write_pieces(T).

write_array([]).
write_array([H|T]) :-
    write(' '), write(H), write(' |'),
    write_array(T).

repeat_string(_, 0) :-
    nl.

repeat_string(String, Amount) :-
    Amount > 0,
    write(String),
    Amount1 is Amount - 1,
    repeat_string(String, Amount1).

write_border :-
    board_width(Width),
    Amount is Width * 5 + 1,
    repeat_string('_', Amount).

write_line :-
    board_width(Width),
    Amount is Width * 5 + 1,
    repeat_string('-', Amount).