

WITH
[
	{ neoSchemaElem : "name", publicSchemaElem: "name" }
] AS mappingsFoaf,
"http://xmlns.com/foaf/0.1/" AS foafUri
CALL n10s.nsprefixes.add("foaf",foafUri) YIELD namespace
UNWIND mappingsFoaf as m
CALL n10s.mapping.add(foafUri + m.publicSchemaElem,m.neoSchemaElem) YIELD schemaElement
RETURN count(schemaElement) AS mappingsDefined;

WITH
[
	{ neoSchemaElem : "name", publicSchemaElem: "statetype" }
] AS mappingsMov,
"http://www.abes.fr/vocabularies/movies#" AS movUri
CALL n10s.nsprefixes.add("mov",movUri) YIELD namespace
UNWIND mappingsMov as m
CALL n10s.mapping.add(movUri + m.publicSchemaElem,m.neoSchemaElem) YIELD schemaElement
RETURN count(schemaElement) AS mappingsDefined;




CALL n10s.graphconfig.init({handleVocabUris: 'MAP'});



CALL n10s.rdf.import.fetch("https://raw.githubusercontent.com/abes-esr/abes-labo-movies/main/data/movies_yns_5_saclay.ttl","Turtle");
