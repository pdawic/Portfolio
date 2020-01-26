with wsad1 as (
                select s.city miasto, count(t.id) cnt_ropz_tras from trip t
                join station s on s.name = t.start_station_name
                group by s.city
            ),
 wsad2 as (
                select s.city miasto, count(t.id) cnt_zak_tras from trip t
                join station s on s.name = t.end_station_name
                group by s.city
              )

select wsad1.miasto,wsad1.cnt_ropz_tras, wsad2.cnt_zak_tras,
       wsad1.cnt_ropz_tras-wsad2.cnt_zak_tras roznica,
       ((wsad1.cnt_ropz_tras-wsad2.cnt_zak_tras)/wsad1.cnt_ropz_tras::numeric)*100 procentowo
from wsad1
join wsad2 on wsad2.miasto=wsad1.miasto