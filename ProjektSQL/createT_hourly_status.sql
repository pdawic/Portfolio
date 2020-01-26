create table hourly_status as
select station_id,
       avg(bikes_available)::numeric(2) as avg_bikes_avail,
       avg(docks_available)::numeric(2) as avg_docks_avail,
       date_trunc('hour', time::timestamp) as time_per_hour
from status
group by 1,4;
