# MySQL Volume Migration Guide

This guide explains how to backup, export, and attach MySQL volumes to other containers.

## Current Setup

Your MySQL volume is named: `katariastoneworldadmin_mysql_data`

## Method 1: Direct Volume Attachment (Same Docker Host)

### Step 1: Identify the Volume

```bash
# List all volumes
docker volume ls

# Inspect the MySQL volume
docker volume inspect katariastoneworldadmin_mysql_data
```

### Step 2: Stop Current MySQL Container

```bash
docker compose down
# OR
docker stop mysql-db
```

### Step 3: Create New MySQL Container with Existing Volume

```bash
docker run -d \
  --name new-mysql-container \
  -v katariastoneworldadmin_mysql_data:/var/lib/mysql \
  -e MYSQL_ROOT_PASSWORD=rootpassword123 \
  -e MYSQL_DATABASE=katariastoneworld \
  -e MYSQL_USER=katariauser \
  -e MYSQL_PASSWORD=katariapass123 \
  -p 3306:3306 \
  mysql:8.0
```

**Important**: Use the same MySQL version and same credentials for compatibility.

## Method 2: Backup and Restore (Cross-Host Migration)

### Step 1: Backup the Volume

#### Option A: Using Docker Volume Backup

```bash
# Create a backup of the volume
docker run --rm \
  -v katariastoneworldadmin_mysql_data:/data \
  -v $(pwd):/backup \
  alpine tar czf /backup/mysql-backup-$(date +%Y%m%d-%H%M%S).tar.gz -C /data .

# This creates: mysql-backup-YYYYMMDD-HHMMSS.tar.gz in current directory
```

#### Option B: Using MySQL Dump (Recommended - More Reliable)

```bash
# Start MySQL container if not running
docker compose up -d mysql

# Create SQL dump
docker compose exec mysql mysqldump \
  -u root -prootpassword123 \
  --all-databases \
  --routines \
  --triggers \
  > mysql-backup-$(date +%Y%m%d-%H%M%S).sql

# Or dump specific database
docker compose exec mysql mysqldump \
  -u root -prootpassword123 \
  katariastoneworld \
  > katariastoneworld-backup-$(date +%Y%m%d-%H%M%S).sql
```

### Step 2: Transfer Backup to New Host

```bash
# Using SCP
scp mysql-backup-*.tar.gz user@new-host:/path/to/destination/

# Or SQL dump
scp mysql-backup-*.sql user@new-host:/path/to/destination/
```

### Step 3: Restore on New Host

#### If using Volume Backup:

```bash
# Create new volume
docker volume create new_mysql_data

# Restore from backup
docker run --rm \
  -v new_mysql_data:/data \
  -v $(pwd):/backup \
  alpine sh -c "cd /data && tar xzf /backup/mysql-backup-YYYYMMDD-HHMMSS.tar.gz"

# Create MySQL container with restored volume
docker run -d \
  --name mysql-container \
  -v new_mysql_data:/var/lib/mysql \
  -e MYSQL_ROOT_PASSWORD=rootpassword123 \
  -e MYSQL_DATABASE=katariastoneworld \
  -e MYSQL_USER=katariauser \
  -e MYSQL_PASSWORD=katariapass123 \
  -p 3306:3306 \
  mysql:8.0
```

#### If using SQL Dump (Recommended):

```bash
# Create and start new MySQL container
docker run -d \
  --name mysql-container \
  -e MYSQL_ROOT_PASSWORD=rootpassword123 \
  -e MYSQL_DATABASE=katariastoneworld \
  -e MYSQL_USER=katariauser \
  -e MYSQL_PASSWORD=katariapass123 \
  -p 3306:3306 \
  mysql:8.0

# Wait for MySQL to be ready (about 10-20 seconds)
sleep 20

# Restore the dump
docker exec -i mysql-container mysql \
  -u root -prootpassword123 \
  < mysql-backup-YYYYMMDD-HHMMSS.sql

# Or restore specific database
docker exec -i mysql-container mysql \
  -u root -prootpassword123 \
  katariastoneworld \
  < katariastoneworld-backup-YYYYMMDD-HHMMSS.sql
```

## Method 3: Using Docker Compose with Existing Volume

### Step 1: Update docker-compose.yml

```yaml
services:
  mysql:
    image: mysql:8.0
    container_name: mysql-db
    volumes:
      - katariastoneworldadmin_mysql_data:/var/lib/mysql  # Use existing volume
      # OR create new volume:
      # - mysql_data:/var/lib/mysql
    environment:
      MYSQL_ROOT_PASSWORD: ${MYSQL_ROOT_PASSWORD}
      MYSQL_DATABASE: ${MYSQL_DATABASE}
      MYSQL_USER: ${MYSQL_USER}
      MYSQL_PASSWORD: ${MYSQL_PASSWORD}
    networks:
      - app-network

volumes:
  katariastoneworldadmin_mysql_data:  # Reference existing volume
  # OR
  # mysql_data:  # Create new volume
```

### Step 2: Start Services

```bash
docker compose up -d
```

## Method 4: Clone/Copy Volume to New Volume

### Step 1: Create Backup Container

```bash
# Create a temporary container to copy data
docker run --rm \
  -v katariastoneworldadmin_mysql_data:/source:ro \
  -v new_mysql_volume:/destination \
  alpine sh -c "cp -a /source/. /destination/"
```

### Step 2: Use New Volume

```bash
docker run -d \
  --name mysql-container \
  -v new_mysql_volume:/var/lib/mysql \
  -e MYSQL_ROOT_PASSWORD=rootpassword123 \
  -e MYSQL_DATABASE=katariastoneworld \
  -e MYSQL_USER=katariauser \
  -e MYSQL_PASSWORD=katariapass123 \
  -p 3306:3306 \
  mysql:8.0
```

## Best Practices

### 1. Always Backup Before Migration

```bash
# Quick backup script
#!/bin/bash
BACKUP_DIR="./backups"
mkdir -p $BACKUP_DIR

docker compose exec mysql mysqldump \
  -u root -prootpassword123 \
  --all-databases \
  --routines \
  --triggers \
  --single-transaction \
  > $BACKUP_DIR/mysql-backup-$(date +%Y%m%d-%H%M%S).sql

echo "Backup saved to $BACKUP_DIR/"
```

### 2. Verify Data Integrity

```bash
# After restoring, verify tables
docker compose exec mysql mysql \
  -u root -prootpassword123 \
  -e "USE katariastoneworld; SHOW TABLES;"

# Check row counts
docker compose exec mysql mysql \
  -u root -prootpassword123 \
  -e "USE katariastoneworld; SELECT COUNT(*) FROM your_table;"
```

### 3. Use Same MySQL Version

Always use the same MySQL version when migrating volumes directly:
- Check current version: `docker compose exec mysql mysql --version`
- Use same version in new container

### 4. Preserve Permissions

When copying volumes, ensure file permissions are preserved:
```bash
# Use -a flag for archive mode (preserves permissions)
cp -a /source/. /destination/
```

## Troubleshooting

### Issue: Permission Denied

```bash
# Fix permissions
docker run --rm \
  -v katariastoneworldadmin_mysql_data:/data \
  alpine chown -R 999:999 /data
```

### Issue: MySQL Won't Start After Migration

1. Check MySQL logs:
   ```bash
   docker logs mysql-container
   ```

2. Ensure same MySQL version:
   ```bash
   docker compose exec mysql mysql --version
   ```

3. Verify volume mount:
   ```bash
   docker inspect mysql-container | grep -A 10 Mounts
   ```

### Issue: Data Not Appearing

1. Verify volume is attached:
   ```bash
   docker volume inspect katariastoneworldadmin_mysql_data
   ```

2. Check if data exists in volume:
   ```bash
   docker run --rm -v katariastoneworldadmin_mysql_data:/data alpine ls -la /data
   ```

## Quick Reference Commands

```bash
# List all volumes
docker volume ls

# Inspect volume
docker volume inspect katariastoneworldadmin_mysql_data

# Remove volume (CAUTION: Deletes all data)
docker volume rm katariastoneworldadmin_mysql_data

# Backup volume
docker run --rm -v katariastoneworldadmin_mysql_data:/data -v $(pwd):/backup alpine tar czf /backup/mysql-backup.tar.gz -C /data .

# Restore volume
docker run --rm -v new_mysql_data:/data -v $(pwd):/backup alpine tar xzf /backup/mysql-backup.tar.gz -C /data

# MySQL dump
docker compose exec mysql mysqldump -u root -prootpassword123 --all-databases > backup.sql

# MySQL restore
docker compose exec -T mysql mysql -u root -prootpassword123 < backup.sql
```

## Recommended Approach

**For Production**: Use MySQL dump method (Method 2, Option B) - most reliable and portable.

**For Development**: Direct volume attachment (Method 1) - fastest.

**For Backup**: Regular MySQL dumps scheduled via cron.

