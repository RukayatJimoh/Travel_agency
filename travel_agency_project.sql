CREATE TABLE travels (
country_name varchar(100),
common_native_name varchar(100),
official_country_name varchar(100),
independence varchar(100),
united_Nation_members varchar(100),
startOfWeek varchar(100),
currency_name varchar(100),
currency_symbol varchar(50),
capital varchar(100),
region varchar(100),
sub_region varchar(100),
languages varchar(250),
areas numeric (20,2),
population numeric(20,2),
continents varchar(100),
currency_code varchar(5),
country_code varchar (50))

SELECT *
FROM public.travels

COPY public.travels
FROM '/Applications/PostgreSQL 16/travels.csv'
WITH (FORMAT CSV, HEADER TRUE)

--How many countries speaks French
SELECT COUNT (*)
FROM public.travels
WHERE languages LIKE '%French%'

--How many countries speaks english
SELECT COUNT (*)
FROM public.travels
WHERE languages LIKE '%English%'

--How many country have more than 1 official language
SELECT COUNT *
FROM public.travels
WHERE array_length(string_to_array(languages,', '), 1) > 1;

--How many country official currency is Euro
SELECT COUNT (*)
FROM public.travels
WHERE currency_name LIKE '%Euro%'

--How many country is from West europe
SELECT COUNT (*)
FROM public.travels
WHERE sub_region = 'Western Europe'

--How many country has not yet gain independence
SELECT COUNT (*)
FROM public.travels
WHERE independence = 'False'

--How many distinct continent and how many country from each
SELECT continents, COUNT(country_name) as countries_by_continent
FROM public.travels GROUP BY continents

--How many country whose start of the week is not Monday
SELECT COUNT (*)
FROM public.travels
WHERE startofweek != 'monday'

--How many countries are not a United Nation member
SELECT COUNT(*)
FROM public.travels
WHERE united_nation_members = 'False'

--How many countries are United Nation member
SELECT COUNT(*)
FROM public.travels
WHERE united_nation_members = 'True'

--Least 2 countries with the lowest population for each continents
SELECT country_name,continents, population,rn
FROM (
SELECT country_name, continents, population,
ROW_NUMBER() OVER (PARTITION BY continents ORDER BY population ASC) as rn
FROM public.travels) as subquery
WHERE rn <= 2
order by continents, population

 --Top 2 countries with the largest Area for each continent
SELECT continents,country_name, areas,rnk
FROM
	( 
	SELECT country_name, areas,continents, 
	ROW_NUMBER() OVER (PARTITION BY continents ORDER BY areas DESC) as rnk
	FROM public.travels
) as subquery
WHERE rnk <= 2

--Top 5 countries with the largest Area
SELECT country_name, areas
FROM public.travels
ORDER BY  areas DESC
LIMIT 5

--Top 5 countries with the lowest Area
SELECT country_name, areas
FROM public.travels
ORDER BY  areas ASC
LIMIT 5

--Average Population and Area by Continent
SELECT continents, round(AVG(population),2) As Avg_population, round(AVG(areas),2) as Avg_areas
FROM public.travels
GROUP BY continents
ORDER BY Avg_population, Avg_areas DESC

--Number of Countries by Region
SELECT region, COUNT (country_name) AS countries_by_region
FROM public.travels
GROUP BY region

--Number of Countries by continent
SELECT continents, COUNT (country_name) AS countries_continent
FROM public.travels
GROUP BY continents

--Number of Countries by Currency
SELECT currency_code, COUNT(country_name)
FROM public.travels
GROUP BY currency_code

--Number of Countries by Language
SELECT languages, COUNT(country_name)
FROM public.travels
GROUP BY languages

--Top 10 Densest Countries
SELECT country_name, population
FROM public.travels
ORDER BY population DESC
LIMIT 10

--Number of Languages by Continent
SELECT continents,COUNT(languages) AS language_by_continents
FROM public.travels
GROUP BY continents
ORDER BY language_by_continents DESC
 