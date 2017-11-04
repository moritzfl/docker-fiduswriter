FROM ubuntu:16.04
EXPOSE 8000:8000
ENV VERSION 3.3.5

# Executing group, with fixed group id
ENV EXECUTING_GROUP fiduswriter
ENV EXECUTING_GROUP_ID 999

# Executing user, with fixed user id
ENV EXECUTING_USER fiduswriter
ENV EXECUTING_USER_ID 999

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
RUN apt-get update \
    && apt-get install -y \
        gettext \
        git \
        libjpeg-dev \
        nodejs \
        nodejs-legacy \
        npm \
        python-dev \
        python-pip \
        python-virtualenv \
        unzip \
        wget \
        zlib1g-dev \
    && rm -rf /var/lib/apt/lists/*

# Download fiduswriter release from github
# Run the unzipping, moving and removal of zip file in the same layer.
RUN wget \
    --output-document=fiduswriter.zip \
    https://github.com/fiduswriter/fiduswriter/archive/${VERSION}.zip \
    && unzip fiduswriter.zip \
    && mv fiduswriter-${VERSION} /fiduswriter \
    && rm fiduswriter.zip

WORKDIR "fiduswriter"
RUN mkdir static-libs
RUN cp configuration.py-default configuration.py


RUN chmod -R 777 /data
RUN chmod -R 777 /fiduswriter

USER ${EXECUTING_USER}

RUN virtualenv venv
RUN /bin/bash -c "source venv/bin/activate"

RUN /fiduswriter/venv/bin/pip install --upgrade pip
RUN pip install -r requirements.txt

RUN python manage.py init

COPY start-fiduswriter.sh /etc/start-fiduswriter.sh
CMD sh "/etc/start-fiduswriter.sh"
