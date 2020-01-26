-- tabela do sprawdzenia ile kampanii było o każdym statusie z poszczególnych kategorii

select  main_category, category,
       count(case when kf.state ilike 'successful' then kf.id end) as successful,
       count(case when kf.state ilike 'failed' then kf.id end) as failed,
       count(case when kf.state ilike 'canceled' then kf.id end) as canceled,
       count(case when kf.state ilike 'suspended' then kf.id end) as suspended,
       count(case when kf.state ilike 'live' then kf.id end) as live
from kickstarter_filtered as kf
group by main_category, category
order by main_category, category;

-- okazuje się, że praktycznie w każdej jest kilka 'suspended' oraz 'live' mimo, że deadliny
-- były do 2018 roku - najprawdopodobniej dane są z któregoś dnia roku 2018, stąd propozycja,
-- żeby po prostu te statusy wykluczyć z analizy, jako przypadki, co do których nie mamy
-- pełnych danych.

-- teraz tabela, żeby zobaczyć success rate [ ( successful / (failed + canceled ) ]
-- oraz min, max i średnią "goal" (celem weryfikacji, że sukces to nie tylko efekt
-- np. małej kwoty potrzebnej do zebrania).

-- okazało się, że jest ogromny rozstrzał między min oraz max, więc avg nie za wiele daje,
-- dlatego od razu dorzucona mediana

select  main_category, category,
       count(case when kf.state ilike 'successful' then kf.id end)/
       (count(case when kf.state ilike 'failed' then kf.id end)+count(case when kf.state ilike 'canceled' then kf.id end))::numeric
            as success_rate,
       count(case when kf.state ilike 'successful' then kf.id end) as successful,
       count(case when kf.state ilike 'failed' then kf.id end) as failed,
       count(case when kf.state ilike 'canceled' then kf.id end) as canceled,
       min(goal_in_usd) as min_goal,
       max(goal_in_usd) as max_goal,
       avg(goal_in_usd) as avg_goal,
       percentile_disc(0.5) within group (order by goal_in_usd) as median_goal
from kickstarter_filtered as kf
group by main_category, category
order by success_rate desc, main_category, category;

-- na tym etapie ogólne wnioski, że pewnie warto wykluczyć kilka kategorii z najmniejszą
-- bezwzględną liczbą sukcesów i porażek, jako za małe próby dla tych kategorii, niemniej
-- będziemy w stanie wytworzyć jakiś współczynnik dla kategorii jako sprzyjający lub nie
-- sukcesowo kampanii

-- teraz oddzielnie waluta:

select  currency,
       count(case when kf.state ilike 'successful' then kf.id end)/
       (count(case when kf.state ilike 'failed' then kf.id end)+count(case when kf.state ilike 'canceled' then kf.id end))::numeric
            as success_rate,
       count(case when kf.state ilike 'successful' then kf.id end) as successful,
       count(case when kf.state ilike 'failed' then kf.id end) as failed,
       count(case when kf.state ilike 'canceled' then kf.id end) as canceled
from kickstarter_filtered as kf
group by currency
order by success_rate desc, currency;

-- jaest dość wyrażna różnica między walutami, więc znowu można coś podziałać ze współczynnikami

-- teraz kraj

select  country,
       count(case when kf.state ilike 'successful' then kf.id end)/
       (count(case when kf.state ilike 'failed' then kf.id end)+count(case when kf.state ilike 'canceled' then kf.id end))::numeric
            as success_rate,
       count(case when kf.state ilike 'successful' then kf.id end) as successful,
       count(case when kf.state ilike 'failed' then kf.id end) as failed,
       count(case when kf.state ilike 'canceled' then kf.id end) as canceled
from kickstarter_filtered as kf
group by country
order by success_rate desc, country;

-- i od razu waluta + kraj, które pokazuje, że jeśli ta sama waluta, to dużo zależy od kraju

select  currency, country,
       count(case when kf.state ilike 'successful' then kf.id end)/
       (count(case when kf.state ilike 'failed' then kf.id end)+count(case when kf.state ilike 'canceled' then kf.id end))::numeric
            as success_rate,
       count(case when kf.state ilike 'successful' then kf.id end) as successful,
       count(case when kf.state ilike 'failed' then kf.id end) as failed,
       count(case when kf.state ilike 'canceled' then kf.id end) as canceled
from kickstarter_filtered as kf
group by currency, country
order by currency, country,success_rate desc;

-- zobaczmy jeszcze czas trwania kampanii (trochę ciężko stwierdzić, więc pewnie przydałby się wykres)

select  duration,
       count(case when kf.state ilike 'successful' then kf.id end)/
       (count(case when kf.state ilike 'failed' then kf.id end)+count(case when kf.state ilike 'canceled' then kf.id end))::numeric
            as success_rate,
       count(case when kf.state ilike 'successful' then kf.id end) as successful,
       count(case when kf.state ilike 'failed' then kf.id end) as failed,
       count(case when kf.state ilike 'canceled' then kf.id end) as canceled
from kickstarter_filtered as kf
group by duration
order by success_rate desc, duration;

-- kiedy się kampanie zaczęły oraz skończyły
-- raczej małe różnice, ale pewne tendencje widać

select  date_part('month', date(launched)) as month,
       count(case when kf.state ilike 'successful' then kf.id end)/
       (count(case when kf.state ilike 'failed' then kf.id end)+count(case when kf.state ilike 'canceled' then kf.id end))::numeric
            as success_rate,
       count(case when kf.state ilike 'successful' then kf.id end) as successful,
       count(case when kf.state ilike 'failed' then kf.id end) as failed,
       count(case when kf.state ilike 'canceled' then kf.id end) as canceled
from kickstarter_filtered as kf
group by month
order by month,success_rate desc;

select  date_part('month', date(deadline)) as month,
       count(case when kf.state ilike 'successful' then kf.id end)/
       (count(case when kf.state ilike 'failed' then kf.id end)+count(case when kf.state ilike 'canceled' then kf.id end))::numeric
            as success_rate,
       count(case when kf.state ilike 'successful' then kf.id end) as successful,
       count(case when kf.state ilike 'failed' then kf.id end) as failed,
       count(case when kf.state ilike 'canceled' then kf.id end) as canceled
from kickstarter_filtered as kf
group by month
order by month,success_rate desc;