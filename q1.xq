
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
	let $cc := $country//city[@is_country_cap = "yes"]
	let $capital := $cc/name
	let $province := $cc/../name (: mondial inserts name of country if province does not exist :)
	let $area := $country/data(@area)
	let $pop := $country/population
return concat("INSERT INTO country VALUES (", 
	$quote, $name, $quote, $comma, 
	$quote, $code, $quote, $comma,
	$quote, $capital, $quote, $comma,
	$quote, $province, $quote, $comma,
	$area, $comma,
	$pop, $closing, $nl)
,

(: Generating insert statements into the city table :)
(: No provinces yet :)

for $city in doc($file)/mondial/country//city
	let $country := $city/@country
	let $name := $city/name
	let $province := $city/../name (: mondial inserts name of country if province does not exist :)
	let $pop := $city/population[1]
	let $long := $city/longitude
	let $lat := $city/latitude
return concat("INSERT INTO city VALUES (",
	$quote, $name, $quote, $comma,
	$quote, $country, $quote, $comma,
	$quote, $province, $quote, $comma,
	$pop, $comma,
	$long, $comma,
	$lat, $closing, $nl)
,

(: Generating insert statements into the province table :)

for $province in doc($file)/mondial/country/province
	let $name := $province/name
	let $country := $province/@country
	let $pop := $province/population[1]
	let $area := $province/area
	let $capital := $province/city[@is_state_cap = "yes"]/name
return concat("INSERT INTO province VALUES (",
	$quote, $name, $quote, $comma,
	$quote, $country, $quote, $comma,
	$pop, $comma,
	$area, $comma,
	$quote, $capital, $quote, $comma,
	$quote, $name, $quote, $comma, $closing, $nl) (: for some reason it seems that capProv == province name :)
,

(: countries without any provinces also go into the province table. Out of order with example output :)

for $country in doc($file)/mondial/country[@car_code != doc($file)/mondial/country/province[@country]]
	let $name := $country/name
	let $cc := $country/@car_code
	let $pop := $country/population[1]
	let $area := $country/area
	let $capital := $country/city[@is_country_cap = "yes"]/name
return concat("INSERT INTO province VALUES (",
	$quote, $name, $quote, $comma,
	$quote, $cc, $quote, $comma,
	$pop, $comma,
	$area, $comma,
	$quote, $capital, $quote, $comma,
	$quote, $name, $quote, $comma, $closing, $nl) 

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
	let $cc := $country/@car_code
	let $indep := $country/indep_date
	let $depend := $country/dependent/@country
	let $gov := $country/government
return concat("INSERT INTO politics VALUES (",
	$quote, $cc, $quote, $comma,
	$quote, $indep, $quote, $comma,
	$quote, $depend, $quote, $comma, 
	$quote, $gov, $quote, $comma, $closing, $nl)

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

for $border in doc($file)/mondial/country/border
	let $country1 := $border/../@car_code
	let $country2 := $border/@country
	let $length := $border/@length
return concat("INSERT INTO borders VALUES (",
	$quote, $country1, $quote, $comma,
	$quote, $country2, $quote, $comma,
	$quote, $length, $quote, $closing, $nl)

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
	let $toriver := doc($file)/mondial/river[@id = $river/to[@watertype = "river"]/@water]/name
	let $lake := doc($file)/mondial/lake[@id = $river/to[@watertype = "lake"]/@water]/name
	let $sea := doc($file)/mondial/sea[@id = $river/to[@watertype = "sea"]/@water]/name
	let $slong := $river/source/longitude
	let $slat := $river/source/latitude
	let $mountains := $river/source/mountains
	let $alt := $river/source/elevation
	let $elong := $river/estuary/longitude
	let $elat := $river/estuary/latitude

return concat("INSERT INTO river VALUES (",
	$quote, $name, $quote, $comma,
	$quote, $toriver, $quote, $comma, 
	$quote, $lake, $quote, $comma, 
	$quote, $sea, $quote, $comma, 
	$quote, $length, $quote, $comma,
	"ROW(", $slong, $comma, $slat, ")", $comma,
	$quote, $mountains, $quote, $comma,
	$quote, $alt, $quote, $comma,
	"ROW(", $elong, $comma, $elat, ")", $closing, $nl)
,

(: Generating inserts into geo_desert table :)

for $desert in doc($file)/mondial/desert
	let $name := $desert/name
for $cid in $desert/tokenize(@country, '\s+')
	let $country := doc(@file)//country[@car_code = $cid]/name
	let $provids := $desert/located[@country = $cid]/@province
	return
	if(string-length($provids) = 0) then 
		concat("INSERT INTO geo_desert VALUES (",
		$quote, $name, $quote, $comma, 
		$quote, $cid, $quote, $comma, 
		$quote, $cid, $quote, $closing, $nl)
	else
		let $provid := tokenize($provids, '\s+')
	for $provid in $provid
		let $province := doc(@file)/mondial/country/province[@id = $provid]/name
		return concat("INSERT INTO geo_desert VALUES (",
		$quote, $name, $quote, $comma, 
		$quote, $cid, $quote, $comma, 
		$quote, $provid, $quote, $closing, $nl)
,

(: Generating inserts into geo_river table :)
	
for $river in doc($file)/mondial/river
	let $name := $river/name
for $cid in $river/tokenize(@country, '\s+')
	let $country := doc(@file)//country[@car_code = $cid]/name
	let $provids := $river/located[@country = $cid]/@province
	return
	if(string-length($provids) = 0) then 
		concat("INSERT INTO geo_river VALUES (",
		$quote, $name, $quote, $comma, 
		$quote, $cid, $quote, $comma, 
		$quote, $cid, $quote, $closing, $nl)
	else
	let $provid := tokenize($provids, '\s+')
for $provid in $provid
	let $province := doc(@file)//province[@id = $provid]/name
	return concat("INSERT INTO geo_river VALUES (",
     $quote, $name, $quote, $comma,
     $quote, $cid, $quote, $comma,
     $quote, $provid, $quote, $closing, $nl)

,

(: Generating inserts into geo_sea table :)

for $sea in doc($file)/mondial/sea
	let $name := $sea/name
for $cid in $sea/tokenize(@country, '\s+')
	let $country := doc(@file)//country[@car_code = $cid]/name
	let $provids := $sea/located[@country = $cid]/@province
	return
	if(string-length($provids) = 0) then 
		concat("INSERT INTO geo_sea VALUES (",
		$quote, $name, $quote, $comma, 
		$quote, $cid, $quote, $comma, 
		$quote, $cid, $quote, $closing, $nl)
	else
	let $provid := tokenize($provids, '\s+')
for $provid in $provid
	let $province := doc(@file)//province[@id = $provid]/name
	return concat("INSERT INTO geo_sea VALUES (",
     $quote, $name, $quote, $comma,
     $quote, $cid, $quote, $comma,
     $quote, $provid, $quote, $closing, $nl)
,

(: Generating inserts into geo_lake table :)

for $lake in doc($file)/mondial/lake
	let $name := $lake/name
for $cid in $lake/tokenize(@country, '\s+')
	let $country := doc(@file)//country[@car_code = $cid]/name
	let $provids := $lake/located[@country = $cid]/@province
	return
	if(string-length($provids) = 0) then 
		concat("INSERT INTO geo_lake VALUES (",
		$quote, $name, $quote, $comma, 
		$quote, $cid, $quote, $comma, 
		$quote, $cid, $quote, $closing, $nl)
	else
	let $provid := tokenize($provids, '\s+')
for $provid in $provid
	let $province := doc(@file)//province[@id = $provid]/name
	return concat("INSERT INTO geo_lake VALUES (",
     $quote, $name, $quote, $comma,
     $quote, $cid, $quote, $comma,
     $quote, $provid, $quote, $closing, $nl)

,

(: Generating inserts into geo_source table :)

for $source in doc($file)/mondial/river
return concat("INSERT INTO geo_source VALUES (",
        "source", $comma, "country", $comma,
        "province", $closing, $nl)

,

(: Generating inserts into geo_estuary table :)

for $river in doc($file)/mondial/river
	let $name := $river/name
	let $estuary := $river/estuary
for $cid in $estuary/tokenize(@country, '\s+')
	let $country := doc(@file)//country[@car_code = $cid]/name
	let $provids := $estuary/located[@country = $cid]/@province
	return
	if(string-length($provids) = 0) then 
		concat("INSERT INTO geo_estuary VALUES (",
		$quote, $name, $quote, $comma, 
		$quote, $cid, $quote, $comma, 
		$quote, $cid, $quote, $closing, $nl)
	else
	let $provid := tokenize($provids, '\s+')
for $provid in $provid
	let $province := doc(@file)//province[@id = $provid]/name
	return concat("INSERT INTO geo_estuary VALUES (",
     $quote, $name, $quote, $comma,
     $quote, $cid, $quote, $comma,
     $quote, $provid, $quote, $closing, $nl)
,

(: Generating inserts into mergeswith table :)

for $s in doc($file)/mondial/sea
	let $s1 := $s/name
	for $s2id in tokenize($s/@bordering, '\s+')
	let $s2 := doc($file)/mondial/sea[@id = $s2id]/name
	return concat("INSERT INTO mergeswith VALUES (",
        $quote, $s1, $quote, $comma,
        $quote, $s2, $quote, $closing, $nl)
,

(: Generating inserts into located table :)

for $l in doc($file)/mondial//city/located_at
	let $name := $l/../name
	let $province := $l/../../name
	let $country := $l/../@country
	let $river := doc($file)/mondial/river[@id = $l/@river]/name
	let $lake := doc($file)/mondial/lake[@id = $l/@lake]/name
	let $sea := doc($file)/mondial/sea[@id = $l/@sea]/name 

return concat("INSERT INTO located VALUES (", 
	$quote, $name, $quote, $comma, 
	$quote, $province, $quote, $comma, 
	$quote, $country, $quote, $comma, 
	$quote, $river, $quote, $comma, 
	$quote, $lake, $quote, $comma, 
	$quote, $sea, $quote, $closing, $nl) 
,

(: Generating inserts into locatedon table :)

for $l in doc($file)/mondial//city/located_on
	let $name := $l/../name
	let $province := $l/../../name
	let $country := $l/../@country
	let $island := doc($file)//island[@id = $l/@island]/name

return concat("INSERT INTO locatedOn VALUES (",
	$quote, $name, $quote, $comma,
	$quote, $province, $quote, $comma,
	$quote, $country, $quote, $comma,
	$quote, $island, $quote, $closing, $nl)
,

(: Generating inserts into islandIn table :)

for $i in doc($file)/mondial/island
return concat("INSERT INTO islandin VALUES (",
        "island", $comma, "sea", $comma,
        "lake", $comma, 
	"river", $closing, $nl)

,

(: Generating inserts into mountainOnIsland table :)

for $m in doc($file)//mountain
	let $mountain := $m/name
	let $iID := $m/@island
	return 
	if(string-length($mountain) > 0 and string-length($iID) > 0 ) then
		let $island := doc($file)//island[@id = $iID]/name
		return concat("INSERT INTO mountainOnIsland VALUES (",
		$quote, $mountain, $quote, $comma,
		$quote, $island, $quote, $closing, $nl)
	else ()
