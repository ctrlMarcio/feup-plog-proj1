% TODO

ask_menu(Options, AnswerIndex) :-
  repeat,
  ask_options(Options, AnswerIndex), !.

ask_menu_question(Options, AnswerIndex, Question) :-
  repeat,
  write_question(Question),
  ask_options(Options, AnswerIndex), !.

ask_menu_default(Options, AnswerIndex, Default) :-
  repeat,
  ask_options_default(Options, AnswerIndex, Default), !.

ask_menu_default_question(Options, AnswerIndex, Default, Question) :-
  repeat,
  write_question(Question),
  ask_options_default(Options, AnswerIndex, Default), !.

ask_menu_default_prefix(Options, AnswerIndex, Default, Prefix) :-
  asserta(prefix(Prefix)),
  repeat,
    ask_menu_default(Options, AnswerIndex, Default), !,
  retract(prefix(Prefix)).

ask_menu_question_prefix(Options, AnswerIndex, Question, Prefix) :-
  asserta(prefix(Prefix)),
  repeat,
  write_question(Question),
  ask_options(Options, AnswerIndex), !,
  retract(prefix(Prefix)).

%%%% PRIVATE BELOW

:- dynamic(prefix/1).

prefix(' ').

ask_options(Options, AnswerIndex) :-
  nl, write_options(Options, 1), nl,
  write_default_option, nl,
  write_prompt,
  readln Index, !,
  verify_answer(Options, Index, AnswerIndex).

ask_options_default(Options, AnswerIndex, Default) :-
  nl, write_options(Options, 1), nl,
  write_default_option(Default), nl,
  write_prompt,
  readln Index, !,
  verify_answer(Options, Index, AnswerIndex).

write_question(Question) :-
  prefix(P),
  format('~n~a~a~n', [P, Question]), !.

% TODO
write_options([], _).
write_options([H|T], OptNumber) :-
  OptNumber > 0,
  prefix(P),
  format('~a ~d. ', [P, OptNumber]),
  write(H), nl,
  OptNumber1 is OptNumber + 1,
  write_options(T, OptNumber1).

% TODO
write_default_option :-
  prefix(P),
  format('~a 0. No/Cancel~n', [P]).

write_default_option(Default) :-
  prefix(P),
  format('~a 0. ~a~n', [P, Default]).

write_prompt :-
  prefix(P),
  format('~a>> ', [P]).

verify_answer(Options, AnswerLiteral, Index) :-
  verify_answer_literal(Options, AnswerLiteral, 1, Index), !.
verify_answer(Options, AnswerIndex, AnswerIndex) :-
  number(AnswerIndex),
  AnswerIndex >= 0,
  length(Options, Length),
  AnswerIndex =< Length, !.
verify_answer(_, _, _) :-
  prefix(P),
  format('~n~aWrong input.~n', [P]), !, fail.

verify_answer_literal([Answer|_], Answer, Index, Index).
verify_answer_literal([_|T], Answer, Index, RealIndex) :-
  Index1 is Index + 1,
  verify_answer_literal(T, Answer, Index1, RealIndex).