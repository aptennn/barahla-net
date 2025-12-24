#!/usr/bin/env bash
set -o errexit

# Установка зависимостей
bundle config set --local without 'development test'
bundle install

# Создаем директорию для базы данных
mkdir -p /opt/render/project/src/db

# Создаем базу данных если ее нет
if [ ! -f "/opt/render/project/src/db/production.sqlite3" ]; then
  touch "/opt/render/project/src/db/production.sqlite3"
fi

# Миграции базы данных
bundle exec rake db:migrate

# Прекомпиляция ассетов
bundle exec rake assets:precompile
bundle exec rake assets:clean