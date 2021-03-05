#!/usr/bin/env bash

# Ce script recharge les données de movies à partir d'un dépôt git

IO_ERROR=3
SCRIPT_ERROR=5

if [ ! -d "$DATA_TMP_DIR" ]; then
    git clone "$GIT_REPO" "$DATA_TMP_DIR"
else
    git -C "$DATA_TMP_DIR" pull || rm -rf "$DATA_TMP_DIR" && git clone "$GIT_REPO" "$DATA_TMP_DIR"
fi

rm -rf "$DATA_OUTPUT_DIR" || exit $IO_ERROR
cp -r "$DATA_TMP_DIR"/* "$DATA_OUTPUT_DIR" || exit $IO_ERROR

echo "MATCH (n) DETACH DELETE n" | /scripts/load-data-to-neo4j.sh \
    && /scripts/load-data-to-neo4j.sh "$DATA_OUTPUT_DIR"/data/*cypher || exit $SCRIPT_ERROR
