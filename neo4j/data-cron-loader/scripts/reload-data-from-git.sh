#!/usr/bin/env bash

# Ce script recharge les données de movies à partir d'un dépôt git

IO_ERROR=3
SCRIPT_ERROR=5

DATA_OUTPUT_DIR=/shared-data-to-load
DATA_TMP_DIR=/temp-shared-data-to-load

git config --global pull.rebase false

git -C "$DATA_TMP_DIR/" pull || (rm -rf "$DATA_TMP_DIR/*" && git clone "$GIT_REPO" "$DATA_TMP_DIR/") && \
rm -rf "$DATA_OUTPUT_DIR/*" && \
cp -r "$DATA_TMP_DIR/data/" "$DATA_OUTPUT_DIR/" || exit $IO_ERROR


   echo "MATCH (n) DETACH DELETE n" | /scripts/load-data-to-neo4j.sh \
&& echo 'CALL n10s.graphconfig.init({handleVocabUris: "IGNORE"})' | /scripts/load-data-to-neo4j.sh \
&& /scripts/load-data-to-neo4j.sh "$DATA_OUTPUT_DIR/data/*.cypher" || exit $SCRIPT_ERROR
