select
       sts.station_id,
       avg(sts.avg_bikes_avail) as avg_dostepne_rowery,
       avg(sts.avg_docks_avail) as avg_dostepne_doki,
       round(avg(sts.avg_docks_avail)/(avg(sts.avg_bikes_avail)+avg(sts.avg_docks_avail)),4) as avg_popularnosc_stacji
from hourly_status sts
group by sts.station_id
order by avg_popularnosc_stacji desc, avg_dostepne_rowery asc;
