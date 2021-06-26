%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% SIST. REPR. CONHECIMENTO E RACIOCINIO - TP Individual

% Luis Pereira

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% PROLOG: Declaracoes iniciais


:- set_prolog_flag( discontiguous_warnings,off ).
:- set_prolog_flag( single_var_warnings,off ).
:- set_prolog_flag( unknown,fail ).
:- set_prolog_flag(toplevel_print_options,[quoted(true), portrayed(true), max_depth(0)]). 


%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% PROLOG: definicoes iniciais

:- op( 900,xfy,'::' ).
:- dynamic '-'/1.
:- dynamic(local/5).
:- dynamic(contentor/6).
:- op(  500,  fx, [ +, - ]).
:- op(  300, xfx, [ mod ]).
:- op(  200, xfy, [ ^ ]).

:- use_module(library(lists)).
:- use_module(library(statistics)).

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Extensao do meta-predicado nao: Questao -> {V,F}

nao( Questao ) :-
    Questao, !, fail.
nao( Questao ).
%---------------------------------  predicados auxiliares ---------

%distancia entre dois pontos
distancia(N1,N2,N3,N4,R):- N is sqrt((N3-N1)^2+(N4-N2)^2),N=R.

membro(X, [X|_]).
membro(X, [_|Xs]):-
	membro(X, Xs).

membros([], _).
membros([X|Xs], Members):-
	membro(X, Members),
	membros(Xs, Members).


inverso(Xs, Ys):-
	inverso(Xs, [], Ys).

inverso([], Xs, Xs).
inverso([X|Xs],Ys, Zs):-
	inverso(Xs, [X|Ys], Zs).

%remove elementos replicados numa lista
remove_duplicates([],[]).

remove_duplicates([H | T], List) :-    
     member(H, T),
     remove_duplicates( T, List).

remove_duplicates([H | T], [H|T1]) :- 
      \+member(H, T),
      remove_duplicates( T, T1).

removehead([_|Tail], Tail).

properList([],0,[]).
properList([(Node,ProxNode,S)|Tail], Result,Lista2):-
properList(Tail,Time,Lista1),
Result is S + Time,
append([ProxNode],Lista1,Lista2).

% Extensão do predicado comprimento : L , R -> {V,R} 
comprimento( S,N ) :-
    length( S,N ).

sumList([], 0).
sumList([H|T], N):-
    sumList(T, X),
    N is X + H.

atualizar([], _, _, X-X).
atualizar([(_,Estado)|Ls], Vs, Historico, Xs-Ys) :-
	membro(Estado, Historico), !,
	atualizar(Ls, Vs, Historico, Xs-Ys).

atualizar([(Move, Estado)|Ls], Vs, Historico, [(Estado,[Move|Vs])|Xs]-Ys):-
	atualizar(Ls, Vs, Historico, Xs-Ys).

seleciona(E, [E|Xs], Xs).
seleciona(E, [X|Xs], [X|Ys]) :- seleciona(E, Xs, Ys).

run_test(Caminho,Distancia):-
  profile(pp_SolI(15840, 15847, 15845, Caminho, Distancia, Quantidade)).

%-------------------------------- - - -- - - -- -   