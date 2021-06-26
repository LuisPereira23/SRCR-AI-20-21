% Queries

% Query 1 - Permitir a Definição de Fases de Vacinação.

% 1.ª fase:
% Destina-se a pessoas com mais de 50 anos com patologias associadas; residentes e profissionais em lares e unidades de cuidados continuados;
% profissionais de saúde; profissionais das forças armadas, forças de segurança e serviços críticos.
% 2.ª fase:
% Nesta fase serão vacinadas 1,8 milhões de pessoas com mais de 65 anos e cerca de 900 mil com patologias associadas e mais de 50 anos.
% 3.ª fase:
% Toda a restante população. Os grupos desta fase serão revistos consoante o ritmo de entrega das vacinas

excepcoesEmprego("Médico").
excepcoesEmprego("Enfermeiro").
excepcoesEmprego("Profissional de saude").
excepcoesEmprego("Profissional de lar").
excepcoesEmprego("Profissional das forças de segurança").
excepcoesEmprego("Profissional das forças armadas").

aceiteNaFase(Id,1) :- utente(Id,_,_,Data,_,_,_,_,Doencas,_),
                    idade(Data,Age), Age >= 50,
                    comprimento(Doencas,Comp), Comp >= 2.

aceiteNaFase(Id,1) :- utente(Id,_,_,_,_,_,_,E,_,_), excepcoesEmprego(E).


aceiteNaFase(Id,2) :- utente(Id,_,_,Data,_,_,_,_,Doencas,_), idade(Data,Age), Age >= 65,
                    nao(aceiteNaFase(Id,1)).

aceiteNaFase(Id,2) :- utente(Id,_,_,Data,_,_,_,_,Doencas,_), idade(Data,Age), Age >= 50,
                            comprimento(Doencas,Comp), Comp > 0,
                    nao(aceiteNaFase(Id,1)).

aceiteNaFase(Id,3) :- utente(Id,_,_,_,_,_,_,_,_,_),
                    nao(aceiteNaFase(Id,1)),
                    nao(aceiteNaFase(Id,2)).

accMin([],X,X).
accMin([X|L],A,Min):- X < A,accMin(L,X,Min).
accMin([X|L],A,Min):- X >= A,accMin(L,A,Min).
min([X|L],A) :- accMin(L,X,A).

faseVacinacao(Id,F) :- utente(Id,_,_,_,_,_,_,_,_,_), (solucoes( Fase,(aceiteNaFase(Id,Fase)),Fases)), min(Fases,F).

pessoasNaFase(F,S) :- (solucoes( Id,(faseVacinacao(Id,F)),S)).

% Query 2 - Identificar Pessoas não Vacinadas.

utenteIdNames([],S,S).
utenteIdNames([H|T],Acc,S) :- utente(H,_,Nome,_,_,_,_,_,_,_), utenteIdNames(T,[Nome|Acc],S).
utenteIdNames([H|T],Acc,S) :- utenteIdNames(T,Acc,S).

naoVacinadosAux([],S,S).
naoVacinadosAux([H|T],Acc,S) :- vacinacao_covid(_,H,_,_,_), naoVacinadosAux(T,Acc,S).
naoVacinadosAux([H|T],Acc,S) :- naoVacinadosAux(T,[H|Acc],S).

naoVacinados(S) :- solucoes(U,(utente(U,_,_,_,_,_,_,_,_,_)),Ids ), naoVacinadosAux(Ids,[],IdsNVac), utenteIdNames(IdsNVac,[],S).

% Query 3 - Identificar Pessoas Vacinadas.

vacinadosAux([],S,S).
vacinadosAux([H|T],Acc,S) :- vacinacao_covid(_,H,_,_,2), vacinadosAux(T,[H|Acc],S).
vacinadosAux([H|T],Acc,S) :- vacinadosAux(T,Acc,S).

vacinados(S) :- solucoes(U,(utente(U,_,_,_,_,_,_,_,_,_)),Ids ), vacinadosAux(Ids,[],IdsNVac), utenteIdNames(IdsNVac,[],S).

% Query 4 - Identificar Pessoas Vacinadas Indevidamente.

todosVacinadosAux([]).
todosVacinadosAux([H|T]) :- vacinacao_covid(_,H,_,_,2), todosVacinadosAux(T).

todosVacinados(F) :- pessoasNaFase(F,Ids), todosVacinadosAux(Ids).

faseAtual(F) :- todosVacinados(1), todosVacinados(2), F is 3 .
faseAtual(F) :- todosVacinados(1), F is 2 .
faseAtual(F) :- nao(todosVacinados(1)), F is 1 .

vacinadoIndevido(Id) :- faseAtual(F), vacinacao_covid(_,Id,_,_,_), faseVacinacao(Id,Fvac), Fvac > F.

vacinadosIndevidosIds(S) :- solucoes(Id, vacinadoIndevido(Id),S).

vacinadosIndevidos(S) :- vacinadosIndevidosIds(Ids), utenteIdNames(Ids,[],S).

% Query 5 - Identificar Pessoas Não Vacinadas e que são Candidatas a Vacinação.

vacinadoCandidato(Id) :- faseAtual(F), faseVacinacao(Id,Fvac), F >= Fvac, nao(vacinacao_covid(_,Id,_,_,2)).

vacinadosCandidatosIds(S) :- (solucoes(Id, vacinadoCandidato(Id),S)).
vacinadosCandidatos(S) :- vacinadosCandidatosIds(Ids), utenteIdNames(Ids,[],S).

% Query 6 - Identificar Pessoas a quem falta a Segunda Toma da Vacina.

vacinadosIncompleteAux([],S,S).
vacinadosIncompleteAux([H|T],Acc,S) :- vacinacao_covid(_,H,_,_,1), nao(vacinacao_covid(_,H,_,_,2)), vacinadosIncompleteAux(T,[H|Acc],S).
vacinadosIncompleteAux([H|T],Acc,S) :- vacinadosIncompleteAux(T,Acc,S).

vacinadosIncompleteIds(S) :- solucoes(U,(utente(U,_,_,_,_,_,_,_,_,_)),Ids ), vacinadosIncompleteAux(Ids,[],S).
vacinadosIncomplete(S) :- vacinadosIncompleteIds(Ids), utenteIdNames(Ids,[],S).


% Funcionalidades extra
%--------------------------------- 

% Centros de saude disponiveis 
listaCentros(S) :- solucoes(C ,centro_saude(_,C,_,_,_), S).

% Staff disponivel em certo centro de saude por Id
listaStaff(Id,S) :- solucoes(Nome ,staff(_,Id,Nome,_), S).

% Utentes de cada Centro
utentesCentro(Id,Centros) :- solucoes(Nome ,utente(_,_,Nome,_,_,_,_,_,_,Id), Centros).

% # Vacinas administradas por cada membro staff
nVacinasStaff(Staff,N) :- solucoes(Staff ,vacinacao_covid(Staff,_,_,_,_), S),comprimento( S,N ). 

% Lista de Utentes 
listaUtentes(S) :- solucoes(Nome ,utente(_,_,Nome,_,_,_,_,_,_,_), S).

% # de Vacinas administradas em cada centro de saude
nVacinasCentro(Id,S) :- solucoes(Staff ,staff(Staff,Id,_,_), N),nVacinasCentroAux(N,0,S). 

nVacinasCentroAux([],Acc,S) :- S is Acc.
nVacinasCentroAux([H|T],Acc,S) :- solucoes(U ,vacinacao_covid(H,U,_,_,_), M),comprimento(M,X),Z is Acc + X,nVacinasCentroAux(T,Z,S). 