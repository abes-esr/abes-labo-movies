#!/usr/bin/env bash

# Ce script recharge les donnees GraphDB de movies a partir d'un depot git

echo "--> $(date '+%Y-%m-%d %H:%M:%S') - Rechargement des donnees graphdb de movies à partir de $GIT_REPO (data/*.ttl)" 

IO_ERROR=3
SCRIPT_ERROR=5

DATA_TMP_DIR=/temp-shared-data-to-load

git config --global pull.rebase false

git -C "$DATA_TMP_DIR/" pull || (rm -rf "$DATA_TMP_DIR/*" && git clone "$GIT_REPO" "$DATA_TMP_DIR/") || exit $IO_ERROR

# on enchaine avec le chargement du dump dans graphdb
/scripts/load-data-to-graphdb.sh
