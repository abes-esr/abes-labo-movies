#!/usr/bin/env bash
#
# Ce script va charger les données au format turtle dans l'instance GraphDB données en paramètre
# Il utilise loadrdf qui est une commande proposée par graphdb et qui va charger de façon très rapide les données
# dans l'instance GraphDB. Pour ce faire il doit stopper l'instance GraphDB avant de lancer le chargement.
# C'est pour cela que le conteneur movies-graphdb est stoppé juste avant de lancer le chargement.
#

# Verifie si l'instance GraphDB est eteinte, si ce n'est pas le cas on
# la stoppe pour pouvoir charger les donnees avec loadrdf
docker container inspect movies-graphdb >/dev/null
RUNNING_GRAPHDB_CONTAINER=$?
if [ $RUNNING_GRAPHDB_CONTAINER == 0 ]; then
  docker stop movies-graphdb
fi


# C'est la partie important, c'est la que le chargement depuis un fichier turtle (ttl) se passe
loadrdf -f -c /root/config-graphdb-movies-repo.ttl -m parallel /temp-shared-data-to-load/data/*.ttl




# On relance l'instance GraphDB si cette derniere etait allumee avant le chargement loadrdf
if [ $RUNNING_GRAPHDB_CONTAINER == 0 ]; then
  docker start movies-graphdb
fi

