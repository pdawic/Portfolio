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