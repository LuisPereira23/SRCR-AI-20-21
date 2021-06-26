
%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% SIST. REPR. CONHECIMENTO E RACIOCINIO - TP Individual

% Luis Pereira

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% PROLOG: Declaracoes iniciais


:- set_prolog_flag( discontiguous_warnings,off ).
:- set_prolog_flag( single_var_warnings,off ).
:- set_prolog_flag( unknown,fail ).

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% SICStus PROLOG: definicoes iniciais

:- op( 900,xfy,'::' ).
:- dynamic '-'/1.
:- dynamic(local/4).

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Extenção do predicado local: IdLocal,Latitude, Longitude -> {V,F,D}
local(15840,-9.148518124,38.70980813). %Garagem

local(15841,-9.147044252,38.70801938).
local(15842,-9.146144218,38.70778398).
local(15843,-9.145639847,38.70788744).
local(15844,-9.145988636,38.70816366).
local(15845,-9.151993526,38.70762498).
local(15846,-9.150935625,38.70760718).
local(15847,-9.149935581,38.7076159).
local(15848,-9.147146202,38.7076159).
local(15849,-9.146144218,38.70709969).
local(15850,-9.148353992,38.71039507).
local(15851,-9.146715901,38.70756283).
local(15852,-9.144930015,38.70728106).
local(15853,-9.145853665,38.7075613).