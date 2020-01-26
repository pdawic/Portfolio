create table kickstarter_filtered as

with filtered_country as
(select
    id,
    case
    when country='AT' then 'Austria'
    when country='AU' then 'Australia'
    when country='BE' then 'Belgium'
    when country='CA' then 'Canada'
    when country='CH' then 'Switzerland'
    when country='DE' then 'Germany'
    when country='DK' then 'Denmark'
    when country='ES' then 'Spain'
    when country='FR' then 'France'
    when country='GB' then 'Great Britain (UK)'
    when country='HK' then 'Hong Kong'
    when country='IE' then 'Ireland'
    when country='IT' then 'Italy'
    when country='JP' then 'Japan'
    when country='LU' then 'Luxembourg'
    when country='MX' then 'Mexico'
    when country='N,0"' then null
    when country='NL' then 'Netherlands'
    when country='NO' then 'Norway'
    when country='NZ' then 'New Zealand'
    when country='SE' then 'Sweden'
    when country='SG' then 'Singapore'
    when country='US' then 'United States'
    else 'blad'end
    as country
from ks_projects_201801),

     filtered_duration as
(select id,
        date(launched) as launched,
        date(deadline) as deadline,
        date(deadline)-date(launched) as duration
from ks_projects_201801
where date_part('year', date(launched))!= '1970'
),

    filtered_money as
(select id,
        currency,
        goal as goal_in_defined_currency,
        pledged as pledged_in_defined_currency,
        usd_goal_real as goal_in_usd,
        usd_pledged_real as pledged_in_usd
from ks_projects_201801 )

select ks.id,
       ks.name,
       ks.main_category,
       ks.category,
       fc.country,
       fd.launched,
       fd.deadline,
       fd.duration,
       fm.currency,
       fm.goal_in_defined_currency,
       fm.pledged_in_defined_currency,
       fm.goal_in_usd,
       fm.pledged_in_usd,
       (fm.pledged_in_usd/fm.goal_in_usd)::numeric as percentage_of_money_collected,
       ks.backers,
       ks.state
from ks_projects_201801 ks
join filtered_country fc on fc.id=ks.id
join filtered_duration fd on fd.id=ks.id
join filtered_money fm on fm.id=ks.id
where fc.country is not null and ks.state!='live' and ks.state!='suspended'
order by 6
