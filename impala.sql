-- Create a list to display the airline, departing and arriving airport and the number of stops
select airlines.name, a.name as source_name, b.name as dest_name, sum(stops) 
from routes inner join airlines on airlines.airline_id = routes.airline_id
inner join airports a on routes.source_airport_id = a.airport_id
inner join airports b on routes.dest_airport_id = b.airport_id
group by airlines.name, a.name, b.name


-- Getting cities with more than 30 min. delay
select 
year,
month,
dest.country,
dest.name,
src.country,
src.name,
sum(if(arrdelay > 30, 1, 0)) as flights_delayed
from 
delays ad 
inner join airports src on ad.origin = src.iata_code_airport
inner join airports dest on ad.dest = dest.iata_code_airport
where year in (2000,2001,2002)
group by year, month, dest.country,dest.name,src.country,src.name
order by flights_delayed desc, year, month, dest.country,dest.name,src.country,src.name asc;

-- delay rate:  which airlines have maximum delays for the flights inside continental US during the business days from 1988 to 2009
select
   min(year), max(year), uniquecarrier, count(*) as cnt,
   sum(if(arrdelay > 30, 1, 0)) as flights_delayed,
   round(sum(if(arrdelay >30, 1, 0))/count(*),2) as rate
FROM delays
WHERE
   DayOfWeek not in (6,7) and origin not in ('AK', 'HI', 'PR', 'VI')
   and dest not in ('AK', 'HI', 'PR', 'VI')
GROUP by uniquecarrier
HAVING cnt > 100000 and max(year) > 1990
ORDER by rate DESC
LIMIT 1000
