#!/bin/sh
docker run -d --name=jupyter -p 9999:8888 -e JUPYTER_ENABLE_LAB=yes \
-v "$HOME"/Yandex.Disk/Учеба:/home/jovyan/work \
-v "$HOME"/Sources:/home/jovyan/work/Sources \
-v "$HOME"/.ssh:/home/jovyan/.ssh \
-v /etc/letsencrypt/live/home.dementiev.info/fullchain.pem:/etc/ssl/fullchain.pem \
-v /etc/letsencrypt/live/home.dementiev.info/privkey.pem:/etc/ssl/privkey.pem \
jupyter-docker-scipy start.sh jupyter lab \
--NotebookApp.password='sha1:eadc47330625:65d799b65d21048a4f96c12d862514466324f0e3' \
--NotebookApp.certfile=/etc/ssl/fullchain.pem \
--NotebookApp.keyfile=/etc/ssl/privkey.pem
