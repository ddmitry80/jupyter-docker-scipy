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
    apt-get install -y --no-install-recommends openssh-client mc ncdu htop tig && \
    rm -rf /var/lib/apt/lists/*

# Install Python 3 packages
RUN conda install -c conda-forge --quiet --yes \
    jupyterlab-git \
    python-snappy \
    # jupyter_conda \
    mamba_gator \
    mamba \
    && \
    conda clean --all -f -y 

# Install Python 3 packages
RUN conda install -c conda-forge --yes \
    xeus-python \
    && \
    conda clean --all -f -y 

# Install Python 3 packages
# RUN conda install -c conda-forge --yes \
#     #jupyter_conda \
#     && \
#     conda clean --all -f -y 

# Install Python 3 packages
RUN conda install -c conda-forge --quiet --yes \
    # catboost \
    xgboost \
    lightgbm \
    && \
    conda clean --all -f -y 

# Install Python 3 packages
RUN mamba install -c conda-forge --quiet --yes \
    psycopg2 \
    # pymysql \
    plotly \
    hyperopt \
    shap \
    graphviz \
    kaggle \
    pyarrow \
    fastparquet \
    lxml \
    html5lib \
    theme-darcula \
    && \
    mamba clean --all -f -y 

    # Activate ipywidgets extension in the environment that runs the notebook server
RUN jupyter nbextension enable --py widgetsnbextension --sys-prefix && \
    # Also activate ipywidgets extension for JupyterLab
    # Check this URL for most recent compatibilities
    # https://github.com/jupyter-widgets/ipywidgets/tree/master/packages/jupyterlab-manager
    #jupyter labextension install @jupyter-widgets/jupyterlab-manager@^2.0.0 --no-build && \
    jupyter labextension install @jupyter-widgets/jupyterlab-manager --no-build && \
    # jupyter labextension install @bokeh/jupyter_bokeh --no-build && \
    #jupyter labextension install jupyter-matplotlib --no-build && \
    # jupyter labextension install @jupyterlab/toc --no-build && \
    #jupyter labextension install @jupyterlab/git  --no-build && \
    #jupyter labextension install ruler  --no-build && \
    #jupyter labextension install jupyterlab_conda --no-build && \
    #jupyter labextension install @telamonian/theme-darcula  --no-build && \
    jupyter labextension install jupyterlab-theme-solarized-dark  --no-build && \
    #jupyter labextension install @deathbeds/jupyterlab-fonts --no-build && \
    #jupyter labextension install jupyterlab-topbar-extension jupyterlab-theme-toggle --no-build && \
    # jupyter labextension install jupyterlab-theme-base16-solarized-light  --no-build && \
    conda upgrade --all && \
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

RUN echo "env_dirs:" >> $HOME/.conda/condarc && \
    echo "- $HOME/conda-envs" >> $HOME/.conda/condarc
    echo "- /opt/conda/envs" >> $HOME/.conda/condarc

# Import matplotlib the first time to build the font cache.
ENV XDG_CACHE_HOME="/home/${NB_USER}/.cache/"

# RUN MPLBACKEND=Agg python -c "import matplotlib.pyplot" && \
#     fix-permissions "/home/${NB_USER}"

USER $NB_UID

WORKDIR $HOME

#run echo 'eval `ssh-agent`' >> .bashrc

EXPOSE 8888
