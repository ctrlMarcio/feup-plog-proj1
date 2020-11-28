/** <module> Pieces

Defines all pieces.
*/

/* Inanimate pieces */

empty('  ').
mountain('MM').
possible_move_representation('<>').

% caves
caves_row(5).

left_cave_col(1).
middle_cave_col(5).
right_cave_col(9).

cave('c1', 1, 1).
cave('c0', 0, 1).
cave('A1', 1, 5).
cave('A0', 0, 5).
cave('c1', 1, 9).
cave('c0', 0, 9).

small_cave(Piece, Value) :- cave(Piece, Value, 1).
small_cave(Piece, Value) :- cave(Piece, Value, 9).
large_cave(Piece, Value) :- cave(Piece, Value, 5).

cave(Piece, Value) :-
  small_cave(Piece, Value).
cave(Piece, Value) :-
  large_cave(Piece, Value).

cut_cave(Cave, Col, NewCave) :-
  cave(Cave, Number, Col),
  Number > 0,
  Number1 is Number - 1,
  cave(NewCave, Number1, Col).

% TODO
object(Piece) :-
  mountain(Piece);
  small_cave(Piece, _);
  large_cave(Piece, _).

/* Playable pieces */

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

:- op(800, xfx, is_of).
:- op(700, xfx, on).
Row-Col on Board is_of Player :-
  get_matrix(Board, Row, Col, Piece),
  color_value(Piece, Player, _).