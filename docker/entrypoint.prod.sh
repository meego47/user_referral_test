#!/bin/bash
set -eo pipefail

if [[ ! -f storage/.initialized ]]; then
    touch storage/.initialized;
    # laravel storage folder structure (v5.4+)
    mkdir -p storage/{app/{public,avatars,files},framework/{cache,sessions,testing,views},logs}

    chown -R nginx:nginx storage
fi

printenv > .env

su-exec nginx:nginx php artisan cache:clear && \
    su-exec nginx:nginx php artisan config:cache && \
    su-exec nginx:nginx php artisan storage:link && \
    su-exec nginx:nginx php artisan merax:avatars:generate && \
    su-exec nginx:nginx php artisan merax:room-avatars:generate
    #su-exec nginx:nginx php artisan route:cache
    #su-exec nginx:nginx php artisan passport:keys --force

chown -R nginx:nginx storage

/usr/bin/supervisord -n -c /etc/supervisor/supervisord.conf

exit 0
