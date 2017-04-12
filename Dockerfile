FROM ubuntu:16.04
EXPOSE 8000:8000
ENV VERSION 3.1.0
ENV EXECUTING_USER fiduswriter

RUN groupadd --system ${EXECUTING_USER} && useradd --system --create-home --gid ${EXECUTING_USER}  ${EXECUTING_USER} 

RUN apt-get update
RUN apt-get install -y wget unzip libjpeg-dev python-dev python-virtualenv gettext zlib1g-dev git npm nodejs nodejs-legacy python-pip
RUN mkdir /data
RUN mkdir /data/media


RUN wget -O fiduswriter.zip https://github.com/fiduswriter/fiduswriter/archive/${VERSION}.zip
RUN unzip fiduswriter.zip
RUN mv fiduswriter-${VERSION} /fiduswriter

WORKDIR "fiduswriter"
RUN mkdir static-libs
RUN cp configuration.py-default /data/configuration.py
RUN ln -s /data/configuration.py /fiduswriter/configuration.py
RUN ln -s /data/fiduswriter.sql /fiduswriter/fiduswriter.sql
RUN ln -s /data/media /fiduswriter/media
RUN chown -R ${EXECUTING_USER}:${EXECUTING_USER}  /data
RUN chown -R ${EXECUTING_USER}:${EXECUTING_USER} /fiduswriter

# Switch from root to other user to prevent problems with npm
USER ${EXECUTING_USER} 

RUN virtualenv venv
RUN /bin/bash -c "source venv/bin/activate"

RUN ls
RUN pip install -r requirements.txt

RUN python manage.py init
CMD python manage.py runserver
