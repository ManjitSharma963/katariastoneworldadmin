#!/bin/bash

# MySQL Volume Migration Script
# Migrates MySQL volume to another container

set -e

SOURCE_VOLUME="katariastoneworldadmin_mysql_data"
DEST_VOLUME="new_mysql_data"

echo "=========================================="
echo "MySQL Volume Migration Script"
echo "=========================================="
echo ""
echo "Source volume: $SOURCE_VOLUME"
echo "Destination volume: $DEST_VOLUME"
echo ""

# Check if source volume exists
if ! docker volume inspect $SOURCE_VOLUME &> /dev/null; then
    echo "Error: Source volume '$SOURCE_VOLUME' not found!"
    echo ""
    echo "Available volumes:"
    docker volume ls
    exit 1
fi

# Check if destination volume already exists
if docker volume inspect $DEST_VOLUME &> /dev/null; then
    read -p "Destination volume '$DEST_VOLUME' already exists. Overwrite? (yes/no): " confirm
    if [ "$confirm" != "yes" ]; then
        echo "Migration cancelled."
        exit 0
    fi
    echo "Removing existing destination volume..."
    docker volume rm $DEST_VOLUME
fi

echo "Creating destination volume..."
docker volume create $DEST_VOLUME

echo ""
echo "Copying data from source to destination..."
echo "This may take a few minutes depending on data size..."

# Copy data using temporary container
docker run --rm \
    -v $SOURCE_VOLUME:/source:ro \
    -v $DEST_VOLUME:/destination \
    alpine sh -c "cd /source && cp -a . /destination/"

if [ $? -eq 0 ]; then
    echo ""
    echo "✓ Volume migration completed successfully!"
    echo ""
    echo "Source volume: $SOURCE_VOLUME"
    echo "Destination volume: $DEST_VOLUME"
    echo ""
    echo "To use the new volume in docker-compose.yml, update:"
    echo "  volumes:"
    echo "    - $DEST_VOLUME:/var/lib/mysql"
    echo ""
    echo "Or create a new MySQL container:"
    echo "  docker run -d \\"
    echo "    --name mysql-container \\"
    echo "    -v $DEST_VOLUME:/var/lib/mysql \\"
    echo "    -e MYSQL_ROOT_PASSWORD=rootpassword123 \\"
    echo "    -e MYSQL_DATABASE=katariastoneworld \\"
    echo "    -p 3306:3306 \\"
    echo "    mysql:8.0"
else
    echo ""
    echo "✗ Migration failed!"
    exit 1
fi

