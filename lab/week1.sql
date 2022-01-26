-- How many taxi trips were there on January 15?
select count(*) 
FROM yellow_taxi_trips
WHERE CAST(tpep_pickup_datetime AS DATE) = '2021-01-15'

--On which day it was the largest tip in January? (note: it's not a typo, it's "tip", not "trip")
select tpep_pickup_datetime 
from yellow_taxi_trips where tip_amount = (
	select max(tip_amount)
	from yellow_taxi_trips
	where extract(month from tpep_pickup_datetime) = 1 )

--What was the most popular destination for passengers picked up in central park on January 14?
--Use the pick up time for your calculations.
--Enter the zone name (not id). If the zone name is unknown (missing), write "Unknown"

SELECT zdo."Zone", count(*)
    FROM
    yellow_taxi_trips t JOIN taxi_zone_lookup zpu ON t."PULocationID" = zpu."LocationID"
	JOIN taxi_zone_lookup zdo ON 
	    t."DOLocationID" = zdo."LocationID"
	WHERE zpu."Zone" = 'Central Park' AND CAST(t.tpep_pickup_datetime AS DATE) = '2021-01-14'
	GROUP BY zdo."Zone"
	ORDER BY COUNT DESC LIMIT 1;

	-- What's the pickup-dropoff pair with the largest average price for a ride (calculated based on total_amount)?
-- Enter two zone names separated by a slashFor example:"Jamaica Bay / Clinton East"If any of the zone names are unknown (missing), write "Unknown". For example, "Unknown / Clinton East".

SELECT avg(total_amount) as aveg,
	CONCAT(zpu."Borough", '/', zpu."Zone") AS pickup_loc,
		CONCAT(zdo."Borough", '/', zdo."Zone") AS dropoff_loc
		FROM
		    yellow_taxi_trips t JOIN taxi_zone_lookup zpu ON t."PULocationID" = zpu."LocationID"
			JOIN taxi_zone_lookup zdo ON 
			    t."DOLocationID" = zdo."LocationID"
			GROUP BY  pickup_loc, dropoff_loc 
			ORDER BY aveg DESC LIMIT 100;
