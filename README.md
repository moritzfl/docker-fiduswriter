# docker-fiduswriter

[![automated](https://img.shields.io/docker/automated/moritzf/fiduswriter.svg)](https://hub.docker.com/r/moritzf/fiduswriter/)
[![build](https://img.shields.io/docker/build/moritzf/fiduswriter.svg)](https://hub.docker.com/r/moritzf/fiduswriter/)
[![pulls](https://img.shields.io/docker/pulls/moritzf/fiduswriter.svg)](https://hub.docker.com/r/moritzf/fiduswriter/)

[FidusWriter](https://github.com/fiduswriter/fiduswriter) is a collaborative online writing tool. This is a docker image that was built following the official installation manual for Ubuntu as closely as possible, and has been upgraded and extended with newer Fidus Writer versions and a Docker Compose example.

## Builds and Tags on DockerHub

Builds on Docker are tagged following this pattern and are triggered automatically through changes in [this project (moritzfl/docker-fiduswriter)](https://github.com/moritzfl/docker-fiduswriter) ("develop" ist triggered by commits, the others through releases):

- __latest__: latest release or prerelease of fiduswriter (most current "release-\[VERSION\]" or "prerelease-\[VERSION\]")

- __latest-stable__: version representing the latest stable release of fiduswriter (most current "release-\[VERSION\]")

- __release-\[VERSION\]__: a stable release of fiduswriter (equivalent to "release" on fiduswriter-repo)

- __prerelease-\[VERSION\]__: a potentially unstable version of fiduswriter (equivalent to "prerelease" on fiduswriter-repo) 

- __develop__: a development build is done after each commit

## How to use this image

You will need to modify the entries for ALLOWED_HOSTS in the file /data/configuration.py in order to allow __access__ from any __URL other than localhost__. I would recommend mapping the data directory to a directory on your host machine for data persistence and easy configuration (follow the instrucions below).

Until you define a mail-server (also through /data/configuration.py), the mails and contained __links required for user registration__ get printed to the __outputstream of the container__.

In order to persist data, you __must grant write access for the executing user (fiduswriter)__ to the data directory that you want to map to on the host. This can be achieved by issuing the command below. If you do not ensure access to the desired directory on the host, fiduswriter will not run correctly.
~~~~
$ sudo chown -R 1000:1000 /host/directory
~~~~
(Replace "/host/directory" with a valid directory on your host machine)

To get fiduswriter running use (you can do without -v /host/directory:/data but that means no persistent data): 
~~~~
$ docker run -d -v /host/directory:/data -p 8000:8000 --name moritzf-fiduswriter moritzf/fiduswriter:latest
~~~~
(Replace "/host/directory" with a valid directory on your host machine)

If needed, you can create an administrative account for fiduswriter by attaching the container to your terminal and issuing the following command:
~~~~
$ python3 manage.py createsuperuser
~~~~

## How to use this with Docker Compose

This repository comes with a `docker-compose.yaml` file. It describes a `production` like environment that uses a PostgreSQL database. You can retrieve dependencies and generate the Docker image for Fidus Writer with:

    docker-compose pull
    docker-compose build

This will install all build-time dependencies into the image. To configure it for the resulting container, we need to put some configuration in place.

    mkdir -p ./data/postgres
    mkdir -p ./data/fiduswriter
    chown -R 1000:1000 ./data/fiduswriter
    cp env/postgres.env.example env/postgres.env
    cp env/fiduswriter.env.example env/fiduswriter.env
    cp env/configuration.py.example data/configuration.py

You will eventually only need to adapt the `*.env` files. The `configuration.py` file differs from the default configuration in so that it reads the configuration from the environment variables specified in the previous files. Please refer to the application documentation, in case these settings are not self-explanatory.

Be sure to change the `SECRET_KEY`:

    docker-compose run --rm app /usr/bin/python3 -c "from django.core.management.utils import get_random_secret_key; print(get_random_secret_key())"

Then you can launch the application with:

    docker-compose up -d

Make sure to run the application setup everytime you upgrade:

    docker-compose run --rm app fiduswriter setup

One last adaptation is needed after the initial installation, since else the registration emails will be sent from `example.com`.

First create a super user with

    docker-compose exec app fiduswriter createsuperuser

and then login to `/admin` to change the site configuration. The default Django site that is created during `fiduswriter setup` is called *example.com*, which will be used by `django-allauth` for email messages. Let's change this to a `production` value.

This application state needs to be adapted in `/admin/sites/site/`, which is only accessible to superusers, why we created the admin account just before.

Change the *domain name* to from where your instance can be reached, and the *display name* to indicate how you want it to be called. Then your Fidus Writer deployment should be complete.

Please leave comments in the issues if you have any remarks.

