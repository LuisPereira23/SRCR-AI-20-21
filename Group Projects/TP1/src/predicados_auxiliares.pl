% date predicates

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

idade(Data_Nasc, Idade) :- actualDate(Date), yearsBetweenDates(Data_Nasc,Date,Idade).
