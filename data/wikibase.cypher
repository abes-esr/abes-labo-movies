//
// Code inspiré de https://towardsdatascience.com/traveling-tourist-part-1-import-wikidata-to-neo4j-with-neosemantics-library-f80235f40dc5
// TODO: l'adapter sur le sparql wikibase de l'etude
//

CALL n10s.graphconfig.init({handleVocabUris: "IGNORE"})

WITH '
CONSTRUCT 
WHERE { ?item wdt:P31 wd:Q4989906 .
        ?item wdt:P17 wd:Q29 .
        ?item rdfs:label ?monumentName .
        ?item wdt:P625 ?location .
        ?item wdt:P149 ?architecture .
        ?architecture rdfs:label
        ?architectureName .
        ?item wdt:P18 ?image} limit 10 ' AS sparql
CALL n10s.rdf.preview.fetch(
  "https://query.wikidata.org/sparql?query=" +
     apoc.text.urlencode(sparql),"JSON-LD",
  { headerParams: { Accept: "application/ld+json"} ,
    handleVocabUris: "IGNORE"})
YIELD nodes, relationships
RETURN nodes, relationships
