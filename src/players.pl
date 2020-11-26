% TODO docs

% types
human('Human').
bot0('Computer level 0').

player_type(Type) :-
    human(Type).
player_type(Type) :-
    bot0(Type).

players(List) :-
    human(Human),
    bot0(Bot0),
    List = [Human, Bot0].

% numbers
player1('Player 1').
player2('Player 2').

player_number(Number) :-
    player1(Number).
player_number(Number) :-
    player2(Number).

player_number('Player 1').
player_number('Player 2').

% both
:- dynamic(player/2).

player('Player 1', 'Human').
player('Player 2', 'Computer level 0').

set_choice(PlayerNumber, PlayerType) :-
    player_number(PlayerNumber),
    player_type(PlayerType),
    retractall(player(PlayerNumber, _)),
    asserta(player(PlayerNumber, PlayerType)).