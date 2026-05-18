#!/bin/bash
set -e

TIMESTAMP=$(date +%Y%m%d%H%M%S)
BACKUP_FILE="backup_${TIMESTAMP}.sql"
S3_PATH="s3://bucket-codigo-backup-herber/villegas/database-jenkins/${TIMESTAMP}/"

echo "Iniciando backup - Driver: $MY_DATABASE_DRIVER - DB: $DB_NAME"

if [ "$MY_DATABASE_DRIVER" = "mysql" ]; then
    mysqldump -h "$DB_HOST" -P "$DB_PORT" -u "$DB_USER_NAME" -p"$DB_PASSWORD" "$DB_NAME" > /tmp/$BACKUP_FILE

elif [ "$MY_DATABASE_DRIVER" = "postgres" ]; then
    PGPASSWORD="$DB_PASSWORD" pg_dump -h "$DB_HOST" -p "$DB_PORT" -U "$DB_USER_NAME" "$DB_NAME" > /tmp/$BACKUP_FILE

elif [ "$MY_DATABASE_DRIVER" = "mongo" ]; then
    mongodump --host "$DB_HOST" --port "$DB_PORT" \
        --username "$DB_USER_NAME" --password "$DB_PASSWORD" \
        --db "$DB_NAME" --archive=/tmp/$BACKUP_FILE
fi

echo "Subiendo backup a: ${S3_PATH}${BACKUP_FILE}"
aws s3 cp /tmp/$BACKUP_FILE "${S3_PATH}${BACKUP_FILE}"

echo "Backup completado exitosamente: ${S3_PATH}${BACKUP_FILE}"
