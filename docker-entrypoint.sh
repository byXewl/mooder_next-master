#!/bin/bash

set -eo pipefail
wait-for-it "${DB_HOST}:${DB_PORT}" -t 0 -- echo "Postgres is up - executing command"

service nginx restart

python manage.py collectstatic --noinput && python manage.py migrate && python manage.py initadmin

# python manage.py runserver 0.0.0.0:8080 --insecure
# 上面不高效，用下面服务器启动高效
exec gunicorn -w 2 -k gevent -b 0.0.0.0:8080 mooder.wsgi
