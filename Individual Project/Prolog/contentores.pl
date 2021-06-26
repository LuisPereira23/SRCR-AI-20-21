
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
:- dynamic(contentor/7).

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Extenção do predicado contentor: IdContentor, IdLocal, Tipo Residuo, Tipo Contentor, Capacidade, QT, Litros  -> {V,F,D}
contentor(463,15841,lixos,cv0240,240,9,2160).
contentor(464,15841,lixos,cv0140,140,5,700).
contentor(465,15841,lixos,cv0240,240,9,2160).
contentor(466,15841,lixos,cv0140,140,5,700).
contentor(467,15842,lixos,cv0090,90,1,90).
contentor(468,15842,lixos,cv0090,90,1,90).
contentor(469,15843,lixos,cv0090,90,1,90).
contentor(470,15843,lixos,cv0140,140,4,560).
contentor(471,15843,lixos,cv0240,240,2,480).
contentor(472,15843,papel_cartao,cv0090,90,1,90).
contentor(473,15843,papel_cartao,cv0140,140,2,280).
contentor(474,15844,lixos,cv0140,140,1,140).
contentor(475,15844,lixos,cv0140,140,1,140).
contentor(476,15845,lixos,cv0120,120,1,120).
contentor(477,15845,lixos,cv0240,240,20,4800).
contentor(478,15846,lixos,cv0240,240,5,1200).
contentor(479,15847,lixos,cv0240,240,18,4320).
contentor(480,15847,lixos,cv0120,120,1,120).

contentor(481,15848,'lixos','cv0240',240,13,3120).
contentor(482,15848,'lixos','cv1100',1100,4,4400).
contentor(483,15848,'lixos','cv0120',120,1,120).
contentor(484,15848,'lixos','cv0090',90,1,90).
contentor(485,15849,'lixos','cv0240',240,4,960).
contentor(486,15850,'lixos','cv0240',240,3,720).
contentor(487,15850,'lixos','cv0240',240,3,720).
contentor(488,15850,'embalagens','cv0240',240,1,240).
contentor(489,15851,'lixos','cv0240',240,1,240).
contentor(490,15851,'lixos','cv0140',140,2,280).
contentor(491,15851,'papel_cartao','cv0140',140,2,280).
contentor(494,15852,'lixos','cv0140',140,1,140).
contentor(495,15852,'lixos','cv0120',120,1,120).
contentor(496,15852,'lixos','cv0090',90,1,90).
contentor(497,15853,'lixos','cv0120',120,1,120).
contentor(498,15853,'lixos','cv0140',140,3,420).
contentor(499,15853,'lixos','cv0090',90,1,90).
contentor(500,15853,'lixos','cv0240',240,2,480).
contentor(501,15853,'papel_cartao','cv0340',340,2,680).
contentor(502,15853,'papel_cartao','cv0090',90,1,90).
contentor(503,15853,'papel_cartao','cv0240',240,3,720).