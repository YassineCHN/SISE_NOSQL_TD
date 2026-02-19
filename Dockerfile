# Image de base avec Jupyter pré-installé
FROM jupyter/minimal-notebook:python-3.10

# Passage en root pour l'installation système
USER root
RUN apt-get update -y 
RUN wget https://fastdl.mongodb.org/tools/db/mongodb-database-tools-ubuntu2204-x86_64-100.9.4.deb && \
    apt-get update && \
    apt install -y ./mongodb-database-tools-ubuntu2204-x86_64-100.9.4.deb && \
    rm mongodb-database-tools-ubuntu2204-x86_64-100.9.4.deb && \
    rm -rf /var/lib/apt/lists/*

# Retour à l'utilisateur Jupyter pour les pip install
USER ${NB_UID}

# Installation des drivers NoSQL
RUN pip install --no-cache-dir \
    redis \
    pymongo \
    pyorient

# Répertoire de travail
WORKDIR /home/jovyan