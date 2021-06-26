% Predicados Auxiliares.

year(date(Y,M,D),Y).
month(date(Y,M,D),M).
day(date(Y,M,D),D).
yearsBetweenDates(D1,D2,S):- year(D1,Y1), year(D2,Y2),
                                month(D2,M2), month(D1,M1),
                                M2 > M1, S is Y2 - Y1.
yearsBetweenDates(D1,D2,S):- year(D1,Y1), year(D2,Y2),
                                month(D2,M2), month(D1,M1),
                                day(D2,Da2), day(D1,Da1),
                                M2 == M1, Da2 >= Da1, S is Y2 - Y1.
yearsBetweenDates(D1,D2,S):- year(D1,Y1), year(D2,Y2), S is Y2 - Y1-1.

bigDate2Small(date(Y,M,D,_,_,_,_,_,_),date(Y,M,D)). 

actualDate(Date) :-
    get_time(Stamp),
    stamp_date_time(Stamp, DateTime, local),
    bigDate2Small(DateTime,Date).

% Cálculo de Idade de um Utente.
idade(Data_Nasc, Idade) :- actualDate(Date), yearsBetweenDates(Data_Nasc,Date,Idade).

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Extensao do predicado si: Questao, Flag -> {V, F, D}

si(Questao, verdadeiro) :- Questao.
si(Questao, falso) :- -Questao.
si(Questao, desconhecido) :- nao(Questao), nao(-Questao).


%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Extensao do predicado si: Questao1, Tipo, Questao2, Flag -> {V, F, D}
% em que Tipo pode ser:
%	eq - equivalencia
% 	ip - implicacao
%   ou - disjuncao
%   e - conjuncao

si(Q1, eq, Q2, F) :- si(Q1, F1), 
	                   si(Q2, F2), 
	                   equivalencia(F1, F2, F).
si(Q1, ip, Q2, F) :- si(Q1, F1), 
	                     si(Q2, F2), 
	                     implicacao(F1, F2, F).
si(Q1, ou, Q2, F) :- si(Q1, F1), 
	                   si(Q2, F2), 
	                   disjuncao(F1, F2, F).
si(Q1, e, Q2, F) :- si(Q1, F1), 
	                  si(Q2, F2), 
	                  conjuncao(F1, F2, F).					   
				

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Extensao do predicado equivalencia: Tipo, Tipo, Tipo -> {V, F, D}
% Tipo pode ser verdadeiro, falso ou desconhecido

equivalencia(X, X, verdadeiro).
equivalencia(desconhecido, Y, desconhecido).
equivalencia(X, desconhecido, desconhecido).
equivalencia(X, Y, falso) :- X \= Y.


%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Extensao do predicado implicacao: Tipo, Tipo, Tipo -> {V, F, D}
% Tipo pode ser verdadeiro, falso ou desconhecido

implicacao(falso, X, verdadeiro).
implicacao(X, verdadeiro, verdadeiro).
implicacao(verdadeiro, desconhecido, desconhecido). 
implicacao(desconhecido, X, desconhecido) :- X \= verdadeiro.
implicacao(verdadeiro, falso, falso).


%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Extensao do predicado disjuncao: Tipo, Tipo, Tipo -> {V, F, D}
% Tipo pode ser verdadeiro, falso ou desconhecido

disjuncao(verdadeiro, X, verdadeiro).
disjuncao(X, verdadeiro, verdadeiro).
disjuncao(desconhecido, Y, desconhecido) :- Y \= verdadeiro.
disjuncao(Y, desconhecido, desconhecido) :- Y \= verdadeiro.
disjuncao(falso, falso, falso).


%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Extensao do predicado conjuncao: Tipo, Tipo, Tipo -> {V, F, D}
% Tipo pode ser verdadeiro, falso ou desconhecido

conjuncao(verdadeiro, verdadeiro, verdadeiro).
conjuncao(falso, _, falso).
conjuncao(_, falso, falso).
conjuncao(desconhecido, verdadeiro, desconhecido).
conjuncao(verdadeiro, desconhecido, desconhecido).
				
				
%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Extensao do predicado siList: Lista de Questoes, Lista de Respostas -> {V, F, D}
% Determina o tipo de um conjunto de questoes
% O resultado é uma lista de tipos (verdadeiro, falso ou desconhecido)
				
siList([], []).
siList([X|L], [R|S]) :- si(X, R),
                          siList(L, S). 

% Extensao do predicado involucao: Termo -> {V, F}               
involucao(Termo) :- Termo,
                    solucoes(Invariante, -Termo::Invariante, Lista),
                    remove(Termo),
                    teste(Lista).


remove(Termo) :- retract(Termo).
remove(Termo) :- assert(Termo), !, fail.

% Extensão do predicado que permite a Evolução do Conhecimento
evolucao( Termo ) :- solucoes(Invariante, +Termo::Invariante, Lista),
                        insercao(Termo),
                        teste(Lista).


solucoes(X,P,S):- findall(X,P,S).

comprimento( [],0 ).
comprimento( [X|L],N ) :- comprimento( L,N1 ), N is N1+1.

teste([]).
teste([R|Lr]) :- R, teste(Lr).

insercao( Termo ) :- assert( Termo ).
insercao( Termo ) :- retract( Termo ), !, fail.

nao( Questao ) :-
    Questao, !, fail.
nao( Questao ).

