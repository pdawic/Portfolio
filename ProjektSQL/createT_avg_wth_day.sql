/*
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