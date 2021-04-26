//
// Code inspiré de https://towardsdatascience.com/traveling-tourist-part-1-import-wikidata-to-neo4j-with-neosemantics-library-f80235f40dc5
// TODO: l'adapter sur le sparql wikibase de l'etude (WIP)

CALL n10s.graphconfig.init({handleVocabUris: "IGNORE"});
CREATE CONSTRAINT n10s_unique_uri ON (r:Resource) ASSERT r.uri IS UNIQUE;

CALL n10s.rdf.import.fetch("http://labo-vm-2.v202.abes.fr:8282/proxy/wdqs/bigdata/namespace/wdq/sparql?query=" + apoc.text.urlencode('
PREFIX sch: <http://schema.org/>
PREFIX prop: <http://labo-vm-2.v202.abes.fr:8181/prop/direct/>
PREFIX entity: <http://labo-vm-2.v202.abes.fr:8181/entity/>

CONSTRUCT{ ?item1 a sch:Organization;
              sch:name ?org1Name;
              sch:EST_MEMBRE_CONSTITUTIF ?epe1.
           ?item2 a sch:Organization;
              sch:name ?org2Name;
              sch:EST_MEMBRE_NON_CONSTITUTIF ?epe2.
            ?epe1 a sch:OrganizationEPE;
              sch:name ?epe1Name.
            ?epe2 a sch:OrganizationEPE;
              sch:name ?epe2Name.
         }
WHERE {
        ?item1 prop:P3 ?epe1 .
        ?item2 prop:P1 ?epe2 .
        ?item1 rdfs:label ?org1Name .
          filter(lang(?org1Name) = "fr")
        ?item2 rdfs:label ?org2Name .
          filter(lang(?org2Name) = "fr")
        ?epe1 rdfs:label ?epe1Name .
          filter(lang(?epe1Name) = "fr")
        ?epe2 rdfs:label ?epe2Name .
          filter(lang(?epe2Name) = "fr")
      } limit 100

'), "JSON-LD", { headerParams: { Accept: "application/ld+json"} , handleVocabUris: "IGNORE"} );
