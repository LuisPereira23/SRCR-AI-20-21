% Invariantes

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

+vacinacao_covid(_,U,_,_,_) :: (solucoes( U,(excecao(utente(U,_,_,_,_,Nr,_,_,_,_))),S ), comprimento( S,N ),  N == 0).

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

% Invariante Estrutural:  nao permitir a insercao de conhecimento contraditório
+(-utente(Id,_,_,_,_,_,_,_,_,_)) :: (solucoes( Id,(utente(Id,_,_,_,_,_,_,_,_,_)),S ),
                                    comprimento( S,N ), 
				                            N == 0).

+(-centro_saude(Id,_,_,_,_)) :: (solucoes( Id,(centro_saude(Id,_,_,_,_)),S ),
                                comprimento( S,N ), 
				                        N == 0).

+(-staff(Id,_,_,_)) :: (solucoes( Id,(staff(Id,_,_,_)),S),
                        comprimento( S,N ), 
				                N == 0).

+(-vacinacao_covid(Staff, Utente, Data, Vacina,  Toma)) :: (solucoes( Id,(vacinacao_covid(Staff, Utente, Data, Vacina,  Toma)),S ),
                      comprimento( S,N ), 
                      N == 0).

% Invariante Estrutural:  nao permitir a insercao de uma negacao que já exista
+(-utente(Id,Seg,Nome,Data,Email,Nr,Mor,Prof,Doencas,Cs)) :: (solucoes( Id,(-utente(Id,Seg,Nome,Data,Email,Nr,Mor,Prof,Doencas,Cs)),S ),
                                                              comprimento( S,N ), 
				                                                      N =< 1).

+(-centro_saude(Id,Nome, Morada, Telefone, Email)) :: (solucoes( Id,(-centro_saude(Id,Nome, Morada, Telefone, Email)),S ),
                                                      comprimento( S,N ), 
                                                      N =< 1).

+(-staff(Id,Centro,Nome, Email)) :: (solucoes( Id,(-staff(Id,Centro,Nome, Email)),S),
                                    comprimento( S,N ), 
                                    N =< 1).

+(-vacinacao_covid(Staff, Utente, Data, Vacina,  Toma)) :: (solucoes( Id,(-vacinacao_covid(Staff, Utente, Data, Vacina,  Toma)),S ),
                                  comprimento( S,N ), 
                                  N =< 1).

% Invariante Estrutural:  nao permitir a alteração de conhecimento interdito
+utente(Id,_,_,_,Email,Nr,Mor,_,_,_) :: (solucoes(Email,((utente(Id,_,_,_,Email,Nr,Mor,_,_,_)), nulo(Email)),S1 ),
                                        comprimento( S1,0),
                                        solucoes(Nr,(utente(Id,_,_,_,Email,Nr,Mor,_,_,_), nulo(Nr)),S2 ),
                                        comprimento( S2,0),
                                        solucoes(Mor,(utente(Id,_,_,_,Email,Nr,Mor,_,_,_), nulo(Mor)),S3),
                                        comprimento( S3,0)).

% Invariante Estrutural:  nao permitir a alteração de conhecimento interdito
+centro_saude(Id,_, Morada, Telefone, Email) :: (solucoes(Email,((centro_saude(Id,_, Morada, Telefone, Email)), nulo(Email)),S1 ),
                                                    comprimento( S1,0),
                                                    solucoes(Nr,(centro_saude(Id,_, Morada, Telefone, Email), nulo(Nr)),S2 ),
                                                    comprimento( S2,0),
                                                    solucoes(Mor,(centro_saude(Id,_, Morada, Telefone, Email), nulo(Mor)),S3),
                                                    comprimento( S3,0)).   

% Invariante Estrutural:  nao permitir a alteração de conhecimento interdito
+staff(Id,_,_,Email) :: (solucoes(Email,((staff(Id,_,_,Email))), nulo(Email)),S1 ),
                        comprimento( S1,0)).        