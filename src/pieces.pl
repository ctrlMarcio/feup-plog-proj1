/** <module> Pieces

Defines all pieces.
*/

/* Inanimate pieces */

empty('  ').
mountain('MM').
possible_move_representation('<>').
small_cave('c1', 1).
small_cave('c0', 0).
large_cave('A1', 1).
large_cave('A0', 0).
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

initial_amount(8).
