# Three Dragons

[![GitHub license](https://img.shields.io/github/license/ctrlMarcio/feup-plog)](https://github.com/ctrlMarcio/feup-plog/blob/master/LICENSE) [![SICStus versino](https://img.shields.io/badge/SICStus-4.6.0-red)](https://sicstus.sics.se/)

Resolution proposal for the first project of the Logic Programming course unit @ FEUP, a game board called [**Three Dragons**](https://boardgamegeek.com/boardgame/306972/three-dragons), based on the works of Scott Allen Czysz.
[Official Board and Rules](https://drive.google.com/drive/folders/1xNoHSM08SChVW2TWtzU8Qje6m7hxrEYh).

- [Three Dragons](#three-dragons)
  - [Who and What](#who-and-what)
  - [Drogon, Rhaegal, and Viserion?](#drogon-rhaegal-and-viserion)
    - [The Game Board](#the-game-board)
    - [Pieces](#pieces)
      - [Dragons](#dragons)
    - [Biography](#biography)
  - [Game State Representation](#game-state-representation)
    - [Board](#board)
    - [Current Player](#current-player)
    - [Representation in Prolog](#representation-in-prolog)
      - [Initial Game Board](#initial-game-board)
      - [Intermediate Game Board Example](#intermediate-game-board-example)
      - [Final Game Board Example](#final-game-board-example)
      - [Piece Representation](#piece-representation)
  - [Visualization of the Game State](#visualization-of-the-game-state)
  - [Documentation](#documentation)
  - [License](#license)

___

## Who and What

- Three Dragons 2 made with ❤ by
  - Leonor Gomes, up201806567 • [GitHub](https://github.com/leonormgomes) • [Sigarra](https://sigarra.up.pt/feup/pt/fest_geral.cursos_list?pv_num_unico=201806567)
  - Márcio Duarte, up201909936 • [GitHub](https://github.com/ctrlMarcio) • [Sigarra](https://sigarra.up.pt/feup/pt/fest_geral.cursos_list?pv_num_unico=201909936)

## Drogon, Rhaegal, and Viserion?

**AKA game description**

Three dragons is a board game heavily inspired by ancient games such as Petteia, Tablut and Hnefatafi with some interesting additions:

1. Pieces have strength and can capture pieces with lower strength
2. There are "dragon caves", which can summon "dragons", more on that below

### The Game Board

<img src="resources/official_board.png" width=500/>

The game is named by the three triangular symbols across the center of the board representing dragon caves. In the four corners there are "mountains" that cannot be occupied by player pieces nor moved across. The same precedent is applied to the dragon caves.

### Pieces

Each player starts with 8 pieces, 5 with strength 2, 2 with strength 3 and 1 with strength 4.

Pieces move like a rook in chess, orthogonally, and any number of squares.

Pieces can be captured in two ways:

- by strength: a piece (1) with higher strength can capture another (2) with lower strength. The piece (1) will after loose a level of strength;
- by custodial: a piece is surrounded on both sides either by 2 enemy pieces or an enemy piece and an obstacle (dragon cave or mountain).

When a capture is made, the losing piece should be removed from the game.

The game ends when one of the players only has one piece left, hence the other player is declared the winner.

#### Dragons

Dragons are regular pieces that can only be spawned whenever its cave is surrounded by all orthogonal sides. Only one dragon can be spawned from each cave. The side caves spawn a dragon with strength 3, while the main cave spawns a strength 5 dragon.

### Biography

- [Initial Game Presentation](https://boardgamegeek.com/thread/2347648/three-dragons-entry-2020-two-player-pnp-design-con)
- [Official Game Rules](https://drive.google.com/drive/folders/1xNoHSM08SChVW2TWtzU8Qje6m7hxrEYh)
- [Official Game Board](https://drive.google.com/drive/folders/1xNoHSM08SChVW2TWtzU8Qje6m7hxrEYh)

## Game State Representation

### Board

The game board is represented through a matrix or, in Prolog, a list of lists.

```prolog
| ?- init_board(X).
X = [['MM',o3,o2,o2,o2,o2,o2,o3,'MM'],['  ','  ','  ','  ',o4,'  ','  ','  ','  '],['  ','  ','  ','  ','  ','  ','  ','  '|...],['  ','  ','  ','  ','  ','  ','  '|...],[cc,'  ','  ','  ','AA','  '|...],['  ','  ','  ','  ','  '|...],['  ','  ','  ','  '|...],['  ','  ','  '|...],['MM',x3|...]] ?
```

### Current Player

The current player is stored in a single atom, and exchanged between plays.

```prolog
% global atom recognition
first_player(x).
second_player(o).

% the next player based on the last one
next_player(x, o).
next_player(o, x).
```

### Representation in Prolog

#### Initial Game Board

The game board's width and height can be updated (defaulting at 9), future proofing the game in case new variants appear:

```prolog
board_width(9).
board_height(9).
```

In order to build a dynamic initial game state, one has to take in consideration the current dimensions of the board itself. Consequently, the building of the board is not simple. Its most high level rule can be seen below:

```prolog
init_board(Board) :-
    % initializes the top half of the board
    second_player(Second),
    init_board_half(Second, Half1),

    % initializes the middle row
    init_middle_row(MiddleRow),
    append(Half1, [MiddleRow], Board1),

    % initializes the bottom half
    first_player(First),
    init_board_half(First, Half2Reversed),
    reverse(Half2Reversed, Half2),

    append(Board1, Half2, Board).
```

#### Intermediate Game Board Example

As stated in the assignment, the intermediate and end game board examples are expected to be hard coded, instead of calculated. (For the sake of fidelity, all the present examples were taken from a real game of Three Dragons played amongst the members of this group).

These operations are performed as such:

```prolog
show_intermediate_state :-
    write_header,
    inter1_state(GameState),
    first_player(Player),
    display_game(GameState, Player).

inter1_state(GameState) :-
    empty_board(Tmp),
    insert_matrix(o2, Tmp, 1, 3, Tmp1),
    insert_matrix(o2, Tmp1, 1, 4, Tmp2),
    insert_matrix(o2, Tmp2, 1, 5, Tmp3),
    insert_matrix(o2, Tmp3, 2, 9, Tmp4),
    insert_matrix(x2, Tmp4, 3, 1, Tmp5),
    insert_matrix(o4, Tmp5, 4, 2, Tmp6),
    insert_matrix(x2, Tmp6, 5, 3, Tmp7),
    insert_matrix(o2, Tmp7, 5, 8, Tmp8),
    insert_matrix(x3, Tmp8, 7, 1, Tmp9),
    insert_matrix(x3, Tmp9, 9, 2, Tmp10),
    insert_matrix(x2, Tmp10, 9, 3, Tmp11),
    insert_matrix(x2, Tmp11, 9, 5, Tmp12),
    insert_matrix(x2, Tmp12, 9, 7, GameState).
```

For this operation to be possible, it was required to implement a rule that would create a board with no more than the static elements, this is, without the playable pieces. This rule's called `empty_board/1` in the example given and runs in the exact same way as the `init_board/1` example stated above, but writing an empty cell in all the correspondent playable pieces.

It was also required to implement a way to insert elements in a list of lists in a friendly approachable way, such rule is stated below (if you want to have a more clear grasp on what's happening, you can take a look at the actual code where it is formally documented: [here](src/util.pl)):

```prolog
insert(Element, [_|T], 1, [Element|T]).
insert(Element, [H1|T1], Position, [H1|T2]) :-
    Position1 is Position - 1,
    insert(Element, T1, Position1, T2).

insert_matrix(Element, [MH|TH], 1, Column, [Res|TH]) :-
    insert(Element, MH, Column, Res).
insert_matrix(Element, [HT|MT], Row, Column, [HT|Res]) :-
    Row > 1,
    Row1 is Row - 1,
    insert_matrix(Element, MT, Row1, Column, Res).
```

The intermediate state example given above produces (and was taken from) this exact game board state:

<img src="resources/inter1.png" width=500/>

#### Final Game Board Example

The operations around the final game board example are exactly the same as the one in the intermediate example.

```prolog
show_final_state :-
    write_header,
    final1_state(GameState),
    write_end_board(GameState, o).

final1_state(GameState) :-
    empty_board(Tmp),
    insert_matrix(o2, Tmp, 4, 9, Tmp1),
    insert_matrix(x2, Tmp1, 6, 4, Tmp2),
    insert_matrix(o2, Tmp2, 6, 6, Tmp3),
    insert_matrix(o3, Tmp3, 7, 1, Tmp4),
    insert_matrix(o2, Tmp4, 8, 2, GameState).
```

Resulting in:

<img src="resources/final1.png" width=500/>

> **Note: remember that the game ends when one of the players has only one piece**

#### Piece Representation

More details on the looks are given below ([Visualization of the Game State](#visualization-of-the-game-state)), and, internally, the pieces' implementation  the most complex of the implementations:

```prolog
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
```

These `color_value` facts work both ways, upon a piece, `o1` for example, one can easily find its owner and value, being them `o` and `1` respectively in this example. If one owns a piece owner and its value, `color_value` can returns its internal representation as well.

## Visualization of the Game State

The visualization of the game state predicate is implemented as follows:

```prolog
write_board(Board, NextPlayer) :-
    write_border,
    write_pieces(Board),
    write_next_player(NextPlayer).
```

Starts by writing the top border of the board (merely underscores), draws the board itself, and ends by giving an indication about the next player. When a game ends, it displays the winner instead of the next player.

The drawing of the board also follows a very intuitive and textbook implementation:

```prolog
write_pieces([]) :- nl.
write_pieces([H|T]) :-
    write('|'), write_array(H), nl,
    write_line,
    write_pieces(T).
```

Writing the pieces of a single row separated by some margin and a `|`. For now, the pieces' representation follows a simple idea: displaying its owner and level, such that `x2` is the representation of a piece owned by the player `x` and with level `2`. The static board elements are:

- **MM** for the mountain
- **cc** for the small caves
- **AA** for the large cave

As is implemented in the code snippet below:

```prolog
empty('  ').
mountain('MM').
small_cave('cc').
large_cave('AA').
```

A line, which is no more than a bunch of hyphens (calculated accordingly to the board width), is displayed dividing the rows.

Below lies the current representation of the initial state of the board:

![Inital state of the board in prolog](resources/game_representation.png)

## Documentation

All the code in this repository is commented with the assistance of PlDoc.

More info on Prolog documentation with PlDoc [right here](https://www.swi-prolog.org/pldoc/doc_for?object=section(%27packages/pldoc.html%27)).

## License

[MIT](https://opensource.org/licenses/MIT)
