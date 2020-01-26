-------------------------- ANALIZA TRAS --------------------------


---------------------------------------------------------------------------------------


/*
        Wyznaczenie 10 najpopularniejszych tras w badanym okresie (lata 2013,2014,2015)
        Zapytanie pozwala zobaczyc najpopularniejsze trasy w ciagu badanych 3 lat
        popularnosc mierzona iloscia przejechanych odcinkow
*/

select s.city,
       t.start_station_name,
       s.city,
       t.end_station_name,
       count(*)
from trip t
join station s on t.start_station_name = s.name
group by start_station_name,
         s.city, end_station_name,
         s.city
order by count(*) desc
limit 10


---------------------------------------------------------------------------------------


/*
        Popularnosc danej trasy w poszczegolnych latach
        Zapytanie zwraca analize ilosci przejazdow dla kazdej trasy wraz ze zmiana r/r.
        Popularnosc danej trasy mierzona iloscia przejazdow w ciagu roku.
*/

with select1 as
    (
        select date_part('year', to_date(t.start_date, 'MM/DD/YYYY')) as date,
               t.start_station_name start_station,
               t.end_station_name end_station,
               row_number() over (partition by t.start_station_name, t.end_station_name order by date_part('year', to_date(t.start_date, 'MM/DD/YYYY'))) as row_number,
               count(*) as trip_volume
        from trip t
        group by 1, 2, 3
    )
select s1.date,
       s1.start_station,
       s1.end_station,
       s1.trip_volume,
       lag(s1.trip_volume) over (partition by s1.start_station, s1.end_station) as year_previous,
       --max(s1.trip_volume) over (partition by s1.start_station, s1.end_station) as max_count_years,
       round((s1.trip_volume-lag(s1.trip_volume) over ())/lag(s1.trip_volume) over()::numeric, 3) * 100 as percent_change
from select1 s1


---------------------------------------------------------------------------------------


/*
        10 najpopularniejszych tras w poszczegolnych miesiacach dla danego roku
        Rok podany jako warunek w zapytaniu
*/


with wsad as
    (
        select date_part('year', to_date(t.start_date, 'MM/DD/YYYY')) as year,
               to_char(to_date(t.start_date,'MM/DD/YYYY'),'Month') as month,
               t.start_station_name start_station,
               t.end_station_name end_station,
               count(*) as trip_volume
        from trip t
        group by 1,2,3,4
    )
select w.year,
       w.month,
       w.start_station,
       w.end_station,
       w.trip_volume
from wsad w
where w.year = '2015' --do podania rok do analizy
group by 1,2,3,4,5
order by w.trip_volume desc
limit 10

---------------------------------------------------------------------------------------

/*
        10 najpopularniejszych tras w poszczegolnych dniach w danym miesiacu i roku
        W zapytaniu ujeto warunek dotyczacy danego roku
*/


with wsad as
    (
        select date_part('year', to_date(t.start_date, 'MM/DD/YYYY')) as year,
               to_char(to_date(t.start_date,'MM/DD/YYYY'),'Month') as month,
               to_char(to_date(t.start_date,'MM/DD/YYYY'),'Day') as day,
               t.start_station_name start_station,
               t.end_station_name end_station,
               count(*) as trip_volume
        from trip t
        group by 1,2,3,4,5
        order by trip_volume desc
    )
select w.year,
       w.month,
       w.day,
       w.start_station,
       w.end_station,
       w.trip_volume
from wsad w
where w.year = '2014'
group by 1,2,3,4,5,6
order by w.year, w.month, w.trip_volume desc


---------------------------------------------------------------------------------------

/*
        Do dalszych analiz przyjalem pierwsze 3 najpopularniejsze trasy z pierwszego zapytania.
        Do tras uwzglednilem srednia temperature, zachmurzenie oraz wydarzenia pogodowe.

        Zapytanie tworzace tabele ze srednimi odczytami pogodowymi na kazdy dzien roku:
*/


        create table average_weather_day as
        with wsad as
            (select to_date(date, 'MM/DD/YYYY') as date,
                    avg(mean_temperature_f) over (partition by to_date(date, 'MM/DD/YYYY')) as avg_temp,
                    avg(mean_wind_speed_mph) over (partition by to_date(date, 'MM/DD/YYYY')) as avg_wind_spd,
                    avg(mean_humidity) over (partition by to_date(date, 'MM/DD/YYYY')) as avg_humidity,
                    avg(cloud_cover) over (partition by to_date(date, 'MM/DD/YYYY')) as avg_cloud_cov
            from weather)
        select w.date, w.avg_temp, w.avg_wind_spd, w.avg_humidity, w.avg_cloud_cov
        from wsad w
        group by 1,2,3,4,5
        order by 1;


/*
        Ponizsze zapytanie zwraca zmiany popularnosci 5 najczesciej uczeszczanych tras
*/

        select date_part('year', to_date(t.start_date, 'MM/DD/YYYY')) as date,
               t.start_station_name start_station,
               t.end_station_name end_station,
               row_number() over (partition by t.start_station_name, t.end_station_name order by date_part('year', to_date(t.start_date, 'MM/DD/YYYY'))) as row_number,
               count(*) as trip_volume,
               round((count(*)-lag(count(*)) over ())/lag(count(*)) over()::numeric, 3) * 100 as percent_change
        from trip t
        where t.start_station_name = 'San Francisco Caltrain 2 (330 Townsend)' and t.end_station_name = 'Townsend at 7th'
        or
              t.start_station_name = 'Harry Bridges Plaza (Ferry Building)' and t.end_station_name = 'Embarcadero at Sansome'
        or
              t.start_station_name = 'Townsend at 7th' and t.end_station_name = 'San Francisco Caltrain (Townsend at 4th)'
        group by 1, 2, 3



--      Analiza SAN FRANCISCO CALTRAIN 2 (330 TOWNSEND) => TOWNSEND AT 7TH (6205 wynikow)

        -- popularnosc trasy w ujeciu rocznym - zmiany popularnosci na przelomie lat

        select date_part('year', to_date(t.start_date, 'MM/DD/YYYY')) as year,
               t.start_station_name start_station,
               t.end_station_name end_station,
               count(*) as trip_volume,
               lag(count(*)) over (partition by date_part('year', to_date(t.start_date, 'MM/DD/YYYY'))) as year_previous,
               round((count(*)-lag(count(*)) over ())/lag(count(*)) over()::numeric, 3) * 100 as percent_change
        from trip t
        where t.start_station_name = 'San Francisco Caltrain 2 (330 Townsend)' and t.end_station_name = 'Townsend at 7th'
        group by 1,2,3
        order by year asc

        -- popularnosc trasy w ujeciu miesiecznym - zmiany popularnosci na przelomie miesiecy

        select date_part('year', to_date(t.start_date, 'MM/DD/YYYY')) as year,
               date_part('month', to_date(t.start_date, 'MM/DD/YYYY')) as month,
               t.start_station_name start_station,
               t.end_station_name end_station,
               count(*) as trip_volume,
               lag(count(*)) over (partition by date_part('year', to_date(t.start_date, 'MM/DD/YYYY'))) as month_previous,
               round((count(*)-lag(count(*)) over ())/lag(count(*)) over()::numeric, 3) * 100 as percent_change
        from trip t
        where t.start_station_name = 'San Francisco Caltrain 2 (330 Townsend)' and t.end_station_name = 'Townsend at 7th'
        group by 1,2,3,4
        order by year asc, month asc

        -- popularnosc trasy w ujeciu dziennym - zmiany popularnosci na przelomie dni w miesiacu

        select date_part('year', to_date(t.start_date, 'MM/DD/YYYY'))  as year,
               date_part('month', to_date(t.start_date, 'MM/DD/YYYY')) as month,
               date_part('day', to_date(t.start_date, 'MM/DD/YYYY'))   as day,
               t.start_station_name start_station,
               t.end_station_name end_station,
               count(*) as trip_volume,
               lag(count(*)) over (partition by date_part('year', to_date(t.start_date, 'MM/DD/YYYY'))) as day_previous,
               round((count(*)-lag(count(*)) over ())/lag(count(*)) over()::numeric, 3) * 100 as percent_change
        from trip t
        where t.start_station_name = 'San Francisco Caltrain 2 (330 Townsend)'
        and t.end_station_name = 'Townsend at 7th'
        group by 1, 2, 3, 4, 5
        order by year asc, month asc, day asc

        -- popularnosc trasy per wiatr, temperatura, eventy, zachmurzeniek, zmiany dzienne - ogólna analiza d/d

        select date_part('year', to_date(t.start_date, 'MM/DD/YYYY')) as year,
               date_part('month', to_date(t.start_date, 'MM/DD/YYYY')) as month,
               date_part('day', to_date(t.start_date, 'MM/DD/YYYY')) as day,
               t.start_station_name start_station_name,
               t.end_station_name end_station_name,
               s.city city,
               z.zip_code zip_code,
               count(*) as trip_volume_per_day,
               --lag(count(*)) over (partition by date_part('year', to_date(t.start_date, 'MM/DD/YYYY'))) as trip_previous,
               round((count(*)-lag(count(*)) over ())/lag(count(*)) over()::numeric, 3) * 100 as trip_per_change,
               awd.avg_temp avg_temperature,
               --lag(awd.avg_temp) over (partition by date_part('year', to_date(t.start_date, 'MM/DD/YYYY'))) as temp_change,
               round((awd.avg_temp-lag(awd.avg_temp) over ())/lag(awd.avg_temp) over()::numeric, 3) * 100 as temp_per_change,
               awd.avg_wind_spd avg_wind_speed,
               --lag(awd.avg_wind_spd) over (partition by date_part('year', to_date(t.start_date, 'MM/DD/YYYY'))) as wind_change,
               round((awd.avg_wind_spd-lag(awd.avg_wind_spd) over ())/lag(awd.avg_wind_spd) over()::numeric, 3) * 100 as temp_per_change,
               awd.avg_humidity avg_humidity,
               --lag(awd.avg_humidity) over (partition by date_part('year', to_date(t.start_date, 'MM/DD/YYYY'))) as humidity_change,
               round((awd.avg_humidity-lag(awd.avg_humidity) over ())/lag(awd.avg_humidity) over()::numeric, 3) * 100 as temp_per_change,
               awd.avg_cloud_cov avg_cloud_cov
               --lag(awd.avg_cloud_cov) over (partition by date_part('year', to_date(t.start_date, 'MM/DD/YYYY'))) as cloud_change
               --round((awd.avg_cloud_cov-lag(awd.avg_cloud_cov) over ())/lag(awd.avg_cloud_cov) over()::numeric, 3) * 100 as cloud_per_change
        from trip t
        join station s on t.start_station_name = s.name
        join zip_to_cities z on s.city = z.city
        join average_weather_day awd on to_date(t.start_date, 'MM/DD/YYYY') = awd.date
        where t.start_station_name = 'San Francisco Caltrain 2 (330 Townsend)'
        and t.end_station_name = 'Townsend at 7th'
        group by 1,2,3,4,5,6,7,10,12,14,16
        order by year asc, month asc, day asc;



--      Analiza HARRY BRIDGES PLAZA (FERRY BUILDING) => EMBARCADERO AT SANSOME (5863 wynikow)

        -- popularnosc trasy w ujeciu rocznym - zmiany popularnosci na przelomie lat

        select date_part('year', to_date(t.start_date, 'MM/DD/YYYY')) as year,
               t.start_station_name start_station,
               t.end_station_name end_station,
               count(*) as trip_volume,
               lag(count(*)) over (partition by date_part('year', to_date(t.start_date, 'MM/DD/YYYY'))) as year_previous,
               round((count(*)-lag(count(*)) over ())/lag(count(*)) over()::numeric, 3) * 100 as percent_change
        from trip t
        where t.start_station_name = 'Harry Bridges Plaza (Ferry Building)' and t.end_station_name = 'Embarcadero at Sansome'
        group by 1,2,3
        order by year asc

        -- popularnosc trasy w ujeciu miesiecznym - zmiany popularnosci na przelomie miesiecy

        select date_part('year', to_date(t.start_date, 'MM/DD/YYYY')) as year,
               date_part('month', to_date(t.start_date, 'MM/DD/YYYY')) as month,
               t.start_station_name start_station,
               t.end_station_name end_station,
               count(*) as trip_volume,
               lag(count(*)) over (partition by date_part('year', to_date(t.start_date, 'MM/DD/YYYY'))) as month_previous,
               round((count(*)-lag(count(*)) over ())/lag(count(*)) over()::numeric, 3) * 100 as percent_change
        from trip t
        where t.start_station_name = 'Harry Bridges Plaza (Ferry Building)' and t.end_station_name = 'Embarcadero at Sansome'
        group by 1,2,3,4
        order by year asc, month asc

        -- popularnosc trasy w ujeciu dziennym - zmiany popularnosci na przelomie dni w miesiacu

        select date_part('year', to_date(t.start_date, 'MM/DD/YYYY'))  as year,
               date_part('month', to_date(t.start_date, 'MM/DD/YYYY')) as month,
               date_part('day', to_date(t.start_date, 'MM/DD/YYYY'))   as day,
               t.start_station_name start_station,
               t.end_station_name end_station,
               count(*) as trip_volume,
               lag(count(*)) over (partition by date_part('year', to_date(t.start_date, 'MM/DD/YYYY'))) as day_previous,
               round((count(*)-lag(count(*)) over ())/lag(count(*)) over()::numeric, 3) * 100 as percent_change
        from trip t
        where t.start_station_name = 'Harry Bridges Plaza (Ferry Building)'
        and t.end_station_name = 'Embarcadero at Sansome'
        group by 1, 2, 3, 4, 5
        order by year asc, month asc, day asc

        -- popularnosc trasy per wiatr, temperatura, eventy, zachmurzeniek, zmiany dzienne - ogólna analiza d/d

        select date_part('year', to_date(t.start_date, 'MM/DD/YYYY')) as year,
               date_part('month', to_date(t.start_date, 'MM/DD/YYYY')) as month,
               date_part('day', to_date(t.start_date, 'MM/DD/YYYY')) as day,
               t.start_station_name start_station_name,
               t.end_station_name end_station_name,
               s.city city,
               z.zip_code zip_code,
               count(*) as trip_volume_per_day,
               --lag(count(*)) over (partition by date_part('year', to_date(t.start_date, 'MM/DD/YYYY'))) as trip_previous,
               round((count(*)-lag(count(*)) over ())/lag(count(*)) over()::numeric, 3) * 100 as trip_per_change,
               awd.avg_temp avg_temperature,
               --lag(awd.avg_temp) over (partition by date_part('year', to_date(t.start_date, 'MM/DD/YYYY'))) as temp_change,
               round((awd.avg_temp-lag(awd.avg_temp) over ())/lag(awd.avg_temp) over()::numeric, 3) * 100 as temp_per_change,
               awd.avg_wind_spd avg_wind_speed,
               --lag(awd.avg_wind_spd) over (partition by date_part('year', to_date(t.start_date, 'MM/DD/YYYY'))) as wind_change,
               round((awd.avg_wind_spd-lag(awd.avg_wind_spd) over ())/lag(awd.avg_wind_spd) over()::numeric, 3) * 100 as temp_per_change,
               awd.avg_humidity avg_humidity,
               --lag(awd.avg_humidity) over (partition by date_part('year', to_date(t.start_date, 'MM/DD/YYYY'))) as humidity_change,
               round((awd.avg_humidity-lag(awd.avg_humidity) over ())/lag(awd.avg_humidity) over()::numeric, 3) * 100 as temp_per_change,
               awd.avg_cloud_cov avg_cloud_cov
               --lag(awd.avg_cloud_cov) over (partition by date_part('year', to_date(t.start_date, 'MM/DD/YYYY'))) as cloud_change
               --round((awd.avg_cloud_cov-lag(awd.avg_cloud_cov) over ())/lag(awd.avg_cloud_cov) over()::numeric, 3) * 100 as cloud_per_change
        from trip t
        join station s on t.start_station_name = s.name
        join zip_to_cities z on s.city = z.city
        join average_weather_day awd on to_date(t.start_date, 'MM/DD/YYYY') = awd.date
        where t.start_station_name = 'Harry Bridges Plaza (Ferry Building)'
        and t.end_station_name = 'Embarcadero at Sansome'
        group by 1,2,3,4,5,6,7,10,12,14,16
        order by year asc, month asc, day asc;



--      Analiza TOWNSEND AT 7TH => SAN FRANCISCO CALTRAIN (TOWNSEND AT 4TH) (5002 wynikow)

        -- popularnosc trasy w ujeciu rocznym - zmiany popularnosci na przelomie lat

        select date_part('year', to_date(t.start_date, 'MM/DD/YYYY')) as year,
               t.start_station_name start_station,
               t.end_station_name end_station,
               count(*) as trip_volume,
               lag(count(*)) over (partition by date_part('year', to_date(t.start_date, 'MM/DD/YYYY'))) as year_previous,
               round((count(*)-lag(count(*)) over ())/lag(count(*)) over()::numeric, 3) * 100 as percent_change
        from trip t
        where t.start_station_name = 'Townsend at 7th' and t.end_station_name = 'San Francisco Caltrain (Townsend at 4th)'
        group by 1,2,3
        order by year asc

        -- popularnosc trasy w ujeciu miesiecznym - zmiany popularnosci na przelomie miesiecy

        select date_part('year', to_date(t.start_date, 'MM/DD/YYYY')) as year,
               date_part('month', to_date(t.start_date, 'MM/DD/YYYY')) as month,
               t.start_station_name start_station,
               t.end_station_name end_station,
               count(*) as trip_volume,
               lag(count(*)) over (partition by date_part('year', to_date(t.start_date, 'MM/DD/YYYY'))) as month_previous,
               round((count(*)-lag(count(*)) over ())/lag(count(*)) over()::numeric, 3) * 100 as percent_change
        from trip t
        where t.start_station_name = 'Townsend at 7th' and t.end_station_name = 'San Francisco Caltrain (Townsend at 4th)'
        group by 1,2,3,4
        order by year asc, month asc

        -- popularnosc trasy w ujeciu dziennym - zmiany popularnosci na przelomie dni w miesiacu

        select date_part('year', to_date(t.start_date, 'MM/DD/YYYY'))  as year,
               date_part('month', to_date(t.start_date, 'MM/DD/YYYY')) as month,
               date_part('day', to_date(t.start_date, 'MM/DD/YYYY'))   as day,
               t.start_station_name start_station,
               t.end_station_name end_station,
               count(*) as trip_volume,
               lag(count(*)) over (partition by date_part('year', to_date(t.start_date, 'MM/DD/YYYY'))) as day_previous,
               round((count(*)-lag(count(*)) over ())/lag(count(*)) over()::numeric, 3) * 100 as percent_change
        from trip t
        where t.start_station_name = 'Townsend at 7th'
        and t.end_station_name = 'San Francisco Caltrain (Townsend at 4th)'
        group by 1, 2, 3, 4, 5
        order by year asc, month asc, day asc

        -- popularnosc trasy per wiatr, temperatura, eventy, zachmurzeniek, zmiany dzienne - ogólna analiza d/d

        select date_part('year', to_date(t.start_date, 'MM/DD/YYYY')) as year,
               date_part('month', to_date(t.start_date, 'MM/DD/YYYY')) as month,
               date_part('day', to_date(t.start_date, 'MM/DD/YYYY')) as day,
               t.start_station_name start_station_name,
               t.end_station_name end_station_name,
               s.city city,
               z.zip_code zip_code,
               count(*) as trip_volume_per_day,
               --lag(count(*)) over (partition by date_part('year', to_date(t.start_date, 'MM/DD/YYYY'))) as trip_previous,
               round((count(*)-lag(count(*)) over ())/lag(count(*)) over()::numeric, 3) * 100 as trip_per_change,
               awd.avg_temp avg_temperature,
               --lag(awd.avg_temp) over (partition by date_part('year', to_date(t.start_date, 'MM/DD/YYYY'))) as temp_change,
               round((awd.avg_temp-lag(awd.avg_temp) over ())/lag(awd.avg_temp) over()::numeric, 3) * 100 as temp_per_change,
               awd.avg_wind_spd avg_wind_speed,
               --lag(awd.avg_wind_spd) over (partition by date_part('year', to_date(t.start_date, 'MM/DD/YYYY'))) as wind_change,
               round((awd.avg_wind_spd-lag(awd.avg_wind_spd) over ())/lag(awd.avg_wind_spd) over()::numeric, 3) * 100 as temp_per_change,
               awd.avg_humidity avg_humidity,
               --lag(awd.avg_humidity) over (partition by date_part('year', to_date(t.start_date, 'MM/DD/YYYY'))) as humidity_change,
               round((awd.avg_humidity-lag(awd.avg_humidity) over ())/lag(awd.avg_humidity) over()::numeric, 3) * 100 as temp_per_change,
               awd.avg_cloud_cov avg_cloud_cov
               --lag(awd.avg_cloud_cov) over (partition by date_part('year', to_date(t.start_date, 'MM/DD/YYYY'))) as cloud_change
               --round((awd.avg_cloud_cov-lag(awd.avg_cloud_cov) over ())/lag(awd.avg_cloud_cov) over()::numeric, 3) * 100 as cloud_per_change
        from trip t
        join station s on t.start_station_name = s.name
        join zip_to_cities z on s.city = z.city
        join average_weather_day awd on to_date(t.start_date, 'MM/DD/YYYY') = awd.date
        where t.start_station_name = 'Townsend at 7th'
        and t.end_station_name = 'San Francisco Caltrain (Townsend at 4th)'
        group by 1,2,3,4,5,6,7,10,12,14,16
        order by year asc, month asc, day asc;

/*

 W dalszej perspektywie chcialem zbadac zaleznosci miedzy wzrostem popularnosci na wskazanym odcinku a np. zmiana temperatury.
 Niestety zabraklo czasu na rozpisanie kwerend dla kazdego z przypadkow.
 
*/
