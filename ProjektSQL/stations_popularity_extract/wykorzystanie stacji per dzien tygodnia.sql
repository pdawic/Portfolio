-- 10 najbardziej popularne satcje dla każdego z dni tygodnia - względnie
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

