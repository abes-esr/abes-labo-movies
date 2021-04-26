#!/usr/bin/env bash

#
# This script is able to load cypher date into a neo4j instance thanks to the cypher-shell command
# it's possible to send cypher 2 way:
# - from stdin, ex: cat fichier_1.cypher | ./load-data-to-neo4j.sh
# - from files, ex: ./load-data-to-neo4j.sh fichier_1.cypher
# 

NEO4J_AUTH="${NEO4J_AUTH:=neo4j/s3cr3t}"
NEO4J_BOLT_URL="${NEO4J_BOLT_URL:=neo4j://localhost:7687}"
NEO4J_USER="${NEO4J_AUTH%/*}"
NEO4J_PASSWORD="${NEO4J_AUTH#*/}"

# load cypher from stdin
if [ -p /dev/stdin ]; then
    cat /dev/stdin | cypher-shell -a $NEO4J_BOLT_URL -u $NEO4J_USER -p $NEO4J_PASSWORD --format verbose
fi

# load cypher from files
LOAD_DATA_TO_NEO4Y_ARGS=$@
if [ "$LOAD_DATA_TO_NEO4Y_ARGS" != "" ]; then
    for file in $(find $@ -maxdepth 1 -type f)
    do
        cat $file | cypher-shell -a $NEO4J_BOLT_URL -u $NEO4J_USER -p $NEO4J_PASSWORD --format verbose
    done
fi
