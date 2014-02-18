
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
	"province of capital", $comma,
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
	"province", $comma,
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

(: Generating inserts into politics table :)

for $country in doc($file)/mondial/country
return concat("INSERT INTO politics VALUES (",
	"country", $comma, "indep date", $comma,
	"or depend country", $comma, 
	"government", $closing, $nl)

,

(: Generating inserts into language table :)

for $l in doc($file)/mondial/country/languages
	let $country := $l/../name
	let $name := $l/text()
	let $percentage := $l/data(@percentage)	
return concat("INSERT INTO language VALUES (",
	$country, $comma, 
	$name, $comma,
	$percentage, $closing, $nl)

,

(: Generating inserts into religion table :)

for $r in doc($file)/mondial/country/religions
	let $country := $r/../name
	let $name := $r/text()
	let $percentage := $r/data(@percentage) 
return concat("INSERT INTO religion VALUES (",
	$country, $comma,
	$name, $comma,
	$percentage, $closing, $nl)

,

(: Generating inserts into ethic group table :)

for $e in doc($file)/mondial/country/ethicgroups
        let $country := $e/../name
        let $name := $e/text()
        let $percentage := $e/data(@percentage)
return concat("INSERT INTO ethicgroup VALUES (",
        $country, $comma, 
	$name, $comma,
        $percentage, $closing, $nl)

,


(: Generating inserts into continent table :)

for $continent in doc($file)/mondial/continent
	let $name := $continent/name
	let $area := $continent/area
return concat("INSERT INTO continent VALUES (",
	$quote, $name, $quote, $comma,
	$area, $closing, $nl)

,

(: Generating inserts into borders table :)

for $country in doc($file)/mondial/country
return concat("INSERT INTO borders VALUES (",
	"country1", $comma, "country2", $comma,
	"length", $closing, $nl)

,

(: Generating inserts into encompasses table :)

for $c in doc($file)/mondial/country/encompassed
	let $country := $c/../name
	let $continent := $c/data(@continent)
	let $percentage := $c/data(@percentage)
return concat("INSERT INTO encompassses VALUES(",
	$country, $comma,
	$continent, $comma,
	$percentage, $closing, $nl)

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

(: Generatng inserts into isMember table :)

for $member in doc($file)/mondial/organization/members
return concat("INSERT INTO ismember VALUES (",
	"country", $comma, "org", $comma,
	"type", $closing, $nl)

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

,

(: Generating inserts into river table :)

for $river in doc($file)/mondial/river
	let $name := $river/name
	let $length := $river/length
return concat("INSERT INTO river VALUES (",
	$quote, $name, $quote, $comma,
	"river", $comma, "lake", $comma, "sea", $comma, 
	$length, $comma,
	"source coord", $comma, "mountains", $comma, 
	"source alt", $comma, "estuary coord", $closing, $nl)

,

(: Generating inserts into geo_desert table :)

for $desert in doc($file)/mondial/desert
return concat("INSERT INTO geo_desert VALUES (",
	"desert", $comma, "country", $comma,
	"province", $closing, $nl)

,

(: Generating inserts into geo_river table :)

for $river in doc($file)/mondial/river
return concat("INSERT INTO geo_river VALUES (",
        "river", $comma, "country", $comma,
        "province", $closing, $nl)

,

(: Generating inserts into geo_sea table :)

for $sea in doc($file)/mondial/sea
return concat("INSERT INTO geo_desert VALUES (",
        "sea", $comma, "country", $comma,
        "province", $closing, $nl)

,

(: Generating inserts into geo_lake table :)

for $lake in doc($file)/mondial/lake
return concat("INSERT INTO geo_desert VALUES (",
        "lake", $comma, "country", $comma,
        "province", $closing, $nl)

,

(: Generating inserts into geo_source table :)

for $source in doc($file)/mondial/river
return concat("INSERT INTO geo_source VALUES (",
        "source", $comma, "country", $comma,
        "province", $closing, $nl)

,

(: Generating inserts into geo_estuary table :)

for $estuary in doc($file)/mondial/river
return concat("INSERT INTO geo_estuary VALUES (",
        "estuary", $comma, "country", $comma,
        "province", $closing, $nl)

,

(: Generating inserts into mergeswith table :)

for $s in doc($file)/mondial/sea
return concat("INSERT INTO mergeswith VALUES (",
        "sea1", $comma,
        "sea2", $closing, $nl)

,

(: Generating inserts into located table :)

for $l in doc($file)/mondial/city
return concat("INSERT INTO located VALUES (",
        "city", $comma, "province", $comma,
        "country", $comma, "river", $comma,
	"lake", $comma, "sea", $closing, $nl)

,

(: Generating inserts into locatedon table :)

for $c in doc($file)/mondial/city
return concat("INSERT INTO locatedon VALUES (",
        "city", $comma, "province", $comma,
        "country", $comma, 
	"island", $closing, $nl)

,

(: Generating inserts into islandIn table :)

for $i in doc($file)/mondial/island
return concat("INSERT INTO islandin VALUES (",
        "island", $comma, "sea", $comma,
        "lake", $comma, 
	"river", $closing, $nl)

,

(: Generating inserts into mountainOnIsland table :)

for $m in doc($file)/mondial/mountain
return concat("INSERT INTO mountainonisland VALUES (",
        "mountain", $comma,
        "island", $closing, $nl)
