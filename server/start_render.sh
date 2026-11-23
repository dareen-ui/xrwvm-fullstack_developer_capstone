#!/bin/sh
# Starts all services inside the single Render container.
set -e

# 1. MongoDB (local to the container)
mkdir -p /tmp/mongo-data
mongod --dbpath /tmp/mongo-data --bind_ip 127.0.0.1 --port 27017 \
  --wiredTigerCacheSizeGB 0.25 --quiet &
sleep 5

# 2. Node/Express dealers & reviews API (port 3030)
cd /app/server/database/data
MONGO_URL=mongodb://127.0.0.1:27017/ node ../app.js &

# 3. Sentiment analyzer (port 5050)
cd /app/server/djangoapp/microservices
NLTK_DATA=/app/server/djangoapp/microservices \
  python -m flask --app app run --host 127.0.0.1 --port 5050 &

# 4. Django (public port)
cd /app/server
python manage.py makemigrations djangoapp --noinput
python manage.py migrate --noinput
exec python manage.py runserver 0.0.0.0:${PORT:-8000} --noreload
