#!/bin/sh
# Остановка контейнера и удаление диска
docker container stop jupyter-scipy
docker image rm jupyter-docker-scipy
