#!/bin/bash
# ============================================
# MySQL Full Backup + Upload to S3 (Docker)
# ============================================
# Dumps the running MySQL container and uploads
# the compressed backup to an AWS S3 bucket.
#
# Prerequisites:
#   - AWS CLI installed and configured (aws configure)
#   - IAM user/role with s3:PutObject on the bucket
# ============================================

set -euo pipefail

# -----------------------------
# CONFIGURATION
# -----------------------------
PROJECT_DIR="${PROJECT_DIR:-$(cd "$(dirname "$0")" && pwd)}"
BACKUP_DIR="${PROJECT_DIR}/backups"

DATE=$(date +"%Y-%m-%d_%H-%M-%S")
BACKUP_NAME="katariadb_full_backup_${DATE}.sql.gz"
BACKUP_FILE="${BACKUP_DIR}/${BACKUP_NAME}"

# S3 bucket and prefix (no trailing slash on bucket)
# Override via env: export S3_BUCKET="s3://your-bucket/mysql/backups"
S3_BUCKET="${S3_BUCKET:-s3://katariastoneworldinventory-db-backups-prod-ap-south-1/mysql/katariadb}"

MYSQL_SERVICE_NAME="mysql"

# -----------------------------
# INIT
# -----------------------------
cd "$PROJECT_DIR"
mkdir -p "$BACKUP_DIR"

echo "=========================================="
echo " MySQL FULL Backup + S3 Upload"
echo "=========================================="
echo ""

# -----------------------------
# LOAD MYSQL PASSWORD FROM .env
# -----------------------------
# Strip BOM (UTF-8 byte order mark) if present, then source — avoids "command not found" on line 1
MYSQL_ROOT_PASSWORD=""
if [ -f "${PROJECT_DIR}/.env" ]; then
    echo "Loading MySQL credentials from .env..."
    set +u
    source <(sed '1s/^\xEF\xBB\xBF//' "${PROJECT_DIR}/.env")
    set -u
fi

if [ -n "${MYSQL_ROOT_PASSWORD:-}" ]; then
    MYSQL_AUTH_ARGS="-u root -p${MYSQL_ROOT_PASSWORD}"
    echo "Using MySQL password from .env"
else
    MYSQL_AUTH_ARGS="-u root"
    echo "No MYSQL_ROOT_PASSWORD in .env — using root without password"
fi

# -----------------------------
# CHECK MYSQL CONTAINER
# -----------------------------
if ! docker compose ps "$MYSQL_SERVICE_NAME" 2>/dev/null | grep -q "Up"; then
    echo "MySQL container not running. Starting..."
    docker compose up -d "$MYSQL_SERVICE_NAME"
    echo "Waiting 15 seconds for MySQL to be ready..."
    sleep 15
fi

# -----------------------------
# CREATE BACKUP (ALL DATABASES, ALL TABLES — NO USERS/PASSWORDS)
# -----------------------------
# Excludes other grant tables (db, tables_priv, etc.); includes mysql.user.
echo "Creating full backup (all databases, all tables, including mysql.user)..."

docker compose exec -T "$MYSQL_SERVICE_NAME" mysqldump \
    $MYSQL_AUTH_ARGS \
    --all-databases \
    --routines \
    --triggers \
    --events \
    --single-transaction \
    --quick \
    --lock-tables=false \
    --ignore-table=mysql.db \
    --ignore-table=mysql.tables_priv \
    --ignore-table=mysql.columns_priv \
    --ignore-table=mysql.proxies_priv \
    --ignore-table=mysql.default_roles \
    --ignore-table=mysql.role_edges \
    --ignore-table=mysql.global_grants \
    --ignore-table=mysql.password_history \
| gzip > "$BACKUP_FILE"

if [ ! -s "$BACKUP_FILE" ]; then
    echo "Error: Backup file is empty."
    exit 1
fi

echo "Backup created: $BACKUP_FILE ($(du -h "$BACKUP_FILE" | cut -f1))"

# -----------------------------
# CHECK AWS CLI
# -----------------------------
if ! command -v aws &>/dev/null; then
    echo "Warning: AWS CLI not found. Skipping S3 upload."
    echo "Install: https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html"
    echo "Local backup kept at: $BACKUP_FILE"
    exit 0
fi

# -----------------------------
# UPLOAD TO S3
# -----------------------------
echo "Uploading backup to S3..."

if aws s3 cp "$BACKUP_FILE" "${S3_BUCKET}/$(basename "$BACKUP_FILE")" \
    --storage-class STANDARD \
    --sse AES256; then
    echo ""
    echo "✅ Backup and upload completed successfully!"
    echo "📦 Local:  $BACKUP_FILE"
    echo "📏 Size:   $(du -h "$BACKUP_FILE" | cut -f1)"
    echo "☁️  S3:     ${S3_BUCKET}/$(basename "$BACKUP_FILE")"
    echo ""
    echo "Includes: all databases, all tables, data, triggers, routines, events"
    echo "Includes: mysql.user; excludes other grant tables (db, tables_priv, etc.)"
else
    echo "❌ S3 upload failed. Local backup kept at: $BACKUP_FILE"
    exit 1
fi
