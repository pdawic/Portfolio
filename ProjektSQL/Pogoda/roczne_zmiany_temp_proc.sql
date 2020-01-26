--roczne zmiany temperatur w procentach
--San Francisco
--Palo Alto
--Redwood City
--San Jose
--Mountain View

with wsad as
         (
             select  distinct ztc.city city,
                              wn.rok rok,
                              avg(wn.min_temperature_c) over (partition by ztc.city,wn.rok) avg_min_temp_rok,
                              avg(wn.max_temerature_c) over (partition by ztc.city,wn.rok)   avg_max_temp_rok,
                              avg(wn.mean_temperature_c) over (partition by ztc.city,wn.rok) avg_mean_temp_rok,
                              avg(wn.min_humidity) over (partition by ztc.city,wn.rok) avg_min_wilgotnosc_rok,
                              avg(wn.max_humidity) over (partition by ztc.city,wn.rok) avg_max_wilgotnosc_rok,
                              avg(wn.mean_humidity) over (partition by ztc.city,wn.rok) avg_mean_wilgotnosc_rok,
                              avg(wn.mean_wind_speed_mph) over (partition by ztc.city,wn.rok) avg_mean_wind_speed_mph_rok,
                              avg(wn.max_wind_speed_mph) over (partition by ztc.city,wn.rok) avg_max_wind_speed_mph_rok,
                              avg(wn.cloud_cover) over (partition by ztc.city,wn.rok) avg_mean_zachmurzenie
             from weather_norm wn
                      join zip_to_cities ztc on wn.zip_code = ztc.zip_code
             group by ztc.city,wn.rok,
                      wn.min_temperature_C, wn.max_temerature_C, wn.mean_temperature_C,
                      wn.min_humidity, wn.max_humidity, wn.mean_humidity,
                      wn.mean_wind_speed_mph,  wn.max_wind_speed_mph, wn.cloud_cover

             order by 2, 3
         )
select
       city,
       rok,
       avg_min_temp_rok,
       (((avg_min_temp_rok - lag(avg_min_temp_rok) over ())/lag(avg_min_temp_rok) over ())*100)::numeric(3) yoy_proc_avg_min_temp_rok,
       avg_max_temp_rok,
       (((avg_max_temp_rok - lag(avg_max_temp_rok) over ())/lag(avg_max_temp_rok) over ())*100)::numeric(3)  yoy_proc_avg_max_temp_rok,
       avg_mean_temp_rok,
       (((avg_mean_temp_rok - lag(avg_mean_temp_rok) over ())/lag(avg_mean_temp_rok) over ())*100)::numeric(3) yoy_proc_avg_mean_temp_rok,
       avg_min_wilgotnosc_rok,
       (((avg_min_wilgotnosc_rok - lag(avg_min_wilgotnosc_rok) over ())/lag(avg_min_wilgotnosc_rok) over ())*100)::numeric(3) yoy_proc_avg_min_wilgotnosc_rok,
       avg_max_wilgotnosc_rok,
       (((avg_max_wilgotnosc_rok - lag(avg_max_wilgotnosc_rok) over ())/lag(avg_max_wilgotnosc_rok) over ())*100)::numeric(3) yoy_proc_avg_max_wilgotnosc_rok,
       avg_mean_wilgotnosc_rok,
       (((avg_mean_wilgotnosc_rok - lag(avg_mean_wilgotnosc_rok) over ())/lag(avg_mean_wilgotnosc_rok) over ())*100)::numeric(3) yoy_proc_avg_mean_wilgotnosc_rok,
       avg_mean_wind_speed_mph_rok,
       (((avg_mean_wind_speed_mph_rok - lag(avg_mean_wind_speed_mph_rok) over ())/lag(avg_mean_wind_speed_mph_rok) over ())*100)::numeric(3) yoy_proc_avg_mean_wind_speed_mph_rok,
       avg_max_wind_speed_mph_rok,
       (((avg_max_wind_speed_mph_rok - lag(avg_max_wind_speed_mph_rok) over ())/lag(avg_max_wind_speed_mph_rok) over ())*100)::numeric(3) yoy_proc_avg_max_wind_speed_mph_rok,
       avg_mean_zachmurzenie,
       (((avg_mean_zachmurzenie - lag(avg_mean_zachmurzenie) over ())/lag(avg_mean_zachmurzenie) over ())*100)::numeric(3) YoY_avg_mean_zachmurzenie
from wsad
where city = 'Mountain View'
group by 1,2,3,5,7,9,11,13,15,17,19
union all
select
       city,
       rok,
       avg_min_temp_rok,
       (((avg_min_temp_rok - lag(avg_min_temp_rok) over ())/lag(avg_min_temp_rok) over ())*100)::numeric(3) yoy_proc_avg_min_temp_rok,
       avg_max_temp_rok,
       (((avg_max_temp_rok - lag(avg_max_temp_rok) over ())/lag(avg_max_temp_rok) over ())*100)::numeric(3)  yoy_proc_avg_max_temp_rok,
       avg_mean_temp_rok,
       (((avg_mean_temp_rok - lag(avg_mean_temp_rok) over ())/lag(avg_mean_temp_rok) over ())*100)::numeric(3) yoy_proc_avg_mean_temp_rok,
       avg_min_wilgotnosc_rok,
       (((avg_min_wilgotnosc_rok - lag(avg_min_wilgotnosc_rok) over ())/lag(avg_min_wilgotnosc_rok) over ())*100)::numeric(3) yoy_proc_avg_min_wilgotnosc_rok,
       avg_max_wilgotnosc_rok,
       (((avg_max_wilgotnosc_rok - lag(avg_max_wilgotnosc_rok) over ())/lag(avg_max_wilgotnosc_rok) over ())*100)::numeric(3) yoy_proc_avg_max_wilgotnosc_rok,
       avg_mean_wilgotnosc_rok,
       (((avg_mean_wilgotnosc_rok - lag(avg_mean_wilgotnosc_rok) over ())/lag(avg_mean_wilgotnosc_rok) over ())*100)::numeric(3) yoy_proc_avg_mean_wilgotnosc_rok,
       avg_mean_wind_speed_mph_rok,
       (((avg_mean_wind_speed_mph_rok - lag(avg_mean_wind_speed_mph_rok) over ())/lag(avg_mean_wind_speed_mph_rok) over ())*100)::numeric(3) yoy_proc_avg_mean_wind_speed_mph_rok,
       avg_max_wind_speed_mph_rok,
       (((avg_max_wind_speed_mph_rok - lag(avg_max_wind_speed_mph_rok) over ())/lag(avg_max_wind_speed_mph_rok) over ())*100)::numeric(3) yoy_proc_avg_max_wind_speed_mph_rok,
       avg_mean_zachmurzenie,
       (((avg_mean_zachmurzenie - lag(avg_mean_zachmurzenie) over ())/lag(avg_mean_zachmurzenie) over ())*100)::numeric(3) YoY_avg_mean_zachmurzenie

from wsad
where city = 'Palo Alto'
group by 1,2,3,5,7,9,11,13,15,17,19
union all
select
       city,
       rok,
       avg_min_temp_rok,
       (((avg_min_temp_rok - lag(avg_min_temp_rok) over ())/lag(avg_min_temp_rok) over ())*100)::numeric(3) yoy_proc_avg_min_temp_rok,
       avg_max_temp_rok,
       (((avg_max_temp_rok - lag(avg_max_temp_rok) over ())/lag(avg_max_temp_rok) over ())*100)::numeric(3)  yoy_proc_avg_max_temp_rok,
       avg_mean_temp_rok,
       (((avg_mean_temp_rok - lag(avg_mean_temp_rok) over ())/lag(avg_mean_temp_rok) over ())*100)::numeric(3) yoy_proc_avg_mean_temp_rok,
       avg_min_wilgotnosc_rok,
       (((avg_min_wilgotnosc_rok - lag(avg_min_wilgotnosc_rok) over ())/lag(avg_min_wilgotnosc_rok) over ())*100)::numeric(3) yoy_proc_avg_min_wilgotnosc_rok,
       avg_max_wilgotnosc_rok,
       (((avg_max_wilgotnosc_rok - lag(avg_max_wilgotnosc_rok) over ())/lag(avg_max_wilgotnosc_rok) over ())*100)::numeric(3) yoy_proc_avg_max_wilgotnosc_rok,
       avg_mean_wilgotnosc_rok,
       (((avg_mean_wilgotnosc_rok - lag(avg_mean_wilgotnosc_rok) over ())/lag(avg_mean_wilgotnosc_rok) over ())*100)::numeric(3) yoy_proc_avg_mean_wilgotnosc_rok,
       avg_mean_wind_speed_mph_rok,
       (((avg_mean_wind_speed_mph_rok - lag(avg_mean_wind_speed_mph_rok) over ())/lag(avg_mean_wind_speed_mph_rok) over ())*100)::numeric(3) yoy_proc_avg_mean_wind_speed_mph_rok,
       avg_max_wind_speed_mph_rok,
       (((avg_max_wind_speed_mph_rok - lag(avg_max_wind_speed_mph_rok) over ())/lag(avg_max_wind_speed_mph_rok) over ())*100)::numeric(3) yoy_proc_avg_max_wind_speed_mph_rok,
       avg_mean_zachmurzenie,
       (((avg_mean_zachmurzenie - lag(avg_mean_zachmurzenie) over ())/lag(avg_mean_zachmurzenie) over ())*100)::numeric(3) YoY_avg_mean_zachmurzenie

from wsad
where city = 'Redwood City'
group by 1,2,3,5,7,9,11,13,15,17,19
union all
select
       city,
       rok,
       avg_min_temp_rok,
       (((avg_min_temp_rok - lag(avg_min_temp_rok) over ())/lag(avg_min_temp_rok) over ())*100)::numeric(3) yoy_proc_avg_min_temp_rok,
       avg_max_temp_rok,
       (((avg_max_temp_rok - lag(avg_max_temp_rok) over ())/lag(avg_max_temp_rok) over ())*100)::numeric(3)  yoy_proc_avg_max_temp_rok,
       avg_mean_temp_rok,
       (((avg_mean_temp_rok - lag(avg_mean_temp_rok) over ())/lag(avg_mean_temp_rok) over ())*100)::numeric(3) yoy_proc_avg_mean_temp_rok,
       avg_min_wilgotnosc_rok,
       (((avg_min_wilgotnosc_rok - lag(avg_min_wilgotnosc_rok) over ())/lag(avg_min_wilgotnosc_rok) over ())*100)::numeric(3) yoy_proc_avg_min_wilgotnosc_rok,
       avg_max_wilgotnosc_rok,
       (((avg_max_wilgotnosc_rok - lag(avg_max_wilgotnosc_rok) over ())/lag(avg_max_wilgotnosc_rok) over ())*100)::numeric(3) yoy_proc_avg_max_wilgotnosc_rok,
       avg_mean_wilgotnosc_rok,
       (((avg_mean_wilgotnosc_rok - lag(avg_mean_wilgotnosc_rok) over ())/lag(avg_mean_wilgotnosc_rok) over ())*100)::numeric(3) yoy_proc_avg_mean_wilgotnosc_rok,
       avg_mean_wind_speed_mph_rok,
       (((avg_mean_wind_speed_mph_rok - lag(avg_mean_wind_speed_mph_rok) over ())/lag(avg_mean_wind_speed_mph_rok) over ())*100)::numeric(3) yoy_proc_avg_mean_wind_speed_mph_rok,
       avg_max_wind_speed_mph_rok,
       (((avg_max_wind_speed_mph_rok - lag(avg_max_wind_speed_mph_rok) over ())/lag(avg_max_wind_speed_mph_rok) over ())*100)::numeric(3) yoy_proc_avg_max_wind_speed_mph_rok,
       avg_mean_zachmurzenie,
       (((avg_mean_zachmurzenie - lag(avg_mean_zachmurzenie) over ())/lag(avg_mean_zachmurzenie) over ())*100)::numeric(3) YoY_avg_mean_zachmurzenie

from wsad
where city = 'San Jose'
group by 1,2,3,5,7,9,11,13,15,17,19
union all
select
       city,
       rok,
       avg_min_temp_rok,
       (((avg_min_temp_rok - lag(avg_min_temp_rok) over ())/lag(avg_min_temp_rok) over ())*100)::numeric(3) yoy_proc_avg_min_temp_rok,
       avg_max_temp_rok,
       (((avg_max_temp_rok - lag(avg_max_temp_rok) over ())/lag(avg_max_temp_rok) over ())*100)::numeric(3)  yoy_proc_avg_max_temp_rok,
       avg_mean_temp_rok,
       (((avg_mean_temp_rok - lag(avg_mean_temp_rok) over ())/lag(avg_mean_temp_rok) over ())*100)::numeric(3) yoy_proc_avg_mean_temp_rok,
       avg_min_wilgotnosc_rok,
       (((avg_min_wilgotnosc_rok - lag(avg_min_wilgotnosc_rok) over ())/lag(avg_min_wilgotnosc_rok) over ())*100)::numeric(3) yoy_proc_avg_min_wilgotnosc_rok,
       avg_max_wilgotnosc_rok,
       (((avg_max_wilgotnosc_rok - lag(avg_max_wilgotnosc_rok) over ())/lag(avg_max_wilgotnosc_rok) over ())*100)::numeric(3) yoy_proc_avg_max_wilgotnosc_rok,
       avg_mean_wilgotnosc_rok,
       (((avg_mean_wilgotnosc_rok - lag(avg_mean_wilgotnosc_rok) over ())/lag(avg_mean_wilgotnosc_rok) over ())*100)::numeric(3) yoy_proc_avg_mean_wilgotnosc_rok,
       avg_mean_wind_speed_mph_rok,
       (((avg_mean_wind_speed_mph_rok - lag(avg_mean_wind_speed_mph_rok) over ())/lag(avg_mean_wind_speed_mph_rok) over ())*100)::numeric(3) yoy_proc_avg_mean_wind_speed_mph_rok,
       avg_max_wind_speed_mph_rok,
       (((avg_max_wind_speed_mph_rok - lag(avg_max_wind_speed_mph_rok) over ())/lag(avg_max_wind_speed_mph_rok) over ())*100)::numeric(3) yoy_proc_avg_max_wind_speed_mph_rok,
       avg_mean_zachmurzenie,
       (((avg_mean_zachmurzenie - lag(avg_mean_zachmurzenie) over ())/lag(avg_mean_zachmurzenie) over ())*100)::numeric(3) YoY_avg_mean_zachmurzenie

from wsad
where city = 'San Francisco'
group by 1,2,3,5,7,9,11,13,15,17,19