#!/bin/bash

# MySQL Restore Script
# Restores a SQL dump backup to MySQL database

set -e

if [ -z "$1" ]; then
    echo "Usage: ./restore-mysql.sh <backup-file.sql>"
    echo ""
    echo "Example:"
    echo "  ./restore-mysql.sh backups/mysql-backup-20231225-120000.sql"
    echo "  ./restore-mysql.sh backups/mysql-backup-20231225-120000.sql.gz"
    exit 1
fi

BACKUP_FILE=$1

if [ ! -f "$BACKUP_FILE" ]; then
    echo "Error: Backup file not found: $BACKUP_FILE"
    exit 1
fi

echo "=========================================="
echo "MySQL Restore Script"
echo "=========================================="
echo ""
echo "Backup file: $BACKUP_FILE"
echo ""

# Check if MySQL container is running
if ! docker compose ps mysql-db | grep -q "Up"; then
    echo "Starting MySQL container..."
    docker compose up -d mysql
    echo "Waiting for MySQL to be ready..."
    sleep 10
fi

# Get MySQL credentials from .env or use defaults
if [ -f .env ]; then
    source .env
    ROOT_PASSWORD=${MYSQL_ROOT_PASSWORD:-rootpassword123}
else
    ROOT_PASSWORD="rootpassword123"
    echo "Warning: .env file not found, using default password"
fi

# Confirm before restoring
read -p "This will overwrite existing data. Continue? (yes/no): " confirm
if [ "$confirm" != "yes" ]; then
    echo "Restore cancelled."
    exit 0
fi

echo ""
echo "Restoring backup..."

# Check if file is compressed
if [[ $BACKUP_FILE == *.gz ]]; then
    echo "Decompressing and restoring..."
    gunzip -c $BACKUP_FILE | docker compose exec -T mysql mysql \
        -u root -p$ROOT_PASSWORD
else
    echo "Restoring..."
    docker compose exec -T mysql mysql \
        -u root -p$ROOT_PASSWORD \
        < $BACKUP_FILE
fi

if [ $? -eq 0 ]; then
    echo ""
    echo "✓ Restore completed successfully!"
    echo ""
    echo "Verifying databases..."
    docker compose exec mysql mysql \
        -u root -p$ROOT_PASSWORD \
        -e "SHOW DATABASES;"
else
    echo ""
    echo "✗ Restore failed!"
    exit 1
fi

