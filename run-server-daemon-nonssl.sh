#!/bin/sh
docker run -d --name=jupyter-scipy -p 8888:8888 -e JUPYTER_ENABLE_LAB=yes \
-v "$HOME"/Yandex.Disk/Учеба:/home/jovyan/work/Yandex \
-v "$HOME"/Sources:/home/jovyan/work/Sources \
-v "$HOME"/.ssh:/home/jovyan/.ssh \
jupyter-docker-scipy start.sh jupyter lab \
--NotebookApp.password='sha1:eadc47330625:65d799b65d21048a4f96c12d862514466324f0e3' \
