:-include('game.pl').
:-include('io.pl').

%!      play() is det.
%
%       True always.
%
%       @tbd
play() :-
    init_board(Board),
    write_board(Board).