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
