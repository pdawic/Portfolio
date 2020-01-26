-- Żeby sprawdzić najlepsze warunki robię najpierw tabelę z rozpisaniem miast, dat,
-- ile przejazdów danego dnia i warunki pogodowe wtedy
-- używając select * można wyeksportować tabelę i wrzucić do Tableau na przykład


WITH trips_per_station AS
     (
         select CONCAT(date_trunc('day', start_date::timestamp),' - ', stacje.city) as main_key,
                date_trunc('day', start_date::timestamp) as day,
                stacje.city as city,
                count(przejazdy.id) as how_many_trips
         from trip przejazdy
                  join station stacje on przejazdy.start_station_id = stacje.id
         group by 2,3
         order by 1
    ),
weather AS
    (
        select CONCAT(date_trunc('day', date::timestamp),' - ', ztc.city) as main_key,
               date_trunc('day', date::timestamp) as day,
               ztc.city,
               AVG(mean_humidity) as humidity,
               AVG(mean_sea_level_pressure_hpa) as pressure,
               AVG(mean_temperature_c) as temp,
               AVG(mean_visibility_km) as visibility,
               AVG(mean_wind_speed_mph) as wind_speed,
               AVG(cloud_cover) as cloud_cover
        from weather_norm wn
        join zip_to_cities ztc on wn.zip_code = ztc.zip_code
        group by 2,3
        order by 1,2
    ),
trips_weather AS
    (
    select rank() over (order by t.how_many_trips desc) as rank,
           t.day as day,
       t.city as city,
       t.how_many_trips as trips_number,
       w.humidity as hume,
       w.pressure as pressure,
       w.temp as temp,
       w.visibility as vis,
       w.wind_speed as wind,
       w.cloud_cover as clouds
from trips_per_station t
join weather w on w.main_key = t.main_key
group by 3,4,2,5,6,7,8,9,10
order by 3,4 desc,1 desc
    )

-- tutaj stwierdziłem, że może warto sprawdzić korelację i się okazuje, że tylko wiatr i chmury
-- mają jakąkolwiek korelację z liczbą przejazdów w mieście danego dnia, ale ta też jest słaba

select corr(trips_weather.trips_number,trips_weather.hume) as corr_hume,
       corr(trips_weather.trips_number,trips_weather.pressure) as corr_pressure,
       corr(trips_weather.trips_number,trips_weather.temp) as corr_temp,
       corr(trips_weather.trips_number,trips_weather.vis) as corr_vis,
       corr(trips_weather.trips_number,trips_weather.wind) as corr_wind,
       corr(trips_weather.trips_number,trips_weather.clouds) as corr_clouds
from trips_weather


-- ale zerknijmy na na przykład wiatr, czy wpływa na ilość przejazdów - okazuje się, że nie

select max(trips_weather.trips_number),
        trips_weather.city,
       trips_weather.wind
from trips_weather
group by 2,3
order by 2,1 desc,2
;

