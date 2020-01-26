drop table weather_norm

create table weather_norm as
select
date_part('year',to_date(date,'MM-dd-YYYY')) rok,
date_part('month',to_date(date,'MM-dd-YYYY')) miesiac,
date_part('day',to_date(date,'MM-dd-YYYY')) dzien,
rtrim(to_char(to_date(date,'mm/dd/yyyy'),'day')) dzien_tygodnia,
date,
--max_temperature_f,
((max_temperature_f-32)/1.8)::numeric(2) max_temerature_C,
((mean_temperature_f-32)/1.8)::numeric(2) mean_temperature_C,
((min_temperature_f-32)/1.8)::numeric(2) min_temperature_C,
((max_dew_point_f-32)/1.8)::numeric(2) max_dew_point_C,
((mean_dew_point_f-32)/1.8)::numeric(2) mean_dew_point_C,
((min_dew_point_f-32)/1.8)::numeric(2) min_dew_point_C,
max_humidity,
mean_humidity,
min_humidity,
(max_sea_level_pressure_inches*33.86388666666671) max_sea_level_pressure_hPa,
(mean_sea_level_pressure_inches*33.86388666666671) mean_sea_level_pressure_hPa,
(min_sea_level_pressure_inches*33.86388666666671) min_sea_level_pressure_hPa,
--max_visibility_miles,
(max_visibility_miles*1.609344) max_visibility_km,
(mean_visibility_miles*1.609344) mean_visibility_km,
(min_visibility_miles*1.609344) min_visibility_km,
max_wind_speed_mph,
mean_wind_speed_mph,
max_gust_speed_mph,
precipitation_inches cale_opadowe,
cloud_cover,
events,
wind_dir_degrees,
zip_code
from weather
order by 1,2,3;
