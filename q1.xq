
(: Declaring some hard-coded strings :)

declare variable $quote := "&apos;";
declare variable $comma := ", ";
declare variable $nl := "&#10;";
declare variable $closing := ");";
declare variable $file := "mondial.xml";

(: Generating insert statements into the country table :)
(: Currently uses city_id for capital and no provinces :)

for $country in doc($file)/mondial/country
	let $name := $country/name
	let $code := $country/data(@car_code)
	let $capital := $country/data(@capital)
	let $area := $country/data(@area)
	let $pop := $country/population
return concat("INSERT INTO country VALUES (", 
	$quote, $name, $quote, $comma, 
	$quote, $code, $quote, $comma,
	$quote, $capital, $quote, $comma,
	$area, $comma,
	$pop, $closing, $nl)
,

(: Generating insert statements into the city table :)
(: No provinces yet :)

for $city in doc($file)/mondial/country/city
	let $country := $city/../name
	let $name := $city/name
	let $pop := $city/population[1]
	let $long := $city/longitude
	let $lat := $city/latitude
return concat("INSERT INTO city VALUES (",
	$quote, $name, $quote, $comma,
	$quote, $country, $quote, $comma,
	$pop, $comma,
	$long, $comma,
	$lat, $closing, $nl)

,

(: Generating inserts into economy and population tables :)

for $country in doc($file)/mondial/country
	let $name := $country/name
	let $gdp := $country/gdp_total
	let $agri := $country/gdp_agri
	let $service := $country/gdp_serv
	let $industry := $country/gdp_ind
	let $inflation := $country/inflation
	let $pop_grow := $country/population_growth
	let $infant_mort := $country/infant_mortality
return (concat("INSERT INTO economy VALUES (",
	$quote, $name, $quote, $comma,
	$gdp, $comma,
	$agri, $comma,
	$service, $comma, 
	$industry, $comma,
	$inflation, $closing, $nl),
	concat("INSERT INTO population VALUES (",
	$quote, $name, $quote, $comma,
	$pop_grow, $comma, 
	$infant_mort, $closing, $nl)) 

,

(: Generating inserts into continent table :)

for $continent in doc($file)/mondial/continent
	let $name := $continent/name
	let $area := $continent/area
return concat("INSERT INTO continent VALUES (",
	$quote, $name, $quote, $comma,
	$area, $closing, $nl)

,

(: Generating inserts into organization table :)
(: only takes city id, xml does not have country and province info :)

for $org in doc($file)/mondial/organization
	let $abbrev := $org/abbrev
	let $name := $org/name
	let $city := $org/data(@headq)
	let $establish := $org/established
return concat("INSERT INTO organization VALUES (",
	$quote, $abbrev, $quote, $comma, 
	$quote, $name, $quote, $comma,
	$quote, $city, $quote, $comma,
	$quote, "null", $quote, $comma,
	$quote, "null", $quote, $comma,
	$establish, $closing, $nl)

,

(: Generating inserts into mountain table :)

for $mountain in doc($file)/mondial/mountain
	let $name := $mountain/name
	let $mountains := $mountain/mountains
	let $height := $mountain/elevation
	let $type := $mountain/data(@type)
	let $long := $mountain/longitude
	let $lat := $mountain/latitude
return concat("INSERT INTO mountain VALUES (",
	$quote, $name, $quote, $comma,
	$quote, $mountains, $quote, $comma,
	$height, $comma,
	$quote, $type, $quote, $comma,
	"GeoCoord(", $long, $comma, $lat, ")", $closing, $nl)

,

(: Generating inserts into desert table :)

for $desert in doc($file)/mondial/desert
	let $name := $desert/name
	let $area := $desert/area
	let $long := $desert/longitude
	let $lat := $desert/latitude
return concat("INSERT INTO desert VALUES (",
	$quote, $name, $quote, $comma,
	$area, $comma, 
	"GeoCoord(", $long, $comma, $lat, ")", $closing, $nl)

,

(: Generating inserts into island table :)	

for $island in doc($file)/mondial/island
	let $name := $island/name
	let $islands := $island/islands
	let $area := $island/area
	let $height := $island/elevation
	let $type := $island/data(@type)
	let $long := $island/longitude
	let $lat := $island/latitude
return concat("INSERT INTO island VALUES (",
	$quote, $name, $quote, $comma,
	$quote, $islands, $quote, $comma,
	$area, $comma,
	$height, $comma,
	$type, $comma,
	"GeoCoord(", $long, $comma, $lat, ")", $closing, $nl)

,

(: Generating inserts into lake table :)

for $lake in doc($file)/mondial/lake
	let $name := $lake/name
	let $area := $lake/area
	let $depth := $lake/depth
	let $altitude := $lake/elevation
	let $type := $lake/data(@type)
	let $long := $lake/longitude
	let $lat := $lake/latitude
return concat("INSERT INTO lake VALUES (",
	$quote, $name, $quote, $comma,
	$area, $comma,
	$depth, $comma,
	$altitude, $comma,
	$quote, $type, $quote, $comma,
	"GeoCoord(", $long, $comma, $lat, ")", $closing, $nl)

,

(: Generating inserts into sea table :)

for $sea in doc($file)/mondial/sea
	let $name := $sea/name
	let $depth := $sea/depth
return concat("INSERT INTO sea VALUES (",
	$quote, $name, $quote, $comma,
	$depth, $closing, $nl)
