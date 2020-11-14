/** <module> Utilities

Defines of general use.
*/

:- op(800, xfx, in).

% TODO
Element in List :-
    member(Element, List).

  
:- op(900, fx, get).
:- op(800, xfx, asking).

% TODO
get Answer asking Question :-
  ask_user(Question, Answer).

ask_user(Question, Answer) :-
    write(Question), write(' '),
    read(Answer).

:- op(800, xf, is_even).
X is_even :-
  even(X).

:- op(800, xf, is_odd).
X is_odd :-
  odd(X).