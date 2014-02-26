*This repo will be used for the second project in ECS165B.

MEMBERS: 
HOLLENBECK, Jonathan - XQuery Coding, Documentaion
PAW, Alicia - XQuery Coding, Documentation

Files Included:

For Your Usage:
run.sh - Just run this to generate the appropriate SQL file. You will need Saxon 9 HE to compile.
mondial-to-postgres.xq - XQuery file holding all the queries from the XML file.
outputs.sql - The generated SQL file full of all the inserts.

For Your Ref: 
mondial.xml - The XML file we used to generate the equilvalent SQL.
mondial.dtd - The DTD behind the XML. For the most part anyway, see below for notes about this.
mondial-schema.sql - The variation of the mondial schema that we based our insert tuples on. This is the variation that uses GeoCoord instead or Row for geo_X tables.

To Run:
- We used Saxon to run our XQuery queries against the XML, so if you don't have that, you'll need to get it. See: https://courses.cs.washington.edu/courses/cse344/12au/hw/hw4/instructions.txt
- From the command line, just run the run.sh shell script and it'll generate a new outputs.sql file for you.

Notes:
- So the XML DTD doesn't actually seem to match up with the given XML? Most notably was when creating the islandIn table, the DTD had no mention about river being included as one of island's attributes, but yet it was present in the XML file. Because of this and it's lack of overall clarity, we assumed that while an island can be in multiple seas or multiple rivers, they cannot be in a combination of rivers and seas.
- There's a lot of disparity between the XML data and the SQL data that could just not be modeled. (Note these or anything observed?)

Specific Notes About the Tuples of Each Table:
Country - OK
City - OK
Province - OK, out of order because of dealing with countries that don't have provinces. If a province does not have a capital city or a capital province, it is set to itself by default. 
Economy - OK, there are some tuples that may be filled with only null values except the country code/name.
Population - OK, same as above.
Politics - OK
Language - OK
Religion - OK
EthicGroup - OK
Continent - OK
Borders - OK, known to be out of order
Encompasses - OK
Organization - OK
isMember - OK
Mountain - OK
Desert - OK
Island - OK
Lake - OK
Sea - OK
River - Some entries incorrect (not sure about this though)?
geo_Desert - OK
geo_River - OK
geo_Sea - OK, known to be out of order
geo_Source - OK 
geo_Estuary - OK
mergeswith - OK, has duplicates, not sure if that matters
located - OK
locatedOn - OK
islandIn - OK, refer to assumption above
mountainOnIsland - OK