CALL n10s.graphconfig.init({handleVocabUris: "IGNORE"});

// loads data from GraphDB with a construct query
CALL n10s.rdf.import.fetch("http://labo-vm-2.v202.abes.fr:7200/repositories/men-habilitations-v4-habilitations-partielles-inference-class","JSON-LD", {
  handleVocabUris: "IGNORE",
  typesToLabels: false,
  headerParams: { Accept: "application/ld+json", infer: "true", sameAs: "true"},
  payload: "query=" + apoc.text.urlencode("PREFIX owl:<http://www.w3.org/2002/07/owl#> PREFIX paysage: <http://paysage.mesri.fr/structures/> PREFIX wdt:<http://www.wikidata.org/prop/direct/> PREFIX skos:<http://www.w3.org/2004/02/skos/core#> PREFIX ppn: <http://www.abes.fr/entities/organizations/ppn/> PREFIX etats:<http://www.abes.fr/entities/etats/> PREFIX foaf: <http://xmlns.com/foaf/0.1/> CONSTRUCT WHERE { ?s ?p ?o. }")
});

// loads prefixes
CALL n10s.nsprefixes.add("owl", "http://www.w3.org/2002/07/owl#");
CALL n10s.nsprefixes.add("paysage", "http://paysage.mesri.fr/structures/");
CALL n10s.nsprefixes.add("wdt", "Http://www.wikidata.org/prop/direct/");
CALL n10s.nsprefixes.add("ppn", "http://www.abes.fr/entities/organizations/ppn/");
CALL n10s.nsprefixes.add("etats", "http://www.abes.fr/entities/etats/");
CALL n10s.nsprefixes.add("foaf", "http://xmlns.com/foaf/0.1");

// dedup organizations by name
MATCH (o:Organization)
WITH toLower(o.name) as name, COLLECT(o) AS ns
WHERE size(ns) > 1
CALL apoc.refactor.mergeNodes(ns) YIELD node
RETURN node;

// dedup relationships
match ()-[r]->() 
match (s)-[r]->(e) 
with s,e,type(r) as typ, tail(collect(r)) as coll 
foreach(x in coll | delete x)
