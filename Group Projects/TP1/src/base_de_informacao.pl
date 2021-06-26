%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% PROLOG: Declaracoes iniciais
:- set_prolog_flag( discontiguous_warnings,off ).
:- set_prolog_flag( single_var_warnings,off ).
:- set_prolog_flag( unknown,fail ).

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% PROLOG: definicoes iniciais

:- op( 900,xfy,'::' ).
:- dynamic utente/10.
:- dynamic centro_saude/5.
:- dynamic staff/4.
:- dynamic vacinacao_covid/5.

:- consult('predicados_auxiliares.pl').
:- consult('invariantes.pl').
:- consult('queries.pl').



% utente: #Idutente,Nº Segurança_Social,Nome, Data_Nasc, Email, Telefone, Morada,Profissão, [Doenças_Crónicas],#CentroSaúde

utente(1,2317968,"Luciano Barrela Cardoso",date(1976,07,15),"Luciano@gmail.com",911354828,"Rua 1, casa 1","Profissional de lar",[Diabetes],1).
utente(2,5069310,"Dinis Fazendeiro Dorneles",date(2012,01,25),"Dinis@gmail.com",939988659,"Rua 1, casa 2","Estudante",[],2).
utente(3,8846099,"Ruan Monsanto Sintra",date(1955,09,05),"Ruan@gmail.com",968170412,"Rua 2, casa 1","Profissional de saude",[],3).
utente(4,3630128,"Marisa Cerveira Arouca",date(1978,01,25),"Marisa@gmail.com",910737835,"Rua 2, casa 2","Profissional das forças de segurança",[Asma,Cancro,Obesidade],1).
utente(5,8773696,"Izabel Lobato Gomes",date(1974,08,11),"Izabel@gmail.com",931478407,"Rua 1, casa 3","Veterinaria",[Asma],2).
utente(6,2132578,"Ion Estrada Guterres",date(2001,12,09),"Ion@gmail.com",919971087,"Rua 3, casa 1","Profissional das forças armadas",[],3).
utente(7,2132578,"Jonas Branco Grilo",date(1962,06,07),"Jonas@gmail.com",9128392716,"Rua 4, casa 1","Profissional de saude",[],1).
utente(8,2132578,"Reinaldo Matos Barbalho",date(1960,03,17),"Reinaldo@gmail.com",9327381928,"Rua 5, casa 1","Profissional de saude",[Obesidade,Asma],1).
utente(9,2132578,"Lidiana Soares Regalado",date(1974,04,03),"Lidiana@gmail.com",967382918,"Rua 4, casa 2","Profissional de saude",[],2).
utente(10,2132578,"Adriana Anes Silveira",date(1954,06,22),"Adriana@gmail.com",9194728396,"Rua 3, casa 2","Profissional de saude",[Asma],2).
utente(11,2132578,"Lola Monsanto Bicalho",date(1949,02,14),"Lola@gmail.com",9274829680,"Rua 4, casa 3","Profissional de saude",[],3).
utente(12,332578,"Monique Calho",date(1952,03,24),"Monique@gmail.com",928492019,"Rua 5, casa 2","Cabeleireira",[],3).

% centro_saúde:#Idcentro, Nome, Morada, Telefone, Email

centro_saude(1,"Hospital de Braga","Morada1","213659483","centro1@email.com").
centro_saude(2,"Hospital Geral de Santo António","Morada2","262856728","centro2@email.com").
centro_saude(3,"Hospital de Santa Maria","Morada3","253759368","centro3@email.com").

% staff: #Idstaff,#Idcentro,Nome, email

staff(1,1,"Jonas Branco Grilo","Jonas@email.com").
staff(2,1,"Reinaldo Matos Barbalho","Reinaldo@email.com").
staff(3,2,"Lidiana Soares Regalado","Lidiana@email.com").
staff(4,2,"Adriana Anes Silveira","Adriana@email.com").
staff(5,3,"Ruan Monsanto Sintra","Ruan@gmail.com").
staff(6,3,"Lola Monsanto Bicalho","Lola@email.com").

% vacinação_Covid: #Staff, #utente, Data, Vacina,  Toma

vacinacao_covid(1,1,date(2021,01,20),"Pfizer", 1).
vacinacao_covid(2,1,date(2021,02,14),"Pfizer", 2).
vacinacao_covid(3,2,date(2021,02,25),"Moderna", 1).
vacinacao_covid(6,3,date(2021,01,07),"AstraZeneca", 1).
vacinacao_covid(6,3,date(2021,01,23),"AstraZeneca", 2).
vacinacao_covid(2,4,date(2021,03,23),"Pfizer", 1).
vacinacao_covid(5,6,date(2021,02,27),"Moderna", 1).
vacinacao_covid(5,6,date(2021,03,17),"Moderna", 2).
vacinacao_covid(4,12,date(2021,01,19),"Moderna", 1).