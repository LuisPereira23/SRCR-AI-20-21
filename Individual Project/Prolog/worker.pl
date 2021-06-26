%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% SIST. REPR. CONHECIMENTO E RACIOCINIO - TP Individual

% Luis Pereira

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% PROLOG: Declaracoes iniciais


:- set_prolog_flag( discontiguous_warnings,off ).
:- set_prolog_flag( single_var_warnings,off ).
:- set_prolog_flag( unknown,fail ).
:- set_prolog_flag(toplevel_print_options,[quoted(true), portrayed(true), max_depth(0)]). 
:- set_prolog_stack(global, limit(12589934592)).

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% PROLOG: definicoes iniciais

:- op( 900,xfy,'::' ).
:- dynamic '-'/1.
:- dynamic(local/5).
:- dynamic(contentor/6).
:- op(  500,  fx, [ +, - ]).
:- op(  300, xfx, [ mod ]).
:- op(  200, xfy, [ ^ ]).


:- include('locais.pl').
:- include('contentores.pl').
:- include('auxiliares.pl').
:- use_module(library(lists)).


%--------------------------------- - - - - - - - - - -  -  -  -  -   -

%distancia entre Locais
distLocais(Id1_local, Id2_local,R):-
local(Id1_local,Lat1,Long1),
local(Id2_local,Lat2,Long2),
distancia(Lat1,Long1,Lat2,Long2,W), R is W.

%% Ver se é adjacente
adjacente(Id1_local, Id2_local,Distancia) :- 
local(Id1_local,Lat1,Long1),
local(Id2_local,Lat2,Long2),
Dif is Id1_local-Id2_local,
Dif >= -2, Dif =< 2,
distLocais(Id1_local, Id2_local,R), Distancia is R.


seletiva(Id_local, Quantidade, Tipo) :-
findall(Quantidade2, contentor(_, Id_local, Tipo, _, _, Quantidade2, _), L),
sumList(L, Quantidade).

indiferenciada(Id_local, Quantidade) :-
findall(Quantidade2, contentor(_, Id_local, _, _, _, Quantidade2, _), L),
sumList(L, Quantidade).

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Implementaçao de resolucao em profundidade
%--------------------------------- - - - - - - - - - -  -  -  -  -   -

% Profundidade Indiferenciada
pp_SolI(Garagem, Ponto, Deposicao, PercursoFinal, Distancia, Quantidade):-
findall((Percurso2,Distancia2,Quantidade2),ppI_Recolha(Garagem,Ponto,Percurso2,Distancia2,Quantidade2),L1),
recolha(L1,(P1,D1,Quantidade)),
findall((Percurso3,Distancia3),
pp_retorno(Ponto,Deposicao,Percurso3,Distancia3),L2),
retorno(L2,(P2,D2)),
findall((Percurso4,Distancia4),
pp_retorno(Deposicao,Garagem,Percurso4,Distancia4),L3),
retorno(L3,(P3,D3)),
append(P1, P2, Percurso),
append(Percurso, P3, PercursoFinal),
Distancia is D1+D2+D3.
	
ppI_Recolha(NodoIni, NodoFim, Percurso, Distancia, Quantidade) :-
ppI_RecolhaAux(NodoIni, NodoFim, [NodoIni], Percurso, 0, Distancia, 0, Quantidade).

ppI_RecolhaAux(NodoFim,NodoFim,_,[],Distancia,Distancia,Quantidade,Quantidade):-Quantidade >= 1.

ppI_RecolhaAux(NodoIni,NodoFim,Hist,[ProxNodo|Percurso], InDist, OutDist, InQuant, OutQuant) :-
adjacente(NodoIni,ProxNodo,Distancia),
indiferenciada(ProxNodo, ProxQuant),
not(member(ProxNodo,Hist)),
NDist is InDist + Distancia,
NQuant is InQuant+ProxQuant,
ppI_RecolhaAux(ProxNodo,NodoFim,[ProxNodo|Hist], Percurso, NDist, OutDist, NQuant, OutQuant).


recolhaTodos([(P,D,Q)],(P,D,Q)).
recolhaTodos([(_,D1,_)|L],(P2,D2,Q2)):-recolhaTodos(L,(P2,D2,Q2)).
recolhaTodos([(P1,D1,Q1)|L],(P1,D1,Q1)):-recolhaTodos(L,(_,D2,_)).

recolha([(P,D,Q)],(P,D,Q)).
recolha([(_,D1,_)|L],(P2,D2,Q2)):-recolha(L,(P2,D2,Q2)),D1 > D2.
recolha([(P1,D1,Q1)|L],(P1,D1,Q1)):-recolha(L,(_,D2,_)),D1 =< D2.

recolhaQuant([(P,D,Q)],(P,D,Q)).
recolhaQuant([(_,_,Q1)|L],(P2,D2,Q2)):-recolhaQuant(L,(P2,D2,Q2)),Q1 < Q2.
recolhaQuant([(P1,D1,Q1)|L],(P1,D1,Q1)):-recolhaQuant(L,(_,_,Q2)),Q1 >= Q2.

pp_retorno(NodoIni, NodoFim, Percurso, Distancia) :-
pp_retornoAux(NodoIni, NodoFim, [NodoIni], Percurso, 0, Distancia).

pp_retornoAux(NodoFim,NodoFim,_,[],Distancia,Distancia).
pp_retornoAux(NodoIni,NodoFim,Hist,[ProxNodo|Percurso], InDist, OutDist) :-
adjacente(NodoIni,ProxNodo,Distancia),
not(member(ProxNodo,Hist)),
NDist is InDist + Distancia,
pp_retornoAux(ProxNodo,NodoFim,[ProxNodo|Hist], Percurso, NDist, OutDist).

retorno([(P,D)],(P,D)).
retorno([(_,D1)|L],(P2,D2)):-retorno(L,(P2,D2)),D1>D2.
retorno([(P1,D1)|L],(P1,D1)):-retorno(L,(_,D2)),D1=<D2.

% Profundidade Selectiva

pp_SolS(Tipo, Garagem, Ponto, Deposicao, PercursoFinal, Distancia, Quantidade):-
findall((Per2,Dist2,Quant2),
ppS_Recolha(Tipo,Garagem,Ponto,Per2,Dist2,Quant2),L1),
recolha(L1,(P1,D1,Quantidade)),
findall((Per3,Dist3),
pp_retorno(Ponto,Deposicao,Per3,Dist3),L2),
retorno(L2,(P2,D2)),
append(P1, P2, Percurso),
findall((Per4,Dist4),
pp_retorno(Deposicao,Garagem,Per4,Dist4),L3),
retorno(L3,(P3,D3)),
append(P1, P2, Percurso),
append(Percurso, P3, PercursoFinal),
Distancia is D1+D2+D3.
	
	
ppS_Recolha(Tipo,NodoIni, NodoFim, Percurso, Distancia, Quantidade) :-
ppS_RecolhaAux(Tipo,NodoIni, NodoFim, [NodoIni], Percurso, 0, Distancia, 0, Quantidade).

ppS_RecolhaAux(_,NodoFim,NodoFim,_,[],Distancia,Distancia,Quantidade,Quantidade):-Quantidade >= 1.
ppS_RecolhaAux(Tipo,NodoIni,NodoFim,Hist,[ProxNodo|Percurso], InDist, OutDist, InQuant, OutQuant) :-
adjacente(NodoIni,ProxNodo,Distancia),
seletiva(ProxNodo, ProxQuant, Tipo),
not(member(ProxNodo,Hist)),
NDist is InDist + Distancia,
NQuant is InQuant + ProxQuant,
ppS_RecolhaAux(Tipo,ProxNodo,NodoFim,[ProxNodo|Hist], Percurso, NDist, OutDist, NQuant, OutQuant).

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Circuito maior numero de pontos de recolha Selectivo
%--------------------------------- - - - - - - - - - -  -  -  -  -   -

pp_MaxS(Tipo, Garagem, Ponto, Deposicao, PercursoFinal, Distancia, Quantidade):-
findall((Per2,Dist2,Quant2),ppS_Recolha(Tipo,Garagem,Ponto,Per2,Dist2,Quant2),L1),
recolha2(L1,(P1,D1,Quantidade)),
findall((Per3,Dist3),pp_retorno(Deposicao,Garagem,Per3,Dist3),L2),
retorno(L2,(P2,D2)),
append(P1, P2, Percurso),
findall((Per4,Dist4),
pp_retorno(Deposicao,Garagem,Per4,Dist4),L3),
retorno(L3,(P3,D3)),
append(P1, P2, Percurso),
append(Percurso, P3, PercursoFinal),
Distancia is D1+D2+D3.

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Circuito maior numero de pontos de recolha Indiferenciado
%--------------------------------- - - - - - - - - - -  -  -  -  -   -

pp_MaxI(Garagem, Ponto, Deposicao, PercursoFinal, Distancia, Quantidade):-
findall((Per2,Dist2,Quant2),ppI_Recolha(Garagem,Ponto,Per2,Dist2,Quant2),L1),
recolha2(L1,(P1,D1,Quantidade)),
findall((Per3,Dist3),pp_retorno(Deposicao,Garagem,Per3,Dist3),L2),
retorno(L2,(P2,D2)),
append(P1, P2, Percurso),
findall((Per4,Dist4),
pp_retorno(Deposicao,Garagem,Per4,Dist4),L3),
retorno(L3,(P3,D3)),
append(P1, P2, Percurso),
append(Percurso, P3, PercursoFinal),
Distancia is D1+D2+D3.

recolha2([(P,D,Q)],(P,D,Q)).
recolha2([(_,D1,_)|L],(P2,D2,Q2)):-recolha2(L,(P2,D2,Q2)),D1 < D2.
recolha2([(P1,D1,Q1)|L],(P1,D1,Q1)):-recolha2(L,(_,D2,_)),D1 >= D2.

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Implementaçao de resolucao em Largura
%--------------------------------- - - - - - - - - - -  -  -  -  -   -

bfs(Garagem, Destino, Deposicao, ListaFinal,CustoFinal) :-
breadthFirst([(Garagem, [])|Xs] - Xs, [], Destino, Caminho),
breadthFirst([(Destino, [])|Xs2] - Xs2, [], Deposicao, Caminho2),
breadthFirst([(Deposicao, [])|Xs3] - Xs3, [], Garagem, Caminho3),
properList(Caminho,Custo,Lista),
properList(Caminho2,Custo2,Lista2),
properList(Caminho3,Custo3,Lista3),
append(Lista,Lista2,CaminhoAux),
append(CaminhoAux,Lista3,ListaFinal),
CustoFinal is Custo+Custo2+Custo3.

breadthFirst(Garagem, Destino, Caminho) :-
    breadthFirst([(Garagem, [])|Xs] - Xs, [], Destino, Caminho).

breadthFirst([(Estado, Vs)|_] - _, _, Destino, Rs) :-
    Estado == Destino, !, inverso(Vs, Rs).

breadthFirst([(Estado, _)|Xs]-Ys, Historico, Destino, Caminho) :-
    membro(Estado, Historico), !,
    breadthFirst(Xs - Ys, Historico, Destino, Caminho).

breadthFirst([(Estado, Vs)|Xs] - Ys, Historico, Destino, Caminho) :-
    setof(((Estado, ProxNodo, Distancia), ProxNodo),
    adjacente(Estado, ProxNodo, Distancia), Ls),
    atualizar(Ls, Vs, [Estado|Historico], Ys-Zs),
    breadthFirst(Xs-Zs, [Estado|Historico], Destino, Caminho).

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Pesquisa Profundidade Indiferenciada Limitada
%--------------------------------- - - - - - - - - - -  -  -  -  -   -

pp_SolIL(Garagem, Ponto, Deposicao, N, PercursoFinal, Distancia, Quantidade):-
findall((Percurso2,Distancia2,Quantidade2),ppI_Recolha(Garagem,Ponto,Percurso2,Distancia2,Quantidade2),L1),
recolhaTodos(L1,(P1,D1,Quantidade)),
findall((Percurso3,Distancia3),
pp_retorno(Ponto,Deposicao,Percurso3,Distancia3),L2),
retorno(L2,(P2,D2)),
append(P1, P2, Percurso),
findall((Per4,Dist4),
pp_retorno(Deposicao,Garagem,Per4,Dist4),L3),
retorno(L3,(P3,D3)),
append(P1, P2, Percurso),
append(Percurso, P3, PercursoFinal),
comprimento(PercursoFinal, Tamanho),
        Tamanho < N,
Distancia is D1+D2+D3.

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Pesquisa Profundidade Seletiva Limitada
%--------------------------------- - - - - - - - - - -  -  -  -  -   -

pp_SolSL(Tipo, Garagem, Ponto, Deposicao, N, PercursoFinal, Distancia, Quantidade):-
findall((Per2,Dist2,Quant2),ppS_Recolha(Tipo,Garagem,Ponto,Per2,Dist2,Quant2),L1),
recolhaTodos(L1,(P1,D1,Quantidade)),
findall((Per3,Dist3),
pp_retorno(Ponto,Deposicao,Per3,Dist3),L2),
retorno(L2,(P2,D2)),
append(P1, P2, Percurso),
findall((Per4,Dist4),
pp_retorno(Deposicao,Garagem,Per4,Dist4),L3),
retorno(L3,(P3,D3)),
append(P1, P2, Percurso),
append(Percurso, P3, PercursoFinal),
comprimento(Percurso, Tamanho),
        Tamanho < N,
Distancia is D1+D2.


%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Pesquisa Gulosa (Greedy)
%--------------------------------- - - - - - - - - - -  -  -  -  -   -

gulosaR(Garagem, Ponto, Deposicao, PercursoFinal,CustoFinal):-
	aGulosa(Garagem,Ponto, Caminho1,Custo1),
	aGulosa(Ponto,Deposicao, Caminho2,Custo2),
	aGulosa(Deposicao,Garagem, Caminho3,Custo3),
	removehead(Caminho2,Caminho2S),
	removehead(Caminho3,Caminho3S),
	append(Caminho1, Caminho2S, PercursoMid),
	append(PercursoMid, Caminho3S, PercursoMid2),
	append(PercursoMid2, [Garagem], PercursoFinal),
	CustoFinal is Custo1+Custo2+Custo3.


aGulosa(Garagem,Deposicao, Caminho,Custo) :-
	distLocais(Garagem,Deposicao ,Estima),
	gulosa([[Garagem]/0/Estima], InvCaminho/Custo/_,Deposicao),
	removehead(InvCaminho,CaminhoInv),
	inverso(CaminhoInv, Caminho).

gulosa(Caminhos, Caminho, Deposicao) :-
	obtem_melhor(Caminhos, Caminho,Deposicao),
	Caminho = [Deposicao|_]/_/_.

gulosa(Caminhos, Deposicao, SolucaoCaminho) :-
	obtem_melhor_g(Caminhos, MelhorCaminho,SolucaoCaminho),
	seleciona(MelhorCaminho, Caminhos, OutrosCaminhos),
	expandeGulosa(MelhorCaminho, ExpCaminhos,SolucaoCaminho),
	append(OutrosCaminhos, ExpCaminhos, NovoCaminhos),
    gulosa(NovoCaminhos, Deposicao, SolucaoCaminho).		


obtem_melhor_g([Caminho], Caminho,SolucaoCaminho) :- !.

obtem_melhor_g([Caminho1/Custo1/Est1,_/Custo2/Est2|Caminhos], MelhorCaminho,SolucaoCaminho) :-
	Est1 =< Est2, !,
	obtem_melhor_g([Caminho1/Custo1/Est1|Caminhos], MelhorCaminho,SolucaoCaminho).
	
obtem_melhor_g([_|Caminhos], MelhorCaminho,SolucaoCaminho) :- 
	obtem_melhor_g(Caminhos, MelhorCaminho,SolucaoCaminho).

expandeGulosa(Caminho, ExpCaminhos,SolucaoCaminho) :-
	findall(NovoCaminho, adjacenteA(Caminho,NovoCaminho,SolucaoCaminho), ExpCaminhos).


%-------------------------------Escolher o percurso mais rápido (usando o critério da distância);------------------------------------------

estrelaR(Garagem, Ponto, Deposicao, PercursoFinal,CustoFinal):-
	estrela(Garagem,Ponto, Caminho1,Custo1),
	estrela(Ponto,Deposicao, Caminho2,Custo2),
	estrela(Deposicao,Garagem, Caminho3,Custo3),
	removehead(Caminho2,Caminho2S),
	removehead(Caminho3,Caminho3S),
	append(Caminho1, Caminho2S, PercursoMid),
	append(PercursoMid, Caminho3S, PercursoFinal),
	CustoFinal is Custo1+Custo2+Custo3.

estrela(Garagem,Deposicao, Caminho,Custo) :-
	distLocais(Garagem,Deposicao ,Estima),
	aestrela([[Garagem]/0/Estima], InvCaminho/Custo/_,Deposicao),
	inverso(InvCaminho, Caminho).

aestrela(Caminhos, Caminho, Deposicao) :-
	obtem_melhor(Caminhos, Caminho,Deposicao),
	Caminho = [Deposicao|_]/_/_.

aestrela(Caminhos, Deposicao, SolucaoCaminho) :-
	obtem_melhor(Caminhos, MelhorCaminho,SolucaoCaminho),
	seleciona(MelhorCaminho, Caminhos, OutrosCaminhos),
	expande_aestrela(MelhorCaminho, ExpCaminhos,SolucaoCaminho),
	append(OutrosCaminhos, ExpCaminhos, NovoCaminhos),
    aestrela(NovoCaminhos, Deposicao, SolucaoCaminho).		


obtem_melhor([Caminho], Caminho,SolucaoCaminho) :- !.

obtem_melhor([Caminho1/Custo1/Est1,_/Custo2/Est2|Caminhos], MelhorCaminho,SolucaoCaminho) :-
	Custo1 + Est1 =< Custo2 + Est2, !,
	obtem_melhor([Caminho1/Custo1/Est1|Caminhos], MelhorCaminho,SolucaoCaminho).
	
obtem_melhor([_|Caminhos], MelhorCaminho,SolucaoCaminho) :- 
	obtem_melhor(Caminhos, MelhorCaminho,SolucaoCaminho).

expande_aestrela(Caminho, ExpCaminhos,SolucaoCaminho) :-
	findall(NovoCaminho, adjacenteA(Caminho,NovoCaminho,SolucaoCaminho), ExpCaminhos).

adjacenteA([Nodo|Caminho]/Custo/_, [ProxNodo,Nodo|Caminho]/NovoCusto/Est, SolucaoCaminho) :-
	adjacente(Nodo, ProxNodo,Distancia),
	\+ member(ProxNodo, Caminho),
	NovoCusto is Custo + Distancia,
	distLocais(Nodo,ProxNodo,Est).


