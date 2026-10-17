#!/usr/bin/env bash
# Start Laravel on Roxyon. Roxyon runs this from the current release with PORT and HOST set, after
# `composer install --no-dev`. storage/ is listed in .rxshared, so it survives deploys: the app key,
# the SQLite database, sessions, cache and uploads live there.
set -euo pipefail

mkdir -p storage/app/private storage/framework/{cache/data,sessions,views} storage/logs

# APP_KEY: set your own with `roxyon env set APP_KEY=base64:...`; otherwise one is made once and kept.
if [ -z "${APP_KEY:-}" ]; then
    KEY_FILE=storage/app/private/.app_key
    [ -s "$KEY_FILE" ] || (umask 077; php -r 'echo "base64:".base64_encode(random_bytes(32));' > "$KEY_FILE")
    APP_KEY="$(cat "$KEY_FILE")"
    export APP_KEY
fi

# Production defaults; anything set with `roxyon env set` wins.
export APP_ENV="${APP_ENV:-production}"
export APP_DEBUG="${APP_DEBUG:-false}"
export LOG_CHANNEL="${LOG_CHANNEL:-stderr}"          # shows up in `roxyon logs`
export PHP_CLI_SERVER_WORKERS="${PHP_CLI_SERVER_WORKERS:-4}"

# SQLite in storage/ unless you point DB_* at a Roxyon MySQL database.
if [ "${DB_CONNECTION:-sqlite}" = "sqlite" ]; then
    export DB_CONNECTION=sqlite
    export DB_DATABASE="${DB_DATABASE:-$PWD/storage/app/private/database.sqlite}"
    [ -f "$DB_DATABASE" ] || touch "$DB_DATABASE"
fi

php artisan migrate --force --no-interaction
php artisan config:cache
php artisan route:cache
php artisan view:cache

exec php artisan serve --host="${HOST:-127.0.0.1}" --port="${PORT:-8000}" --no-reload
