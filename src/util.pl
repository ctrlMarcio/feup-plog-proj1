fill_list(_, 0, []).
fill_list(Value, Amount, List) :-
    Amount > 0,
    NewAmount is Amount - 1,
    fill_list(Value, NewAmount, Rest),
    List = [Value | Rest].