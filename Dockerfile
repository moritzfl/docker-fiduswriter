FROM ubuntu:16.04
EXPOSE 8000:8000
ENV VERSION 3.3.0-rc.14
ENV EXECUTING_USER fiduswriter
VOLUME ["/data"]

RUN groupadd --system ${EXECUTING_USER} && useradd --system --create-home --gid ${EXECUTING_USER}  ${EXECUTING_USER} 

RUN apt-get update
RUN apt-get install -y wget unzip libjpeg-dev python-dev python-virtualenv gettext zlib1g-dev git npm nodejs nodejs-legacy python-pip

# Download fiduswriter release from github
RUN wget -O fiduswriter.zip https://github.com/fiduswriter/fiduswriter/archive/${VERSION}.zip
RUN unzip fiduswriter.zip
RUN mv fiduswriter-${VERSION} /fiduswriter

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
