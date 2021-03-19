//
// Code inspiré de https://towardsdatascience.com/traveling-tourist-part-1-import-wikidata-to-neo4j-with-neosemantics-library-f80235f40dc5
// TODO: l'adapter sur le sparql wikibase de l'etude
// TODO: peut-être voir pour ajouter cette instruction mais est elle vraiement nécessaire ? => CALL n10s.graphconfig.init({handleVocabUris: "IGNORE"})
//

WITH ' PREFIX sch: <http://schema.org/> 
CONSTRUCT{ ?item a sch:Monument; 
            sch:name ?monumentName; 
            sch:location ?location; 
            sch:img ?imageAsStr; 
            sch:ARCHITECTURE ?architecture. 
          ?architecture a sch:Architecture; 
           sch:name ?architectureName } 
WHERE { ?item wdt:P31 wd:Q4989906 . 
        ?item wdt:P17 wd:Q29 . 
        ?item rdfs:label ?monumentName . 
          filter(lang(?monumentName) = "en") 
        ?item wdt:P625 ?location . 
        ?item wdt:P149 ?architecture . 
        ?architecture rdfs:label ?architectureName .  
          filter(lang(?architectureName) = "en") 
        ?item wdt:P18 ?image . 
          bind(str(?image) as ?imageAsStr) } limit 100 ' AS sparql CALL n10s.rdf.preview.fetch(
  "https://query.wikidata.org/sparql?query=" +  
      apoc.text.urlencode(sparql),"JSON-LD", 
    { headerParams: { Accept: "application/ld+json"} ,   
      handleVocabUris: "IGNORE"})
YIELD nodes, relationships 
RETURN nodes, relationships
