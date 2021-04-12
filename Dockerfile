# vim: set ts=4 sw=4 sts=0 sta et :
FROM ubuntu:20.04
EXPOSE 8000
ENV VERSION 3.9.19

# Executing group, with fixed group id
ENV EXECUTING_GROUP fiduswriter
ENV EXECUTING_GROUP_ID 1000

# Executing user, with fixed user id
ENV EXECUTING_USER fiduswriter
ENV EXECUTING_USER_ID 1000

# Data volume, should be owned by 1000:1000 to ensure the application can
# function correctly. Run `chown 1000:1000 <data-dir-path>` on the host OS to
# get this right.
VOLUME ["/data"]

# Create user and group with fixed ID, instead of allowing the OS to pick one.
RUN groupadd \
        --system \
        --gid ${EXECUTING_GROUP_ID} \
        ${EXECUTING_GROUP} \
    && useradd \
        --system \
        --create-home \
         --no-log-init \
        --uid ${EXECUTING_USER_ID} \
        --gid ${EXECUTING_USER} \
        ${EXECUTING_USER}

# Chain apt-get update, apt-get install and the removal of the lists.
# This is one of the best practices of Docker, see
# https://docs.docker.com/engine/userguide/eng-image/dockerfile_best-practices/#apt-get
RUN TZ=Europe/Berlin \
    ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN DEBIAN_FRONTEND=noninteractive \
    apt-get update \
    && apt-get install -y \
        build-essential \
        gettext \
        git \
        libjpeg-dev \
        libpq-dev \
        nodejs \
        npm \
        python3-venv \
        python3-dev \
        python3-pip \
        unzip \
        wget \
        zlib1g-dev \
        curl \
    && rm -rf /var/lib/apt/lists/*

RUN pip3 install --upgrade setuptools pip wheel
RUN pip3 install dj-database-url

RUN pip3 install fiduswriter[books,citation-api-import,languagetool,ojs,phplist,github-export,postgresql]==${VERSION}

RUN mkdir -p /fiduswriter && \
        chown 1000:1000 /fiduswriter && \
        chmod -R 777 /fiduswriter /data

USER 1000:1000
# Working directories should be absolute.
# https://docs.docker.com/engine/userguide/eng-image/dockerfile_best-practices/#workdir
WORKDIR /fiduswriter

RUN python3 -m venv venv
RUN /bin/bash -c "source /fiduswriter/venv/bin/activate"

COPY start-fiduswriter.sh /etc/start-fiduswriter.sh

# Always use the array form for exec, see
# https://docs.docker.com/engine/userguide/eng-image/dockerfile_best-practices/#cmd
CMD ["/bin/sh", "/etc/start-fiduswriter.sh"]
