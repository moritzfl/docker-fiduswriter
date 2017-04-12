FROM ubuntu:16.04
EXPOSE 8000:8000
ENV VERSION 3.1.0
ENV EXECUTING_USER fiduswriter

RUN groupadd --system ${EXECUTING_USER} && useradd --system --create-home --gid ${EXECUTING_USER}  ${EXECUTING_USER} 

RUN apt-get update
RUN apt-get install -y wget unzip libjpeg-dev python-dev python-virtualenv gettext zlib1g-dev git npm nodejs nodejs-legacy python-pip
RUN mkdir /data

# Download fiduswriter release from github
RUN wget -O fiduswriter.zip https://github.com/fiduswriter/fiduswriter/archive/${VERSION}.zip
RUN unzip fiduswriter.zip
RUN mv fiduswriter-${VERSION} /fiduswriter

WORKDIR "fiduswriter"
RUN mkdir static-libs

# Store relevant data in /data for persistence
RUN cp configuration.py-default configuration.py

# Add access for the executing user
RUN chown -R ${EXECUTING_USER}:${EXECUTING_USER} /data
RUN chown -R ${EXECUTING_USER}:${EXECUTING_USER} /fiduswriter

#Switch to executing user
USER ${EXECUTING_USER} 

RUN virtualenv venv
RUN /bin/bash -c "source venv/bin/activate"

RUN pip install -r requirements.txt

RUN python manage.py init
CMD python manage.py runserver
