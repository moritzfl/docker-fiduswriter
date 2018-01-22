# docker-fiduswriter

[![automated](https://img.shields.io/docker/automated/moritzf/fiduswriter.svg)](https://hub.docker.com/r/moritzf/fiduswriter/)
[![build](https://img.shields.io/docker/build/moritzf/fiduswriter.svg)](https://hub.docker.com/r/moritzf/fiduswriter/)
[![pulls](https://img.shields.io/docker/pulls/moritzf/fiduswriter.svg)](https://hub.docker.com/r/moritzf/fiduswriter/)

[FidusWriter](https://github.com/fiduswriter/fiduswriter) is a collaborative online writing tool. This is a docker image that was built following the official installation manual for Ubuntu as closely as possible.

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
$ sudo chown -R 999:999 /host/directory
~~~~
(Replace "/host/directory" with a valid directory on your host machine)

To get fiduswriter running use (you can do without -v /host/directory:/data but that means no persistent data): 
~~~~
$ docker run -d -v /host/directory:/data -p 8000:8000 --name moritzf-fiduswriter moritzf/fiduswriter:latest
~~~~
(Replace "/host/directory" with a valid directory on your host machine)

If needed, you can create an administrative account for fiduswriter by attaching the container to your terminal and issuing the following command:
~~~~
$ ./manage.py createsuperuser
~~~~
