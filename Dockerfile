# Start from a core stack version
# manual https://jupyter-docker-stacks.readthedocs.io/en/latest/
# based on https://github.com/jupyter/docker-stacks/blob/master/scipy-notebook/Dockerfile
ARG BASE_CONTAINER=jupyter/scipy-notebook
FROM $BASE_CONTAINER

LABEL maintainer="Dmitry Dementiev <ddmitry@gmail.com>"

USER root

# WORKDIR /usr/local/bin/start-notebook.d
COPY ssh-agent.sh /usr/local/bin/start-notebook.d/
RUN chmod +x /usr/local/bin/start-notebook.d/ssh-agent.sh

RUN apt-get update && \
    apt-get install -y --no-install-recommends openssh-client mc ncdu tig && \
    rm -rf /var/lib/apt/lists/*

# Install Python 3 packages
RUN conda install --quiet --yes \
    # 'beautifulsoup4=4.9.*' \
    # 'conda-forge::blas=*=openblas' \
    # 'bokeh=2.0.*' \
    jupyterlab-git \
    catboost \
    xgboost \
    psycopg2 \
    plotly \
    hyperopt \
    shap \
    graphviz \
    && \
    conda clean --all -f -y && \
    # Activate ipywidgets extension in the environment that runs the notebook server
    jupyter nbextension enable --py widgetsnbextension --sys-prefix && \
    # Also activate ipywidgets extension for JupyterLab
    # Check this URL for most recent compatibilities
    # https://github.com/jupyter-widgets/ipywidgets/tree/master/packages/jupyterlab-manager
    #jupyter labextension install @jupyter-widgets/jupyterlab-manager@^2.0.0 --no-build && \
    jupyter labextension install @jupyter-widgets/jupyterlab-manager --no-build && \
    jupyter labextension install @bokeh/jupyter_bokeh --no-build && \
    jupyter labextension install jupyter-matplotlib --no-build && \
    jupyter labextension install @jupyterlab/toc --no-build && \
    jupyter labextension install @jupyterlab/git  --no-build && \
    jupyter labextension install @telamonian/theme-darcula  --no-build && \
    jupyter labextension install jupyterlab-theme-solarized-dark  --no-build && \
    jupyter labextension install @deathbeds/jupyterlab-fonts --no-build && \
    jupyter labextension install jupyterlab-topbar-extension jupyterlab-theme-toggle --no-build && \
    # jupyter labextension install jupyterlab-theme-base16-solarized-light  --no-build && \
    jupyter lab build -y && \
    jupyter lab clean -y && \
    npm cache clean --force && \
    rm -rf "/home/${NB_USER}/.cache/yarn" && \
    rm -rf "/home/${NB_USER}/.node-gyp" && \
    fix-permissions "${CONDA_DIR}" && \
    fix-permissions "/home/${NB_USER}"

# Install facets which does not have a pip or conda package at the moment
# WORKDIR /tmp
# RUN git clone https://github.com/PAIR-code/facets.git && \
#     jupyter nbextension install facets/facets-dist/ --sys-prefix && \
#     rm -rf /tmp/facets && \
#     fix-permissions "${CONDA_DIR}" && \
#     fix-permissions "/home/${NB_USER}"

# Import matplotlib the first time to build the font cache.
ENV XDG_CACHE_HOME="/home/${NB_USER}/.cache/"

# RUN MPLBACKEND=Agg python -c "import matplotlib.pyplot" && \
#     fix-permissions "/home/${NB_USER}"

USER $NB_UID

WORKDIR $HOME

#run echo 'eval `ssh-agent`' >> .bashrc

EXPOSE 8888
