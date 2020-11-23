/** <module> Pieces

Defines all pieces.
*/

/* Inanimate pieces */

empty('  ').
mountain('MM').
possible_move_representation('<>').

% caves
caves_row(5).
left_cave('c1', 1, 1).
left_cave('c0', 0, 1).
large_cave('A1', 1, 5).
large_cave('A0', 0, 5).
right_cave('c1', 1, 9).
right_cave('c0', 0, 9).

small_cave(Piece, Value) :- left_cave(Piece, Value, _).
small_cave(Piece, Value) :- right_cave(Piece, Value, _).
large_cave(Piece, Value) :- large_cave(Piece, Value, 5).

cave(Piece, Value) :-
  small_cave(Piece, Value).
cave(Piece, Value) :-
  large_cave(Piece, Value).

cut_cave(Cave, NewCave) :-
  small_cave(Cave, Number),
  Number > 0,
  Number1 is Number - 1,
  small_cave(NewCave, Number1).

cut_cave(Cave, NewCave) :-
  large_cave(Cave, Number),
  Number > 0,
  Number1 is Number - 1,
  large_cave(NewCave, Number1).

% TODO
object(Piece) :-
  mountain(Piece);
  small_cave(Piece, _);
  large_cave(Piece, _).

/* Playable pieces */

first_player(x).
second_player(o).

next_player(x, o).
next_player(o, x).

color_value(o1, o, 1).
color_value(o2, o, 2).
color_value(o3, o, 3).
color_value(o4, o, 4).
color_value(o5, o, 5).
color_value(x1, x, 1).
color_value(x2, x, 2).
color_value(x3, x, 3).
color_value(x4, x, 4).
color_value(x5, x, 5).
color_value('  ', '  ', _).

small_dragon(Player, Piece) :-
  color_value(Piece, Player, 3).

large_dragon(Player, Piece) :-
  color_value(Piece, Player, 5).

initial_amount(8).

:- op(600, xfy, on).
:- op(500, xfx, is_of).
Row-Col on Board is_of Player :-
  get_matrix(Board, Row, Col, Piece),
  color_value(Piece, Player, _).