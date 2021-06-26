% Invariantes Regular
:- op( 900,xfy,'::' ).

% Invariante Estrutural:  nao permitir a insercao de conhecimento repetido
+utente(Id,_,_,_,_,_,_,_,_,_) :: (solucoes( Id,(utente(Id,_,_,_,_,_,_,_,_,_)),S ),
                                comprimento( S,N ), 
				                N == 1).

+centro_saude(Id,_,_,_,_) :: (solucoes( Id,(centro_saude(Id,_,_,_,_)),S ),
                                comprimento( S,N ), 
				                N == 1).

+staff(Id,_,_,_) :: (solucoes( Id,(staff(Id,_,_,_)),S),
                                comprimento( S,N ), 
				                N == 1).

% Invariante Estrutural:  nao permitir a insercao de um utente/staff quando o seu centro de saúde não existe
+utente(_,_,_,_,_,_,_,_,_,C) :: (solucoes( C,(centro_saude(C,_,_,_,_)),S ),
                                comprimento( S,N ), 
				                N == 1).

+staff(_,C,_,_) :: (solucoes( C,(centro_saude(C,_,_,_,_)),S ),
                                comprimento( S,N ), 
				                N == 1).

% Invariante Estrutural:  nao permitir a insercao de uma vacinacao quando o seu utente/staff não existe ou quando a toma da vacina é um número inválido

+vacinacao_covid(St,_,_,_,_) :: (solucoes( St,(staff(St,_,_,_)),S ), comprimento( S,N ),  N == 1).

+vacinacao_covid(_,U,_,_,_) :: (solucoes( U,(utente(U,_,_,_,_,_,_,_,_,_)),S ), comprimento( S,N ),  N == 1).

+vacinacao_covid(_,_,_,_,T) :: (T > 0, T =< 2).

+vacinacao_covid(S,Id,_,_,_) :: (utente(Id,_,_,_,_,_,_,_,_,Centro), staff(S,Centro,_,_)).

+vacinacao_covid(_,Id,_,_,2) :: vacinacao_covid(_,Id,_,_,1).

+vacinacao_covid(_,Id,_,_,1) ::(solucoes( Id,(vacinacao_covid(_,Id,_,_,1)),S ), comprimento(S,N), N =< 1).

+vacinacao_covid(_,Id,_,_,_) :: (solucoes( T,(vacinacao_covid(_,Id,_,_,T)),S ),comprimento( S,N ), N =< 2).



% Nao permitir a remocao de centro enquanto existir staff nele
-centro_saude(Id,_,_,_,_) :: (solucoes( U,(staff(U,Id,_,_)),S ),
                            comprimento(S, 0)
                            ).

% Nao permitir a remocao de centro enquanto existir utentes nele
-centro_saude(Id,_,_,_,_) :: (solucoes( U,(utente(U,_,_,_,_,_,_,_,_,Id)),S ),
                            comprimento(S, 0)
                            ).

% Nao permitir a remocao de utente enquanto existir alguma vacinacao dele
-utente(Id,_,_,_,_,_,_,_,_,_) :: (solucoes( Id,(vacinacao_covid(_,Id,_,_,_)),S ),
                                comprimento(S, 0)
                                  ).

% Nao permitir a remocao de staff enquanto existir alguma vacinacao feita por este
-staff(Id,_,_,_) :: (solucoes( Id,(vacinacao_covid(Id,_,_,_,_)),S ),
                    comprimento(S, 0)
                    ).          

% Nao permitir a remocao da primeira toma da vacinacao de um utente enquanto existir a segunda
-vacinacao_covid(_,Id,_,_,1) :: nao(vacinacao_covid(_,Id,_,_,2)).

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