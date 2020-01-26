
------------------ popularność stacji - kacik przemyśleń------------------------------


/* jak definiować popularność stacji?


   1. zdefiniowanie popularności jako różnicy/stosunku między dokami a dostępnymi rowerami
   2. w zależności od kalenadarza - miesiącach jaka trasa

   3. w zależności od pogody - zbadać
   4. w zależności od pory dnia (wykorzystać rozkład pogrupowany po godzinach)


      popularna stacja - taka, ktora najczesciej jest poczatkowa - kolejne podejście - Mateusz

   łączna ilość rowerów w obiegu - dodatkowy

 */


-------------------------------------------------------------------------------------

-- ile razy na daej stacji nie bylo roweru

select station_id, count(*) as il_rek, count(case when avg_bikes_avail = 0 then station_id end) as il_rek_pusta_stacja,
       cast(count(case when avg_bikes_avail = 0 then station_id end) as real)/cast(count(*) as real) as proc_pustych,
       count(case when avg_docks_avail = 0 then station_id end) as il_rek_pelna_stacja,
       cast(count(case when avg_docks_avail = 0 then station_id end) as real)/cast(count(*) as real) as proc_pelnych,
       max(avg_bikes_avail),
       avg(avg_bikes_avail)
from    hourly_status
group by station_id
order by proc_pustych desc;




-- dla kontroli zrobiłem połaczenie z "rozmiarem stacji" - iloscią doków z tabeli "station"


--sprawdzenie czy wystepuja sytuacje kiedy suma dostępnych doków i dostęþnych rowerów nie zgadza się ze sobą w danej godzinie
select count(case
    when stn.dock_count-sts.avg_docks_avail-sts.avg_bikes_avail != 0 then sts.station_id end
    )

from hourly_status sts
join station stn on sts.station_id = stn.id
where stn.id = 2;
-- są takie sutyacje, ale nie ma ich dużo, więc na tym etapie to olewam
-- do dyskusji czy przeprowadzić jakąś drobną analizę czy wystęþują w naszej bazie jakieś inne "anomalie"?

-- na wszelki wypadek dla dalszych analiz "rozmiar stacji" definiuję jako sumę dostępnych rowerów i doków










/*
------------ POPULARNOŚĆ STACJI - podejście 1 --------------------

WZÓR NA POPULARNOŚĆ W UPROSZCZENIU:

"WOLNE DOKI" / "ROZMIAR STACJI"

gdzie "ROZMIAR STACJI" = "WOLNE DOKI" + "DOSTEPNE ROWERY"

gdy na stacji nie ma dostępnych rowerów - ma maksymalną popularność 1.000
gdy na stacji nie ma dostępnych doków i jest zapełniona rowerami - ma minimalną popularność 0.000

 */


-- która stacja jest najbardziej popularna OGÓLNIE

select
       sts.station_id,
       avg(sts.avg_bikes_avail) as avg_dostepne_rowery,
       avg(sts.avg_docks_avail) as avg_dostepne_doki,
       round(avg(sts.avg_docks_avail)/(avg(sts.avg_bikes_avail)+avg(sts.avg_docks_avail)),4) as avg_popularnosc_stacji
from hourly_status sts
group by sts.station_id
order by avg_popularnosc_stacji desc, avg_dostepne_rowery asc;




------------ DZIEN TYGODNIA --------------------



-- w jaki dzien tygodnia jaka stacja jest najbardziej popularna
select
       sts.station_id,
       to_char(sts.time_per_hour,'day') as dzien_tygodnia,
       avg(sts.avg_bikes_avail) as avg_dostepne_rowery,
       avg(sts.avg_docks_avail) as avg_dostepne_doki,
       round(avg(sts.avg_docks_avail)/(avg(sts.avg_bikes_avail)+avg(sts.avg_docks_avail)),4) as avg_popularnosc_stacji
from hourly_status sts
group by dzien_tygodnia, sts.station_id
order by avg_popularnosc_stacji desc, avg_dostepne_rowery asc;



-- 3 najbardziej popularne satcje dla każdego z dni tygodnia - względnie
with dt_rank as (select
       sts.station_id,
       to_char(sts.time_per_hour,'day') as dzien_tygodnia,
       avg(sts.avg_bikes_avail) as avg_dostepne_rowery,
       avg(sts.avg_docks_avail) as avg_dostepne_doki,
       round(avg(sts.avg_docks_avail)/(avg(sts.avg_bikes_avail)+avg(sts.avg_docks_avail)),4) as avg_popularnosc_stacji,
       row_number() over (partition by to_char(sts.time_per_hour, 'day') order by 1 - round(avg(sts.avg_bikes_avail) / (avg(sts.avg_bikes_avail) + avg(sts.avg_docks_avail)), 3) desc)  as rk
from hourly_status sts
group by dzien_tygodnia, sts.station_id
order by dzien_tygodnia asc, rk asc
)
select *
from dt_rank
where dt_rank.rk <= 10;





------------ MIESIAC --------------------




-- w jakim miesiącu dana stacja jest najbardziej popularna
select
       sts.station_id,
       to_char(sts.time_per_hour,'month') as miesiac,
       avg(sts.avg_bikes_avail) as avg_dostepne_rowery,
       avg(sts.avg_docks_avail) as avg_dostepne_doki,
       round(avg(sts.avg_docks_avail)/(avg(sts.avg_bikes_avail)+avg(sts.avg_docks_avail)),4) as avg_popularnosc_stacji
from hourly_status sts
group by miesiac, sts.station_id
order by avg_popularnosc_stacji desc, avg_dostepne_rowery asc;



--  najbardziej popularne stacje dla każdego z miesięcy
with rk_mies as (
    select
           to_char(sts.time_per_hour, 'MM-month') as miesiac,
           sts.station_id,
           avg(sts.avg_bikes_avail)  avg_dostepne_rowery,
           avg(sts.avg_docks_avail)  avg_dostepne_doki,
           round(avg(sts.avg_docks_avail)/(avg(sts.avg_bikes_avail)+avg(sts.avg_docks_avail)),4)  wykorzystanie_stacji,
           row_number() over (partition by to_char(sts.time_per_hour, 'MM-month') order by 1 - round(avg(sts.avg_bikes_avail) / (avg(sts.avg_bikes_avail) + avg(sts.avg_docks_avail)), 3) desc)  as rk
    from hourly_status sts
    group by miesiac, sts.station_id
    order by miesiac asc, rk asc
)
select *
from rk_mies
where rk <= 10;





------------ PORA DNIA --------------------



-- o jakiej godzinie dana stacja jest najbardziej popularna - względnie
select
       sts.station_id,
       date_part('hour', sts.time_per_hour) as godzina,
       avg(sts.avg_bikes_avail) as avg_dostepne_rowery,
       avg(sts.avg_docks_avail) as avg_dostepne_doki,
       round(avg(sts.avg_docks_avail)/(avg(sts.avg_bikes_avail)+avg(sts.avg_docks_avail)),4) as avg_popularnosc_stacji
from hourly_status sts
group by godzina, sts.station_id
order by avg_popularnosc_stacji desc, avg_dostepne_rowery asc;


-- 3 najbardziej popularne stacje dla danej godziny


with rk_godz as (
    select
           date_part('hour', sts.time_per_hour) as godzina,
           sts.station_id,
           avg(sts.avg_bikes_avail)  avg_dostepne_rowery,
           avg(sts.avg_docks_avail)  avg_dostepne_doki,
           round(avg(sts.avg_docks_avail)/(avg(sts.avg_bikes_avail)+avg(sts.avg_docks_avail)),4)  avg_popularnosc_stacji,
           row_number() over (partition by date_part('hour', sts.time_per_hour)  order by 1 - round(avg(sts.avg_bikes_avail) / (avg(sts.avg_bikes_avail) + avg(sts.avg_docks_avail)), 3) desc)  as rk
    from hourly_status sts
    group by godzina, sts.station_id
    order by godzina asc, rk asc
)
select *
from rk_godz
--where rk_godz.rk <= 10;





------------ PORA DNIA --------------------
------------ SREDNIO DLA WSZYSTKICH STACJI ------------


-- o jakiej godzinie dana stacja jest najbardziej popularna - gdzie jest najmniej rowerów
select
       date_part('hour', sts.time_per_hour) as godzina,
       avg(sts.avg_bikes_avail) as avg_dostepne_rowery,
       avg(sts.avg_docks_avail) as avg_dostepne_doki,
       round(avg(sts.avg_docks_avail)/(avg(sts.avg_bikes_avail)+avg(sts.avg_docks_avail)),4) as avg_popularnosc_stacji
from hourly_status sts
group by godzina
order by avg_dostepne_rowery asc;




--  o jakiej godzinie dana stacja jest najbardziej popularna
-- powinno wyjść tak samo jak wyżej bo to średnia dla całości
select
       date_part('hour', sts.time_per_hour) as godzina,
       avg(sts.avg_bikes_avail) as avg_dostepne_rowery,
       avg(sts.avg_docks_avail) as avg_dostepne_doki,
       round(avg(sts.avg_docks_avail)/(avg(sts.avg_bikes_avail)+avg(sts.avg_docks_avail)),4) as avg_popularnosc_stacji
from hourly_status sts
group by godzina
order by avg_popularnosc_stacji desc;




------------ POGODA --------------------

-- w jakie konkretne dni dana stacja jest najbardziej popularna + jaka byla wtedy temperatura


with stacje_rank_day as (
    select
       sts.station_id,
       to_char(sts.time_per_hour, 'YYYY-MM-DD') as data,
       avg(sts.avg_bikes_avail) as avg_dostepne_rowery,
       avg(sts.avg_docks_avail) as avg_dostepne_doki,
       round(avg(sts.avg_docks_avail)/(avg(sts.avg_bikes_avail)+avg(sts.avg_docks_avail)),4) as avg_popularnosc_stacji,
       sn.city as miasto
from hourly_status sts
join station sn on sts.station_id = sn.id
join zip_to_cities ztc on sn.city = ztc.city
group by data, sts.station_id, miasto
order by avg_popularnosc_stacji desc, avg_dostepne_rowery asc
), pogoda as (
    select *,
            to_char(to_date(date, 'MM/DD/YYYY'), 'YYYY-MM-DD') as data_norm
    from weather_norm
    join zip_to_cities z on weather_norm.zip_code = z.zip_code
    order by date
)
select
       stacje_rank_day.station_id,
       stacje_rank_day.data,
       stacje_rank_day.avg_popularnosc_stacji,
       stacje_rank_day.miasto,
       p.mean_temperature_c,
       p.cloud_cover,
       p.events
from stacje_rank_day
left join pogoda p on stacje_rank_day.miasto = p.city and stacje_rank_day.data = p.data_norm
order by 3 desc;


/*
-- datę musiałem normalizować z uwagi na różnice w formatach daty

-- drobne sprawdzenie
select *
from    hourly_status
where to_char(time_per_hour, 'YYYY-MM-DD') ilike '2014-11-10'
and station_id = 10;

 */


-- po 5 najpopularniejszych stacji w przypadku eventów pogodowych + procentowy wpływ eventu pogodowego na zmianę popularności danej stacji
-- poniższe pewnie można napisać prościej, ale kopiowałem wcześniejsze fragmenty kodu



with stacje_rank_p_event as (
with stacje_rank_day as (
    select
       sts.station_id,
       to_char(sts.time_per_hour, 'YYYY-MM-DD') as data,
       avg(sts.avg_bikes_avail) as avg_dostepne_rowery,
       avg(sts.avg_docks_avail) as avg_dostepne_doki,
       round(avg(sts.avg_docks_avail)/(avg(sts.avg_bikes_avail)+avg(sts.avg_docks_avail)),4) as avg_popularnosc_stacji,
       sn.city as miasto
from hourly_status sts
join station sn on sts.station_id = sn.id
join zip_to_cities ztc on sn.city = ztc.city
group by data, sts.station_id, miasto
order by avg_popularnosc_stacji desc, avg_dostepne_rowery asc
), pogoda as (
    select *,
            to_char(to_date(date, 'MM/DD/YYYY'), 'YYYY-MM-DD') as data_norm
    from weather_norm
    join zip_to_cities z on weather_norm.zip_code = z.zip_code
    order by date
)
select
       lower(p.events) event_pogodowy,
       stacje_rank_day.station_id,
       round(avg(stacje_rank_day.avg_popularnosc_stacji),3) as avg_pop_stacji,
       stacje_rank_day.miasto,
       row_number() over (partition by lower(events) order by avg(stacje_rank_day.avg_popularnosc_stacji) desc) as rk
from stacje_rank_day
left join pogoda p on stacje_rank_day.miasto = p.city and stacje_rank_day.data = p.data_norm
group by lower(p.events), stacje_rank_day.station_id, stacje_rank_day.miasto
order by 1, 5 asc
),
stacje_rank_total as (
    select
       sts.station_id,
       round(avg(sts.avg_docks_avail)/(avg(sts.avg_bikes_avail)+avg(sts.avg_docks_avail)),4) as avg_popularnosc_stacji,
       row_number() over (order by round(avg(sts.avg_docks_avail)/(avg(sts.avg_bikes_avail)+avg(sts.avg_docks_avail)),4) desc ) as rk_avg
from hourly_status sts
group by sts.station_id
order by avg_popularnosc_stacji desc
)
select stacje_rank_p_event.event_pogodowy,
       stacje_rank_p_event.station_id,
       stacje_rank_p_event.miasto,
       stacje_rank_p_event.rk,
       stacje_rank_total.rk_avg,
       stacje_rank_p_event.avg_pop_stacji as avg_pop_stacji_event,
       stacje_rank_total.avg_popularnosc_stacji as avg_pop_stacji,
       round((stacje_rank_p_event.avg_pop_stacji-stacje_rank_total.avg_popularnosc_stacji)/stacje_rank_total.avg_popularnosc_stacji*100,2) as proc_wplyw_eventu
from stacje_rank_p_event
left join stacje_rank_total on stacje_rank_p_event.station_id = stacje_rank_total.station_id
where stacje_rank_p_event.rk <=5;








---------------------------------------------------------------------------
---------------------- popularność stacji jako wybór początkowej-----------
---------------------------------------------------------------------------
---- WYKORZYTSAĆ KOD MATEUSZA

select
       start_station_id stacja_pocz_id,
       start_station_name,
       count(*) ilosc,
       round((count(*) / sum(count(*)) over())*100,3) procent
from trip
group by start_station_id, start_station_name
order by 3 desc;




