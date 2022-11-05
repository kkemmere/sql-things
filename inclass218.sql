use world;

LOCK TABLES city WRITE;
LOCK TABLES country WRITE;

select city.name 
from city, country 
where city.ID = country.capital and city.population>500000;
