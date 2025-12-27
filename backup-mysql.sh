#!/bin/bash

# MySQL Backup Script
# Creates a SQL dump backup of MySQL database

set -e

BACKUP_DIR="./backups"
TIMESTAMP=$(date +%Y%m%d-%H%M%S)
BACKUP_FILE="$BACKUP_DIR/mysql-backup-$TIMESTAMP.sql"

# Create backup directory if it doesn't exist
mkdir -p $BACKUP_DIR

echo "=========================================="
echo "MySQL Backup Script"
echo "=========================================="
echo ""

# Check if MySQL container is running
if ! docker compose ps mysql-db | grep -q "Up"; then
    echo "Starting MySQL container..."
    docker compose up -d mysql
    echo "Waiting for MySQL to be ready..."
    sleep 10
fi

echo "Creating backup..."
echo "Backup file: $BACKUP_FILE"
echo ""

# Get MySQL credentials from .env or use defaults
if [ -f .env ]; then
    source .env
    ROOT_PASSWORD=${MYSQL_ROOT_PASSWORD:-rootpassword123}
else
    ROOT_PASSWORD="rootpassword123"
    echo "Warning: .env file not found, using default password"
fi

# Create backup
docker compose exec -T mysql mysqldump \
    -u root -p$ROOT_PASSWORD \
    --all-databases \
    --routines \
    --triggers \
    --single-transaction \
    --quick \
    --lock-tables=false \
    > $BACKUP_FILE

if [ $? -eq 0 ]; then
    # Compress backup
    echo "Compressing backup..."
    gzip $BACKUP_FILE
    BACKUP_FILE="${BACKUP_FILE}.gz"
    
    echo ""
    echo "✓ Backup completed successfully!"
    echo "  File: $BACKUP_FILE"
    echo "  Size: $(du -h $BACKUP_FILE | cut -f1)"
    echo ""
    echo "To restore this backup, use:"
    echo "  ./restore-mysql.sh $BACKUP_FILE"
else
    echo "✗ Backup failed!"
    exit 1
fi

