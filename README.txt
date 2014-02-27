*This repo will be used for the second project in ECS165B.

MEMBERS: 
HOLLENBECK, Jonathan - XQuery Coding, Documentaion
PAW, Alicia - XQuery Coding, Documentation

---

Files Included:

For Your Usage:
run.sh - Just run this to generate the appropriate SQL file. You will need Saxon 9 HE to compile.
mondial-to-postgres.xq - XQuery file holding all the queries from the XML file.
outputs.sql - The generated SQL file full of all the inserts.

For Your Ref: 
mondial.xml - The XML file we used to generate the equivalent SQL. If you intend on actually loading the inputs into PostgreSQL, I recommend you use this file, and the included schema.
mondial.dtd - The DTD behind the XML. For the most part anyway, see below for notes about this.
mondial-schema.sql - The variation of the mondial schema that we based our insert tuples on, from 165A. This is the variation that uses GeoCoord instead of Row for geo_X tables (but that doesn't really make a difference, as we observed).

---

To Run:
- We used Saxon to run our XQuery queries against the XML, so if you don't have that, you'll need to get it. See: https://courses.cs.washington.edu/courses/cse344/12au/hw/hw4/instructions.txt
- From the command line, just run the run.sh shell script and it'll generate a new outputs.sql file for you.

---

Summary:
- We used XQuery to process the XML for the relevant data, which then generated and printed out the equivalent insert statements. We used the mondial-schema and mondial-inputs file from 165A for reference, as the versions obtained from the supplemented website didn't seem to work? (used wget on both the inputs and the schema and got a bunch of error statements)
- The shell script cleans up the sql file after processing by XQuery. This includes removing the xml header tag automatically prepended by Saxon, and removing duplicate tuples. It also takes care of some of the anomalies we found in the XML data that wouldn't translate very well to SQL (see below).

---

Comments:
- As a heads-up, some of our tuples are "out of order" compared to mondial-inputs (ie, the Canada country tuple is inserted before the US in one and the other way around in another). Would not recommend diff.
- Adding onto that, note that the economy and population tables were filled concurrently, simply because it was more efficient to query the data at the same time from the XML. The SQL doesn't look as pretty and prim as a result though.
- So the XML DTD doesn't actually seem to match up with the given XML? Most notably was when creating the islandIn table, the DTD had no mention about river being included as one of island's attributes, but yet it was present in the XML file. Because of this and it's lack of overall clarity, we assumed that while an island can be in multiple seas or multiple rivers, they cannot be in a combination of rivers and seas.
- We also noticed an anomaly with the XML data when querying for geo_Mountain. There were two mountains provided (mount-UlugMuztag and mount-LiushiShan), that didn't follow the convention of <located country="X" province="Y Z ..."/>, and instead, split the detokenized list of provinces into two located statements. Rather than modify our query, we decided to modify the XML data to take care of this anomaly, as this did not seem to be present in any of the other tables.
- More on XML data discrepancies, we also noted that for some reason, encompasses doesn't use the continent names as is actually defined (ie, just australia vs. Australia/Oceania). The script takes care of this, and replaces all of the continent names with the correct equivalent (I guess XML might not be case-sensitive but Postgres is).
- When we checked our output against that of mondial-inputs and count-output.csv, the difference in tuple numbers was reasonable. Notably our borders and mergesWith tables have nearly twice as many tuples as the original, but that is because we have duplicates from the symmetry of these relations (ie, the Atlantic Ocean merges with the Mediterranean Sea, and vice versa, but this is represented as two tuples in our outputs.sql and just one in the original). 
- There's a lot of disparity between the XML data and the SQL data that could just not be modeled, such as some rivers (or anything really) being completely left out in the XML version, but being present in the SQL version and vice versa, or numerical values being different, probably because the data might be from different years. For instance, while Sulu Sea and Java Sea is present in the XML version, it is not present in the SQL version of the data.

---

Specific Notes About the Tuples of Each Table:
Country - OK
City - OK
Province - OK, out of order because of dealing with countries that don't have provinces. If a province does not have a capital city or a capital province, it is set to itself by default. 
Economy - OK, there are some tuples that may be filled with only null values except the country code/name.
Population - OK, same as above. Note that for efficiency purposes 
Politics - OK
Language - OK
Religion - OK
EthnicGroup - OK
Continent - OK
Borders - OK, has duplicates from symmetry
Encompasses - OK
Organization - OK
isMember - OK
Mountain - OK
Desert - OK
Island - OK
Lake - OK
Sea - OK
River - OK, due to the nature of the "to" element in the XML, if either lake, river, or sea is filled, the other two will be null. As the XML only allows one instance of "to" for each river, this is the solution we decided to settle with.
geo_Desert - OK
geo_River - OK
geo_Sea - OK
geo_Source - OK 
geo_Estuary - OK
mergeswith - OK, has duplicates from symmetry
located - OK
locatedOn - OK
islandIn - OK, refer to assumption above
geo_Island - OK
geo_Mountain - OK
mountainOnIsland - OK