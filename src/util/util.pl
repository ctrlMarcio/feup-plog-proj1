/** <module> Utilities

Container of predicates of general use.
*/

%!      letter(+N:int, -Letter) is det.
%
%       Gets the Nth letter of the alphabet.
%       True when the amount is non negative and less than 27.
%
%       @arg N          the Nth element of the alphabet
%       @arg Letter     the returning letter
letter(N, Letter) :- nth1(N, [a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p, q, r, s, t, u, v, w, x, y, z], Letter).

%!      fill_list(+Value, +Amount:int, -List:list) is det.
%
%       Fills a list with a given value, a given number of times.
%       True when the amount is non negative.
%
%       @arg Value          the value to fill the list, any type of value
%       @arg Amount         the number of elements to put in the list
%       @arg List           the result list
fill_list(_, 0, []).
fill_list(Value, Amount, List) :-
    Amount > 0,
    NewAmount is Amount - 1,
    fill_list(Value, NewAmount, Rest),
    List = [Value | Rest].

%!      even(+X) is det.
%c
%       Verifies if a number is even.
%       True when the number is even.
%
%       @arg X              the number to verify
even(X) :-
    0 is mod(X, 2).

%!      odd(+X) is det.
%
%       Verifies if a number is odd.
%       True when the number is odd.
%
%       @arg X              the number to verify
odd(X) :-
    1 is mod(X, 2).

%!      insert(+Element, +List:list, +Position:number, -ResList:list) is det.
%
%       Inserts an element in an index of a list.
%       Indexes start at 1.
%       True when the position index is valid and the insertion was valid.
%
%       @arg Element        the element to insert
%       @arg List           the list to insert the element to
%       @arg Position       the index/position where to insert the element. Starts at 1
%       @arg ResList        the resulting list
insert(_, [], _, []).
insert(Element, [_|T], 1, [Element|T]).
insert(Element, [H1|T1], Position, [H1|T2]) :-
    Position > 1,
    Position1 is Position - 1,
    insert(Element, T1, Position1, T2).

%!      insert_matrix(+Element, +Matrix:list, +Row:number, +Column:number, -ResMatrix:list) is det.
%
%       Inserts an element in a matrix given its row and column, replacing the previous one.
%       Indexes start at 1.
%       True when the position index is valid and the insertion was valid.
%
%       @arg Element        the element to insert
%       @arg Matrix         the list of lists (matrix) to insert the element to
%       @arg Row            the row to insert the element. Starts at 1
%       @arg Column         the column to insert the element. Starts at 1
%       @arg ResMatrix      the resulting list of lists (matrix)
insert_matrix(Element, [MH|TH], 1, Column, [Res|TH]) :-
    insert(Element, MH, Column, Res).
insert_matrix(Element, [HT|MT], Row, Column, [HT|Res]) :-
    Row > 1,
    Row1 is Row - 1,
    insert_matrix(Element, MT, Row1, Column, Res).

% TODO
get_matrix([H|_], 1, Column, X) :-
    nth1(Column, H, X).
get_matrix([_|T], Row, Column, X) :-
    Row1 is Row - 1,
    get_matrix(T, Row1, Column, X).

% TODO
insert_multiple_matrix(_, Matrix, [], Matrix).
insert_multiple_matrix(Element, Matrix, [HR-HC|T], ResMatrix) :-
    insert_matrix(Element, Matrix, HR, HC, Matrix1),
    insert_multiple_matrix(Element, Matrix1, T, ResMatrix).
