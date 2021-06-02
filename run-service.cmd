@rem Запуск контейнера
@REM set CurrDir=('cd')
docker run -d --name=jupyter-scipy ^
-p 8898:8888 -e JUPYTER_ENABLE_LAB=yes ^
--restart=unless-stopped ^
-v /c/ddmitry/YandexDisk/Учеба:/home/jovyan/work/Yandex  ^
-v /c/ddmitry/Sources:/home/jovyan/work/Sources ^
-v jupyter-conda-envs:/home/jovyan/conda-envs ^
-v jupyter-conda-soursec:/home/jovyan/work/volume-sources ^
--mount source=%cd%/ssh-keys,target=/home/jovyan/.ssh,type=bind ^
jupyter-docker-scipy start.sh jupyter lab --NotebookApp.password='sha1:eadc47330625:65d799b65d21048a4f96c12d862514466324f0e3'
