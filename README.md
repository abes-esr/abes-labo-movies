# abes-labo-movies

Depôt contenant les configurations et documentations des outils utilisés pour l'étude labo MOVies (début 2021).

En bref, cette étude interne à l'Abes vise à chercher comment modéliser au mieux la vie des établissements de l'ESR.

## virtuoso

Contient le virtuoso utilisé par l'étude (remplacer 127.0.0.1 par le nom ou l'IP du serveur utilisé par l'étude).

- L'URL du sparql de virtuoso : http://127.0.0.1:8890/sparql/
- L'URL du backoffice : http://127.0.0.1:8890/

L'image docker utilisée est la suivante : https://hub.docker.com/r/openlink/virtuoso-opensource-7

- Les paramètres sont réglés principalement dans le fichier `virtuoso.ini` : https://github.com/abes-esr/abes-labo-movies/blob/main/virtuoso/virtuoso-movies.ini
- Ces paramètres critiques `NumberOfBuffers` et `MaxDirtyBuffers` peuvent être réglés ici : https://github.com/abes-esr/abes-labo-movies/blob/main/virtuoso/virtuoso-movies.ini#L110-L114

Remarque : une fois un paramètre modifié, il est nécessaire de relancer le conteneur docker pour que le paramètre soit pris en compte.

Pour lancer/créer le conteneur docker virtuoso (en initialisant le mot de passe admin une première fois) :
```
cd /home/devel/abes-labo-movies/virtuoso/
cp .env-dist .env
# modifier .env et ajuster le mot de passe souhaité
docker-compose up -d
```

Pour regarder les logs systèmes du conteneur docker virtuoso (100 dernières lignes) :
```
docker-compose logs --tail=100
```

Pour stopper le conteneur docker virtuoso :
```
docker-compose stop
```

## neo4j

Contient le neo4j utilisé par l'étude (remplacer 127.0.0.1 par le nom ou l'IP du serveur utilisé par l'étude).

- L'URL du backoffice de neo4j : http://127.0.0.1:7474/

Pour lancer/créer le conteneur docker neo4j (en initialisant le mot de passe admin une première fois) :
```
cd /home/devel/abes-labo-movies/neo4j/
cp .env-dist .env
# modifier .env et ajuster le mot de passe souhaité
docker-compose up -d
```

Pour regarder les logs systèmes du conteneur docker neo4j (100 dernières lignes) :
```
docker-compose logs --tail=100
```

Pour stopper le conteneur docker neo4j :
```
docker-compose stop
```

## graphdb

FIXME

## wikibase

FIXME voir si on part sur une installation locale ou une installation saas
