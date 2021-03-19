#!/usr/bin/env bash

# Ce script permet de peupler neo4j avec des fichiers contenant des instructions cypher (une instruction par ligne)
# et/ou des fichiers au format CSV
# ./load-data-to-neo4j.sh fichier_1.cypher fichier_2.cypher fichier_3.csv
# cat fichier_1.cypher | ./load-data-to-neo4j.sh
# cat fichier_1.cypher | ./load-data-to-neo4j.sh fichier_2.cypher fichier_3.csv

# Codes erreur :
#
# 2: Network error
# 3: I/O error (Failed to read file/File not found)
# 4: Payload serialization error

NETWORK_ERROR=2
IO_ERROR=3
PAYLOAD_SERIALIZATION_ERROR=4

BATCH_SIZE="${BATCH_SIZE:=100000}"
NEO4J_AUTH="${NEO4J_AUTH:=neo4j/s3cr3t}"
NEO4J_BASE_URL="${NEO4J_BASE_URL:=http://localhost:7474}"
NEO4J_USER="${NEO4J_AUTH%/*}"
NEO4J_PASSWORD="${NEO4J_AUTH#*/}"

# Produit à partir d'une suite d'instructions cypher (une instruction par ligne) une charge utile au format JSON 
# https://neo4j.com/docs/http-api/current/actions/query-format/
serialize_cypher_statements() {
    printf '%s\n' "$@" | jq --slurp -R '.' \
    | jq --slurp -c '{ statements: .[0] | split("\n") | map(select( length > 0 )) | map( { statement: . } ) }' \
    || >&2 echo "Failed to serialize data" && exit $PAYLOAD_SERIALIZATION_ERROR
};

# Produit une instruction cypher de chargement de fichier au format CSV `LOAD CSV FROM "file:///data.csv"`
# Le fichier doit être accessible par neo4j
# https://neo4j.com/docs/cypher-manual/current/clauses/load-csv/#load-csv-import-data-from-a-csv-file
build_load_from_csv_statement() {
    printf '%s\n' "$@" | sed -e 's/^/LOAD CSV FROM "file:\/\//' | sed -e 's/$/"/'
};

# Envoie la charge utile à neo4j
# https://neo4j.com/docs/http-api/current/actions/begin-and-commit-a-transaction-in-one-request/
send_payload() {
    echo "$1" | curl -sS --user $NEO4J_USER:$NEO4J_PASSWORD \
    --request POST \
    -H "Content-Type: application/json" \
    -d @- \
    $NEO4J_BASE_URL/db/neo4j/tx/commit || exit $NETWORK_ERROR
}

if [ -p /dev/stdin ]; then
    # Batch process n lines of a file
    # Taken from https://stackoverflow.com/a/41268405
    while mapfile -t -n $BATCH_SIZE ary && ((${#ary[@]})); do
        payload=$(serialize_cypher_statements "${ary[@]}")
        send_payload "$payload"
    done < /dev/stdin
fi

for file in $(find $@ -maxdepth 1 -type f)
do        
    if [ "${file: -7}" = ".cypher" ]; then
        # Batch process n lines of a file
        # Taken from https://stackoverflow.com/a/41268405
        while mapfile -t -n $BATCH_SIZE ary && ((${#ary[@]})); do
            payload=$(serialize_cypher_statements "${ary[@]}")
            send_payload "$payload"
        done < "$file" || exit $IO_ERROR

    elif [ "${file: -4}" = ".csv" ]; then
        if [ -n "$file" ]; then
            >&2 echo "File not found $file" && exit $IO_ERROR
        fi

        full_path=$(realpath "$file") # Attention avec Docker
        payload=$(serialize_cypher_statements "$(build_load_from_csv_statement "$full_path")")
        send_payload "$payload"
    fi
done
