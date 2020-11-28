/** <module> Demonstration

Temporary file reponsible for the intermediate demonstration in a PLOG class @ FEUP.
*/

:-include('../three_dragons.pl').

%!      show_inetermediate_state is det.
%
%       Defines and writes an intermediate state.      
%       Always true.
show_intermediate_state :-
    write_header,
    inter1_state(GameState),
    player1(Player),
    display_game(GameState).

%!      inter1_state(-GameState:list) is det.
%
%       Defines/builds an intermediate state.      
%       Always true.
%
%       @arg GameState      the game state to build to
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

%!      show_final_state is det.
%
%       Defines and writes a final state.      
%       Always true.
show_final_state :-
    write_header,
    final1_state(GameState),
    write_end_board(GameState, o).

%!      final1_state(-GameState:list) is det.
%
%       Defines/builds a final state.      
%       Always true.
%
%       @arg GameState      the game state to build to
final1_state(GameState) :-
    empty_board(Tmp),
    insert_matrix(o2, Tmp, 4, 9, Tmp1),
    insert_matrix(x2, Tmp1, 6, 4, Tmp2),
    insert_matrix(o2, Tmp2, 6, 6, Tmp3),
    insert_matrix(o3, Tmp3, 7, 1, Tmp4),
    insert_matrix(o2, Tmp4, 8, 2, GameState).