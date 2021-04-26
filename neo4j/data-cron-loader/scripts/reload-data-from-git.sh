#!/usr/bin/env bash

#
# This script is executed periodically (cron)
# it tries to git clone/pull new cypher file from a git repository (ex: github)
# then it empty all the data in neo4j and loads fresh 
# data from the *.cypher files located in the /cypher-data-to-load/ folder
#

# Git clone/pull stuff
if [ "$GIT_REPO" == "" ]; then
        echo "--> $(date '+%Y-%m-%d %H:%M:%S') - Rechargement des donnees neo4j de movies a partir de $GIT_REPO (data/*.cypher)" 
	if [ ! -d /git-clone-cypher-data-to-load/.git/ ]; then
		rm -rf /git-clone-cypher-data-to-load/*
		git config --global pull.rebase false
		git clone "$GIT_REPO" /git-clone-cypher-data-to-load/
	else
		git -C /git-clone-cypher-data-to-load/ pull
	fi
	rm -rf /cypher-data-to-load/*
	cp -r /git-clone-cypher-data-to-load/data/* /cypher-data-to-load/
else
        echo "--> $(date '+%Y-%m-%d %H:%M:%S') - Rechargement des donnees neo4j de movies a partir de /cypher-data-to-load/*.cypher" 
fi

# Neo4j cleaning stuff
echo "-> Cleaning Neo4j base"
echo "MATCH (n) DETACH DELETE n" | /scripts/load-data-to-neo4j.sh
echo ""
echo "-> Neo4j base cleaned"

# Cypher loading stuff
for CYPHER_FILE in $(ls /cypher-data-to-load/*.cypher)
do
	echo "-> Loading $CYPHER_FILE"
	/scripts/load-data-to-neo4j.sh "$CYPHER_FILE"
	echo ""
	echo "-> $CYPHER_FILE loaded"
done

