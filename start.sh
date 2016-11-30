#!/bin/sh

echo "Waiting 30 seconds before starting..."
sleep 30
echo "Starting..."

cat <<EOF > /app/.env
APP_ENV=local
APP_DEBUG=$APP_DEBUG
APP_KEY=$APP_KEY

DB_HOST=$DB_HOST
DB_DATABASE=$DB_DATABASE
DB_USERNAME=$DB_USERNAME
DB_PASSWORD=$DB_PASSWORD

CACHE_DRIVER=file
SESSION_DRIVER=file
EOF

chown www-data:www-data /app/.env
chmod -R 777 /app/storage

php artisan vendor:publish
php artisan migrate
php artisan db:seed

if [ $? -ne 0 ]; then
  exit 127
fi

exec /usr/bin/supervisord -l /logs/supervisord.log -j /var/run/supervisord.pid
