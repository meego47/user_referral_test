#!/bin/bash
set -eo pipefail

if [[ ! -f ".env" ]]
then
    echo "Error: .env not found."
    cp .env.example .env
fi

#if [[ ! -f storage/.initialized ]]; then
#    touch storage/.initialized;
#    # laravel storage folder structure (v5.4+)
#    mkdir -p storage/{app/public,framework/{cache,sessions,testing,views},logs}
#
#    chown -R nginx:nginx storage
#    chmod -R ug+rwx storage bootstrap/cache
#fi

#su-exec nginx:nginx composer install && php artisan config:cache && php artisan view:clear
su-exec nginx:nginx composer install && php artisan storage:link
/usr/bin/supervisord -n -c /etc/supervisor/supervisord.conf

exit 0
