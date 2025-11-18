#!/bin/bash

CSV_URL="https://huggingface.co/api/resolve-cache/datasets/souljaboi6801/Expense_Mang/bbd3779836426e89b8c0175a66a702295b3c1ee1/transactions.csv?%2Fdatasets%2Fsouljaboi6801%2FExpense_Mang%2Fresolve%2Fmain%2Ftransactions.csv=&etag=%22610b4f34a0e3541f7f7dfe2f95375c86b31c0a02%22"
TEMP_FILE="/tmp/dataset.csv"
CLEAN_FILE="/tmp/dataset_clean.csv"
POSTGRES_USER="${POSTGRES_USER:-postgres}"
POSTGRES_DB="${POSTGRES_DB:-transactionsdb}"

if curl -L -f "$CSV_URL" -o "$TEMP_FILE" 2>/dev/null; then
    echo "Dataset downloaded successfully"
    
    FILE_SIZE=$(wc -c < "$TEMP_FILE")
    echo "File size: $FILE_SIZE bytes"
    
    echo "Preview:"
    head -n 3 "$TEMP_FILE"
    echo "..."
    python3 /docker-entrypoint-initdb.d/clean_csv.py
else
    echo "Could not download from Hugging Face."
    exit 1
fi

psql -U "$POSTGRES_USER" -d "$POSTGRES_DB" <<EOSQL
\copy transactions FROM '$CLEAN_FILE' WITH (FORMAT csv, HEADER true, DELIMITER ',');
EOSQL

echo "Loading data complete"
