--miesieczne zmiany temperatur w procentach
--San Francisco
--Palo Alto
--Redwood City
--San Jose
--Mountain View



with wsad as
         (
             select  distinct ztc.city city,
                              wn.rok rok,
                              wn.miesiac miesiac,
                              avg(wn.min_temperature_c) over (partition by ztc.city,wn.rok,wn.miesiac) avg_min_temp_month,
                              avg(wn.max_temerature_c) over (partition by ztc.city,wn.rok,wn.miesiac)   avg_max_temp_month,
                              avg(wn.mean_temperature_c) over (partition by ztc.city,wn.rok,wn.miesiac) avg_mean_temp_month,
                              avg(wn.min_humidity) over (partition by ztc.city,wn.rok,wn.miesiac) avg_min_wilgotnosc_month,
                              avg(wn.max_humidity) over (partition by ztc.city,wn.rok,wn.miesiac) avg_max_wilgotnosc_month,
                              avg(wn.mean_humidity) over (partition by ztc.city,wn.rok,wn.miesiac) avg_mean_wilgotnosc_month,
                              avg(wn.mean_wind_speed_mph) over (partition by ztc.city,wn.rok,wn.miesiac) avg_mean_wind_speed_mph,
                              avg(wn.max_wind_speed_mph) over (partition by ztc.city,wn.rok,wn.miesiac) avg_max_wind_speed_mph,
                              avg(wn.cloud_cover) over (partition by ztc.city,wn.rok,wn.miesiac) avg_mean_zachmurzenie
             from weather_norm wn
                      join zip_to_cities ztc on wn.zip_code = ztc.zip_code
             group by ztc.city,wn.rok, wn.miesiac,
                      wn.min_temperature_C, wn.max_temerature_C, wn.mean_temperature_C,
                      wn.min_humidity, wn.max_humidity, wn.mean_humidity,
                      wn.mean_wind_speed_mph,  wn.max_wind_speed_mph, wn.cloud_cover

             order by 2, 3
         )
select
       city,
       rok,
       miesiac,
       avg_min_temp_month,
       (((avg_min_temp_month - lag(avg_min_temp_month) over ())/lag(avg_min_temp_month) over ())*100)::numeric(3) MoM_proc_avg_min_temp_month,
       avg_max_temp_month,
       (((avg_max_temp_month - lag(avg_max_temp_month) over ())/lag(avg_max_temp_month) over ())*100)::numeric(3)  MoM_proc_avg_max_temp_month,
       avg_mean_temp_month,
       (((avg_mean_temp_month - lag(avg_mean_temp_month) over ())/lag(avg_mean_temp_month) over ())*100)::numeric(3) MoM_proc_avg_mean_temp_month,
       avg_min_wilgotnosc_month,
       (((avg_min_wilgotnosc_month - lag(avg_min_wilgotnosc_month) over ())/lag(avg_min_wilgotnosc_month) over ())*100)::numeric(3) MoM_proc_avg_min_wilgotnos_month,
       avg_max_wilgotnosc_month,
       (((avg_max_wilgotnosc_month - lag(avg_max_wilgotnosc_month) over ())/lag(avg_max_wilgotnosc_month) over ())*100)::numeric(3) MoM_proc_avg_max_wilgotnosc_month,
       avg_mean_wilgotnosc_month,
       (((avg_mean_wilgotnosc_month - lag(avg_mean_wilgotnosc_month) over ())/lag(avg_mean_wilgotnosc_month) over ())*100)::numeric(3) MoM_proc_avg_mean_wilgonosc_month,
       avg_mean_wind_speed_mph,
       (((avg_mean_wind_speed_mph - lag(avg_mean_wind_speed_mph) over ())/lag(avg_mean_wind_speed_mph) over ())*100)::numeric(3) MoM_proc_avg_mean_wind_speed_mph,
       avg_max_wind_speed_mph,
       (((avg_max_wind_speed_mph - lag(avg_max_wind_speed_mph) over ())/lag(avg_max_wind_speed_mph) over ())*100)::numeric(3) MoM_proc_avg_max_wind_speed_mph,
       avg_mean_zachmurzenie,
       (((avg_mean_zachmurzenie - lag(avg_mean_zachmurzenie) over ())/lag(avg_mean_zachmurzenie) over ())*100)::numeric(3) MoM_avg_mean_zachmurzenie

from wsad
where wsad.city = 'San Francisco'
group by 1,2,3,4,6,8,10,12,14,16,18,20
union all
select
       city,
       rok,
       miesiac,
       avg_min_temp_month,
       (((avg_min_temp_month - lag(avg_min_temp_month) over ())/lag(avg_min_temp_month) over ())*100)::numeric(3) MoM_proc_avg_min_temp_month,
       avg_max_temp_month,
       (((avg_max_temp_month - lag(avg_max_temp_month) over ())/lag(avg_max_temp_month) over ())*100)::numeric(3)  MoM_proc_avg_max_temp_month,
       avg_mean_temp_month,
       (((avg_mean_temp_month - lag(avg_mean_temp_month) over ())/lag(avg_mean_temp_month) over ())*100)::numeric(3) MoM_proc_avg_mean_temp_month,
       avg_min_wilgotnosc_month,
       (((avg_min_wilgotnosc_month - lag(avg_min_wilgotnosc_month) over ())/lag(avg_min_wilgotnosc_month) over ())*100)::numeric(3) MoM_proc_avg_min_wilgotnos_month,
       avg_max_wilgotnosc_month,
       (((avg_max_wilgotnosc_month - lag(avg_max_wilgotnosc_month) over ())/lag(avg_max_wilgotnosc_month) over ())*100)::numeric(3) MoM_proc_avg_max_wilgotnosc_month,
       avg_mean_wilgotnosc_month,
       (((avg_mean_wilgotnosc_month - lag(avg_mean_wilgotnosc_month) over ())/lag(avg_mean_wilgotnosc_month) over ())*100)::numeric(3) MoM_proc_avg_mean_wilgonosc_month,
       avg_mean_wind_speed_mph,
       (((avg_mean_wind_speed_mph - lag(avg_mean_wind_speed_mph) over ())/lag(avg_mean_wind_speed_mph) over ())*100)::numeric(3) MoM_proc_avg_mean_wind_speed_mph,
       avg_max_wind_speed_mph,
       (((avg_max_wind_speed_mph - lag(avg_max_wind_speed_mph) over ())/lag(avg_max_wind_speed_mph) over ())*100)::numeric(3) MoM_proc_avg_max_wind_speed_mph,
       avg_mean_zachmurzenie,
       (((avg_mean_zachmurzenie - lag(avg_mean_zachmurzenie) over ())/lag(avg_mean_zachmurzenie) over ())*100)::numeric(3) MoM_avg_mean_zachmurzenie

from wsad
where wsad.city = 'Mountain View'
group by 1,2,3,4,6,8,10,12,14,16,18,20
union all
select
       city,
       rok,
       miesiac,
       avg_min_temp_month,
       (((avg_min_temp_month - lag(avg_min_temp_month) over ())/lag(avg_min_temp_month) over ())*100)::numeric(3) MoM_proc_avg_min_temp_month,
       avg_max_temp_month,
       (((avg_max_temp_month - lag(avg_max_temp_month) over ())/lag(avg_max_temp_month) over ())*100)::numeric(3)  MoM_proc_avg_max_temp_month,
       avg_mean_temp_month,
       (((avg_mean_temp_month - lag(avg_mean_temp_month) over ())/lag(avg_mean_temp_month) over ())*100)::numeric(3) MoM_proc_avg_mean_temp_month,
       avg_min_wilgotnosc_month,
       (((avg_min_wilgotnosc_month - lag(avg_min_wilgotnosc_month) over ())/lag(avg_min_wilgotnosc_month) over ())*100)::numeric(3) MoM_proc_avg_min_wilgotnos_month,
       avg_max_wilgotnosc_month,
       (((avg_max_wilgotnosc_month - lag(avg_max_wilgotnosc_month) over ())/lag(avg_max_wilgotnosc_month) over ())*100)::numeric(3) MoM_proc_avg_max_wilgotnosc_month,
       avg_mean_wilgotnosc_month,
       (((avg_mean_wilgotnosc_month - lag(avg_mean_wilgotnosc_month) over ())/lag(avg_mean_wilgotnosc_month) over ())*100)::numeric(3) MoM_proc_avg_mean_wilgonosc_month,
       avg_mean_wind_speed_mph,
       (((avg_mean_wind_speed_mph - lag(avg_mean_wind_speed_mph) over ())/lag(avg_mean_wind_speed_mph) over ())*100)::numeric(3) MoM_proc_avg_mean_wind_speed_mph,
       avg_max_wind_speed_mph,
       (((avg_max_wind_speed_mph - lag(avg_max_wind_speed_mph) over ())/lag(avg_max_wind_speed_mph) over ())*100)::numeric(3) MoM_proc_avg_max_wind_speed_mph,
       avg_mean_zachmurzenie,
       (((avg_mean_zachmurzenie - lag(avg_mean_zachmurzenie) over ())/lag(avg_mean_zachmurzenie) over ())*100)::numeric(3) MoM_avg_mean_zachmurzenie

from wsad
where wsad.city = 'Palo Alto'
group by 1,2,3,4,6,8,10,12,14,16,18,20
union all
select
       city,
       rok,
       miesiac,
       avg_min_temp_month,
       (((avg_min_temp_month - lag(avg_min_temp_month) over ())/lag(avg_min_temp_month) over ())*100)::numeric(3) MoM_proc_avg_min_temp_month,
       avg_max_temp_month,
       (((avg_max_temp_month - lag(avg_max_temp_month) over ())/lag(avg_max_temp_month) over ())*100)::numeric(3)  MoM_proc_avg_max_temp_month,
       avg_mean_temp_month,
       (((avg_mean_temp_month - lag(avg_mean_temp_month) over ())/lag(avg_mean_temp_month) over ())*100)::numeric(3) MoM_proc_avg_mean_temp_month,
       avg_min_wilgotnosc_month,
       (((avg_min_wilgotnosc_month - lag(avg_min_wilgotnosc_month) over ())/lag(avg_min_wilgotnosc_month) over ())*100)::numeric(3) MoM_proc_avg_min_wilgotnos_month,
       avg_max_wilgotnosc_month,
       (((avg_max_wilgotnosc_month - lag(avg_max_wilgotnosc_month) over ())/lag(avg_max_wilgotnosc_month) over ())*100)::numeric(3) MoM_proc_avg_max_wilgotnosc_month,
       avg_mean_wilgotnosc_month,
       (((avg_mean_wilgotnosc_month - lag(avg_mean_wilgotnosc_month) over ())/lag(avg_mean_wilgotnosc_month) over ())*100)::numeric(3) MoM_proc_avg_mean_wilgonosc_month,
       avg_mean_wind_speed_mph,
       (((avg_mean_wind_speed_mph - lag(avg_mean_wind_speed_mph) over ())/lag(avg_mean_wind_speed_mph) over ())*100)::numeric(3) MoM_proc_avg_mean_wind_speed_mph,
       avg_max_wind_speed_mph,
       (((avg_max_wind_speed_mph - lag(avg_max_wind_speed_mph) over ())/lag(avg_max_wind_speed_mph) over ())*100)::numeric(3) MoM_proc_avg_max_wind_speed_mph,
       avg_mean_zachmurzenie,
       (((avg_mean_zachmurzenie - lag(avg_mean_zachmurzenie) over ())/lag(avg_mean_zachmurzenie) over ())*100)::numeric(3) MoM_avg_mean_zachmurzenie

from wsad
where wsad.city = 'Redwood City'
group by 1,2,3,4,6,8,10,12,14,16,18,20
union all
select
       city,
       rok,
       miesiac,
       avg_min_temp_month,
       (((avg_min_temp_month - lag(avg_min_temp_month) over ())/lag(avg_min_temp_month) over ())*100)::numeric(3) MoM_proc_avg_min_temp_month,
       avg_max_temp_month,
       (((avg_max_temp_month - lag(avg_max_temp_month) over ())/lag(avg_max_temp_month) over ())*100)::numeric(3)  MoM_proc_avg_max_temp_month,
       avg_mean_temp_month,
       (((avg_mean_temp_month - lag(avg_mean_temp_month) over ())/lag(avg_mean_temp_month) over ())*100)::numeric(3) MoM_proc_avg_mean_temp_month,
       avg_min_wilgotnosc_month,
       (((avg_min_wilgotnosc_month - lag(avg_min_wilgotnosc_month) over ())/lag(avg_min_wilgotnosc_month) over ())*100)::numeric(3) MoM_proc_avg_min_wilgotnos_month,
       avg_max_wilgotnosc_month,
       (((avg_max_wilgotnosc_month - lag(avg_max_wilgotnosc_month) over ())/lag(avg_max_wilgotnosc_month) over ())*100)::numeric(3) MoM_proc_avg_max_wilgotnosc_month,
       avg_mean_wilgotnosc_month,
       (((avg_mean_wilgotnosc_month - lag(avg_mean_wilgotnosc_month) over ())/lag(avg_mean_wilgotnosc_month) over ())*100)::numeric(3) MoM_proc_avg_mean_wilgonosc_month,
       avg_mean_wind_speed_mph,
       (((avg_mean_wind_speed_mph - lag(avg_mean_wind_speed_mph) over ())/lag(avg_mean_wind_speed_mph) over ())*100)::numeric(3) MoM_proc_avg_mean_wind_speed_mph,
       avg_max_wind_speed_mph,
       (((avg_max_wind_speed_mph - lag(avg_max_wind_speed_mph) over ())/lag(avg_max_wind_speed_mph) over ())*100)::numeric(3) MoM_proc_avg_max_wind_speed_mph,
       avg_mean_zachmurzenie,
       (((avg_mean_zachmurzenie - lag(avg_mean_zachmurzenie) over ())/lag(avg_mean_zachmurzenie) over ())*100)::numeric(3) MoM_avg_mean_zachmurzenie

from wsad
where wsad.city = 'San Jose'
group by 1,2,3,4,6,8,10,12,14,16,18,20