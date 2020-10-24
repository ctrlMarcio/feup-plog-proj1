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