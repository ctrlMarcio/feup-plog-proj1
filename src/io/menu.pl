% TODO
ask_menu(Question, Options, AnswerIndex) :-
  repeat,
    nl, write(Question), nl, nl,
    write_options(Options, 1),
    write_default_option, nl,
    write_prompt,
    read(Index),
    verify_answer(Options, Index, AnswerIndex).

%%%% PRIVATE BELOW

% TODO
write_options([], _).
write_options([H|T], OptNumber) :-
  OptNumber > 0,
  write(' '), write(OptNumber), write('. '), write(H), nl,
  OptNumber1 is OptNumber + 1,
  write_options(T, OptNumber1).

% TODO
write_default_option :-
  write(' 0. No/Cancel'), nl.

write_prompt :-
  write('>> ').

verify_answer(Options, AnswerLiteral, Index) :-
  verify_answer_literal(Options, AnswerLiteral, 1, Index), !.
verify_answer(Options, AnswerIndex, AnswerIndex) :-
  number(AnswerIndex),
  AnswerIndex >= 0,
  length(Options, Length),
  AnswerIndex =< Length, !.
verify_answer(_, _, _) :-
  write('Wrong input.'), nl, fail.

verify_answer_literal([Answer|_], Answer, Index, Index).
verify_answer_literal([_|T], Answer, Index, RealIndex) :-
  Index1 is Index + 1,
  verify_answer_literal(T, Answer, Index1, RealIndex).