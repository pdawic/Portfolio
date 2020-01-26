--dzienne zmiany temperatur w procentach
--San Francisco
--Palo Alto
--Redwood City
--San Jose
--Mountain View

with wsad as
         (
             select distinct ztc.city city,
                             wn.date date,
                             wn.rok rok,
                             wn.miesiac miesiac,
                             wn.dzien dzien,
                             wn.dzien_tygodnia dzien_tygodnia,
                             avg(wn.min_temperature_c) over (partition by wn.dzien)  avg_min_temp_dzien,
                             avg(wn.max_temerature_c) over (partition by wn.dzien)   avg_max_temp_dzien,
                             avg(wn.mean_temperature_c) over (partition by wn.dzien) avg_mean_temp_dzien,
                             avg(wn.min_humidity) over (partition by wn.dzien)  avg_min_humidity_dzien,
                             avg(wn.max_humidity) over (partition by wn.dzien)   avg_max_humidity_dzien,
                             avg(wn.mean_humidity) over (partition by wn.dzien) avg_mean_humidity_dzien,
                             avg(wn.mean_wind_speed_mph) over (partition by wn.dzien)  avg_mean_wind_speed_mph,
                             avg(wn.max_wind_speed_mph) over (partition by wn.dzien)   avg_max_wind_speed_mph
                      from weather_norm wn
                      join zip_to_cities ztc on wn.zip_code = ztc.zip_code
             --where ztc.city = 'Mountain View'
             group by ztc.city,wn.date, wn.rok,  wn.miesiac, wn.dzien, wn.dzien_tygodnia,
                      wn.min_temperature_C, wn.max_temerature_C, wn.mean_temperature_C,
                      wn.min_humidity, wn.max_humidity, wn.mean_humidity,
                      wn.mean_wind_speed_mph,  wn.max_wind_speed_mph
             order by 2, 3
         )
select
       city,
       date,
       rok,
       miesiac,
       dzien,
       dzien_tygodnia,
       avg_min_temp_dzien,
       (((avg_min_temp_dzien - lag(avg_min_temp_dzien) over ())/lag(avg_min_temp_dzien) over ())*100)::numeric(2) DoD_proc_avg_min_temp_dzien,
       avg_max_temp_dzien,
       (((avg_max_temp_dzien - lag(avg_max_temp_dzien) over ())/lag(avg_max_temp_dzien) over ())*100)::numeric(2)  DoD_proc_avg_max_temp_dzien,
       avg_mean_temp_dzien,
       (((avg_mean_temp_dzien - lag(avg_mean_temp_dzien) over ())/lag(avg_mean_temp_dzien) over ())*100)::numeric(2) DoD_proc_avg_mean_temp_dzien,
       avg_min_humidity_dzien,
       (((avg_min_humidity_dzien - lag(avg_min_humidity_dzien) over ())/lag(avg_min_humidity_dzien) over ())*100)::numeric(2) DoD_proc_avg_min_humidity_dzien,
       avg_max_humidity_dzien,
       (((avg_max_humidity_dzien - lag(avg_max_humidity_dzien) over ())/lag(avg_max_humidity_dzien) over ())*100)::numeric(2) DoD_proc_avg_max_humidity_dzien,
       avg_mean_humidity_dzien,
       (((avg_mean_humidity_dzien - lag(avg_mean_humidity_dzien) over ())/lag(avg_mean_humidity_dzien) over ())*100)::numeric(2) DoD_proc_avg_mean_humidity_dzien,
       avg_mean_wind_speed_mph,
       (((avg_mean_wind_speed_mph - lag(avg_mean_wind_speed_mph) over ())/lag(avg_mean_wind_speed_mph) over ())*100)::numeric(2) DoD_proc_avg_mean_wind_speed_mph,
       avg_max_wind_speed_mph,
       (((avg_max_wind_speed_mph - lag(avg_max_wind_speed_mph) over ())/lag(avg_max_wind_speed_mph) over ())*100)::numeric(2) DoD_proc_avg_max_wind_speed_mph



from wsad
group by 1,2,3,4,5,6,7,9,11,13,15,17,19,21
order by 2,3