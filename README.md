# abes-labo-movies

Depôt contenant les configurations et documentations des outils utilisés pour l'étude labo MOVies (début 2021).

En bref, cette étude interne à l'Abes vise à chercher comment modéliser au mieux la vie des établissements de l'ESR en s'attardant sur la vie des établissements expérimentaux. 

4 outils sont testés :
- [Neo4J](./README.md#Neo4J)
- [GraphDB](./README.md#GraphDB)
- [Wikibase](./README.md#Wikibase)
- [Virtuoso](./README.md#Virtuoso) (décision de ne plus investir sur cet outil au profit de [GraphDB](./README.md#GraphDB) le 22/03/2021)

L'outil JupyterLab permettant de faciliter l'execution des requetes SPARQL est egalement utilisé :
- [JupyterLab](./README.md#JupyterLab)

## Neo4J

Contient le neo4j utilisé par l'étude.

- L'URL du backoffice de neo4j : http://127.0.0.1:7474/

(remplacer 127.0.0.1 par le nom ou l'IP du serveur utilisé par l'étude).

### Installation

Pour lancer/créer le conteneur docker neo4j (en initialisant le mot de passe admin une première fois) :
```
cd /srv/abes-labo-movies/neo4j/
cp .env-dist .env
# modifier .env et ajuster le mot de passe souhaité
docker-compose up -d
```

### Données

Les [données sont chargées automatiquement toutes les nuites à 00h00](https://github.com/abes-esr/abes-labo-movies/blob/main/neo4j/data-cron-loader/tasks) depuis les fichiers cypher présents dans le répertoire suivant : [`data/*.cypher`](https://github.com/abes-esr/abes-labo-movies/tree/main/data).

A noter qu'il est possible de forcer le chargement du/des dernier(s) fichier(s) `data/*.cypher` en utilisant la commande suivante :
```
docker exec -it movies-neo4j-cron /scripts/reload-data-from-git.sh
```

Dans le cas où vous avez des fichiers cypher non présent sur github que vous souhaitez injecter (dans l'exemple suivant `000-neo4j-neosemantics-init.cypher`), vous pouvez lancer la commande suivante :
```
cat ./wikidata.cypher | docker exec -i movies-neo4j-cron /scripts/load-data-to-neo4j.sh
```

Dans le cas où vous souhaitez vider la base neo4j, lancez la commande suivante :
```
echo "MATCH (n) DETACH DELETE n;" | docker exec -i movies-neo4j-cron /scripts/load-data-to-neo4j.sh
```

## GraphDB

Contient le graphdb utilisé par l'étude.

- URL du backoffice de GrapDB : http://127.0.0.1:7200

(remplacer 127.0.0.1 par le nom ou l'IP du serveur utilisé par l'étude)

### Installation

Pour lancer/créer le conteneur docker graphdb :
- il est nécessaire de télécharger le zip du code de la free-edition depuis le site web https://www.ontotext.com/products/graphdb/graphdb-free/ en s'inscrivant sur le formulaire.
- il faut ensuite déposer le zip dans le répertoire `/home/devel/abes-labo-movies/graphdb/free-edition/`
- ensuite il faut builder et lancer le conteneur de cette manière :
```
cd /srv/abes-labo-movies/graphdb/
ls /srv/abes-labo-movies/graphdb/free-edition/graphdb-free-9.6.0-dist.zip # c'est ici que le zip doit être présent
cp .env-dist .env # modifier ensuite .env si nécessaire (à priori non nécessaire)
# la commande suivante va builder l'image docker et créer un conteneur en se basant sur cette image
docker-compose up -d
```

### Données

Les [données sont chargées automatiquement toutes les nuites à 00h00](https://github.com/abes-esr/abes-labo-movies/blob/main/graphdb/data-cron-loader/tasks) depuis les fichiers turtle (ttl) présents dans le répertoire suivant : [`data/*.ttl`](https://github.com/abes-esr/abes-labo-movies/tree/main/data).

A noter qu'il est possible de forcer le chargement du/des dernier(s) fichier(s) `data/*.ttl` en utilisant la commande suivante :
```
docker exec -it movies-graphdb-cron /scripts/reload-data-from-git.sh
```


## Wikibase

Une instance SaaS est disponible ici : https://abes-labo-movies.wiki.opencura.com/wiki/Main_Page (merci [WBStack](https://www.wbstack.com/))

En local nous avons également une instance pour l'étude via docker :

- L'URL du wikibase : FIXME

(remplacer 127.0.0.1 par le nom ou l'IP du serveur utilisé par l'étude).

### Installation

Pour lancer/créer les conteneurs docker wikibase :
```
cd /srv/abes-labo-movies/wikibase/
cp .env-dist .env
# modifier .env et ajuster les variables (dont le mot de passe)
docker-compose up -d
```

## Virtuoso

Contient le virtuoso utilisé par l'étude (remplacer 127.0.0.1 par le nom ou l'IP du serveur utilisé par l'étude).

- L'URL du sparql de virtuoso : http://127.0.0.1:8890/sparql/
- L'URL du backoffice : http://127.0.0.1:8890/

### Installation

Pour lancer/créer le conteneur docker virtuoso (en initialisant le mot de passe admin une première fois) :
```
cd /srv/abes-labo-movies/virtuoso/
cp .env-dist .env
# modifier .env et ajuster le mot de passe souhaité
docker-compose up -d
```

### Paramétrages

L'image docker utilisée est la suivante : https://hub.docker.com/r/openlink/virtuoso-opensource-7

- Les paramètres sont réglés principalement dans le fichier `virtuoso.ini` : https://github.com/abes-esr/abes-labo-movies/blob/main/virtuoso/virtuoso-movies.ini
- Ces paramètres critiques `NumberOfBuffers` et `MaxDirtyBuffers` peuvent être réglés ici : https://github.com/abes-esr/abes-labo-movies/blob/main/virtuoso/virtuoso-movies.ini#L110-L114

Remarque : une fois un paramètre modifié, il est nécessaire de relancer le conteneur docker pour que le paramètre soit pris en compte.

## JupyterLab

Contient une instance de [jupyter/minimal-notebook](https://hub.docker.com/r/jupyter/minimal-notebook) (image offocielle gérée par [jupyter/docker-stacks](https://github.com/jupyter/docker-stacks)) avec un [kernel SPARQL](https://github.com/paulovn/sparql-kernel) préinstallé. Le notebook [sparql.ipynb](todo) spécifique à l'étude MOVies est directement injecté dans cette instance.

- L'URL de l'instance JupyterLab : http://127.0.0.1:8888/

### Installation

Pour lancer/créer le conteneur docker jupyterlab :
```
cd /srv/abes-labo-movies/jupyterlab/
cp .env-dist .env
# modifier .env et ajuster le mot de passe souhaité (token)
docker-compose up -d
```

### Paramétrage

Les paramètres de jupyterlab que l'on peut injecter sont décrits ici : https://jupyter-notebook.readthedocs.io/en/stable/config.html#options
Nous en injectons un dans notre docker-compose.yml : `--NotebookApp.allow_remote_access` qui permet d'acceder à l'application depuis tout le réseau.

Le second paramètre que nous personnalisons est JUPYTER_TOKEN qui lui est réglable dans `.env` au moment de l'installation.


## Aide docker

Pour regarder les logs systèmes du conteneur (100 dernières lignes) :
```
docker-compose logs --tail=100
```

Pour stopper le conteneur docker :
```
docker-compose stop
```
