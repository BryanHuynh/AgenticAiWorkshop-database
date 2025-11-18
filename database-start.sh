#!/bin/bash

if [ -f .env ]; then
    export $(cat .env | grep -v '^#' | xargs)
fi

echo ""
echo "Configuration:"
echo "   PostgreSQL: ${POSTGRES_HOST}:${POSTGRES_PORT}"
echo "   Database:   ${POSTGRES_DB}"
echo "   User:       ${POSTGRES_USER}"
echo ""

docker-compose up -d

echo "⏳ Waiting for services..."
sleep 20

# Check database
ROW_COUNT=$(docker exec ${POSTGRES_HOST} psql -U ${POSTGRES_USER} -d ${POSTGRES_DB} -tAc "SELECT COUNT(*) FROM transactions;" 2>/dev/null || echo "0")

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Workshop Environment Ready!"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "Services:"
echo "   PostgreSQL:    localhost:${POSTGRES_PORT}"
echo "                  Server: Auto-configured ✨"
echo "   Ollama API:    http://localhost:11434"
echo "   Ollama UI:     http://localhost:3000"
echo ""
echo "Database:"
echo "   Host:          ${POSTGRES_HOST}"
echo "   Database:      ${POSTGRES_DB}"
echo "   Records:       $ROW_COUNT transactions"
echo ""
