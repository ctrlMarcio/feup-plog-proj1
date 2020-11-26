% TODO
ask_menu(Options, AnswerIndex) :-
  repeat,
    nl, write_options(Options, 1),
    write_default_option, nl,
    write_prompt,
    readln Index,
    verify_answer(Options, Index, AnswerIndex), !.

ask_menu_question(Options, AnswerIndex, Question) :-
  repeat,
    nl, write(Question), nl, nl,
    write_options(Options, 1),
    write_default_option, nl,
    write_prompt,
    readln Index,
    verify_answer(Options, Index, AnswerIndex), !.

ask_menu_default_question(Options, AnswerIndex, Default, Question) :-
  repeat,
    nl, write(Question), nl, nl,
    write_options(Options, 1),
    write_default_option(Default), nl,
    write_prompt,
    readln Index,
    verify_answer(Options, Index, AnswerIndex), !.

ask_menu_default_prefix(Options, AnswerIndex, Default, Prefix) :-
  asserta(prefix(Prefix)),
  repeat,
    nl, write_options(Options, 1),
    write_default_option(Default), nl,
    write_prompt,
    readln Index,
    verify_answer(Options, Index, AnswerIndex), !,
    retract(prefix(Prefix)).

ask_menu_question_prefix(Options, AnswerIndex, Question, Prefix) :-
  asserta(prefix(Prefix)),
  repeat,
    nl, write(Prefix), write(Question), nl, nl,
    write_options(Options, 1),
    write_default_option, nl,
    write_prompt,
    readln Index,
    verify_answer(Options, Index, AnswerIndex), !,
    retract(prefix(Prefix)).

%%%% PRIVATE BELOW

:- dynamic(prefix/1).

prefix(' ').

% TODO
write_options([], _).
write_options([H|T], OptNumber) :-
  OptNumber > 0,
  prefix(P), write(P), write(' '),
  write(OptNumber), write('. '), write(H), nl,
  OptNumber1 is OptNumber + 1,
  write_options(T, OptNumber1).

% TODO
write_default_option :-
  prefix(P), write(P),
  write(' 0. No/Cancel'), nl.

write_default_option(Default) :-
  prefix(P), write(P),
  write(' 0. '), write(Default), nl.

write_prompt :-
  prefix(P), write(P),
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