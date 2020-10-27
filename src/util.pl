/** <module> Utilities

Container of predicates of general use.
*/

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
%
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
%       True when the position index is valid and inserts it.
%
%       @arg Element        the element to insert
%       @arg List           the list to insert the element to
%       @arg Position       the index/position where to insert the element. Starts at 1
%       @arg ResList        the resulting list
insert(Element, [_|T], 1, [Element|T]).
insert(Element, [H1|T1], Position, [H1|T2]) :-
    Position1 is Position - 1,
    insert(Element, T1, Position1, T2).