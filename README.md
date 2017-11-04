# docker-fiduswriter

> Has been successfully tested on macOS and Linux. If you encounter any problems, please report them

![automated](https://img.shields.io/docker/automated/moritzf/fiduswriter.svg)
![build](https://img.shields.io/docker/build/moritzf/fiduswriter.svg)
![pulls](https://img.shields.io/docker/pulls/moritzf/fiduswriter.svg)

[FidusWriter](https://www.fiduswriter.org/how-it-works/) is a collaborative online writing tool. This is a docker image that was built following the official installation manual as closely as possible.

## Builds and Tags on DockerHub

Builds on Docker are tagged following this pattern and are triggered automatically through changes in [this project (moritzfl/docker-fiduswriter)](https://github.com/moritzfl/docker-fiduswriter) ("latest" ist triggered by commits, the others - including "latest-stable" - through releases):
- __latest__: version built with the most current commit on this repository (usually this results in latest being an equivalent to the most current "release-\[VERSION\]" or "prerelease-\[VERSION\]")

- __latest-stable__: version representing the latest stable release of fiduswriter (equivalent to most current "release-\[VERSION\]")

- __release-\[VERSION\]__: a stable release of fiduswriter (equivalent to "release" on fiduswriter-repo)

- __prerelease-\[VERSION\]__: a potentially unstable version of fiduswriter (equivalent to "prerelease" on fiduswriter-repo) 

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
