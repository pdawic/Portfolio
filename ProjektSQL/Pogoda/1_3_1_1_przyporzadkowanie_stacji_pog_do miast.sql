select distinct w.zip_code, ztc.city from weather_norm w
join zip_to_cities ztc on w.zip_code = ztc.zip_code