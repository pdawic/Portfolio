/*

Test na przydatność danej zmiennej niezaleznej jaka jest:
1. kategoria glowna
2. podkategoria
3. czas trwania zbiorki w dniach dla kampanii

O ile sie nie myle, to wyliczone information value dla kazdej kategorii/podkategorii/czasu
daje nam podpowiedz co do tego na ile ta zmienna wplynela na sukces/porazke danego projektu.
Odszedłbym od sumowania tych wartosci i obliczenia IV dla calej grupy konkretnej zmiennej, a raczej
(lub byc moze) wykorzystalbym konkretne IV dla oszacowania istotnosci juz konkretnej danej kategorii
wplywajacej na sukces lub porazke danego projektu.

*/

-- Information Value policzone dla kazdej odrebnej kategorii glownej:

with wsad1 as
    (select kf.main_category,
            (count(case when kf.state = 'successful' then kf.id end)+
             count(case when kf.state = 'failed' then kf.id end)+
             count(case when kf.state = 'canceled' then kf.id end)) as total,
            count(case when kf.state = 'successful' then kf.id end) as good,
            count(case when kf.state = 'failed' then kf.id end)+count(case when kf.state = 'canceled' then kf.id end) as bad
    from kickstarter_filtered kf
    group by 1
    )
select t.main_category,
       t.total,
       t.good,
       t.bad,
       round((t.good/sum(t.good) over ())*100,4) as dg,
       round((t.bad/sum(t.bad) over ())*100,4) as db,
       round(ln(t.good/sum(t.good) over ())-ln(t.bad/sum(t.bad) over ()),4) as WOE,
       round((t.good/sum(t.good) over ())*100,4)-round((t.bad/sum(t.bad) over ())*100,4) as diff_dg_db,
       (round((t.good/sum(t.good) over ())*100,4)-round((t.bad/sum(t.bad) over ())*100,4))*(round(ln(t.good/sum(t.good) over ())-ln(t.bad/sum(t.bad) over ()),4)) as information_value
from wsad1 t
group by 1,2,3,4
order by information_value desc


-- Information Value policzone dla kazdej odrebnej podkategorii:

with wsad1 as
    (select kf.category,
            (count(case when kf.state = 'successful' then kf.id end)+
             count(case when kf.state = 'failed' then kf.id end)+
             count(case when kf.state = 'canceled' then kf.id end)) as total,
            count(case when kf.state = 'successful' then kf.id end) as good,
            count(case when kf.state = 'failed' then kf.id end)+count(case when kf.state = 'canceled' then kf.id end) as bad
    from kickstarter_filtered kf
    group by 1
    )
select t.category,
       t.total,
       t.good,
       t.bad,
       round((t.good/sum(t.good) over ())*100,4) as dg,
       round((t.bad/sum(t.bad) over ())*100,4) as db,
       round(ln(t.good/sum(t.good) over ())-ln(t.bad/sum(t.bad) over ()),4) as WOE,
       round((t.good/sum(t.good) over ())*100,4)-round((t.bad/sum(t.bad) over ())*100,4) as diff_dg_db,
       (round((t.good/sum(t.good) over ())*100,4)-round((t.bad/sum(t.bad) over ())*100,4))*(round(ln(t.good/sum(t.good) over ())-ln(t.bad/sum(t.bad) over ()),4)) as information_value
from wsad1 t
group by 1,2,3,4
order by information_value desc


-- Information Value policzone dla czas trwania projektu liczonego w dniach:

with wsad1 as
    (select kf.duration,
            (count(case when kf.state = 'successful' then kf.id end)+
             count(case when kf.state = 'failed' then kf.id end)+
             count(case when kf.state = 'canceled' then kf.id end)) as total,
            count(case when kf.state = 'successful' then kf.id end) as good,
            count(case when kf.state = 'failed' then kf.id end)+count(case when kf.state = 'canceled' then kf.id end) as bad
    from kickstarter_filtered kf
    group by 1
    )
select t.duration,
       t.total,
       t.good,
       t.bad,
       round((t.good/sum(t.good) over ())*100,4) as dg,
       round((t.bad/sum(t.bad) over ())*100,4) as db,
       round(ln(t.good/sum(t.good) over ())-ln(t.bad/sum(t.bad) over ()),4) as WOE,
       round((t.good/sum(t.good) over ())*100,4)-round((t.bad/sum(t.bad) over ())*100,4) as diff_dg_db,
       (round((t.good/sum(t.good) over ())*100,4)-round((t.bad/sum(t.bad) over ())*100,4))*(round(ln(t.good/sum(t.good) over ())-ln(t.bad/sum(t.bad) over ()),4)) as information_value
from wsad1 t
group by 1,2,3,4
order by duration desc, information_value desc

/*
I tak np. duration 31 dni ma wiekszy wplyw na to, czy dany projekt bedzie sukcesem lub porazka.
W przypadku glownych kategrorii najwieksze IV przypada na technologie, zatem wybor tej kategorii
w ramach startera mocniej przylozy sie na to, czy bedzie to sukces czy tez porazka - tak to interpretuje.

W mojej ocenie powinnismy polaczyc to teraz z wyliczonym success rate - wowczas otrzymamy odpowiedz na pytanie
gdzie ocena naszego ratingu bedzie najistotniejsza.
 */