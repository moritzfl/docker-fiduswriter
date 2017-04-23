# docker-fiduswriter

> Has been successfully tested on macOS and Linux. If you encounter any problems, please report them

[FidusWriter](https://www.fiduswriter.org/how-it-works/) is a collaborative online writing tool. This is a docker image following the official installation manual as closely as possible.

Environment variables in the Dockerfile: 

EXECUTING_USER -> User that runs the actual fiduswriter instance. Set to "fiduswriter".

VERSION -> Fiduswriter version.

You will need to modify the entries for ALLOWED_HOSTS in the file /data/configuration.py in order to allow __access__ from any __URL other than localhost__. I would recommend mapping the data directory to a directory on your host machine for data persistence and easy configuration (follow the instrucions below).

Until you define a mail-server (also through /data/configuration.py), the mails and contained __links required for user registration__ get printed to the __outputstream of the container__.

In order to persist data, you __must grant write access for the executing user__ to the directory on the host. This can be achieved by issuing the command below. If you do not ensure access to the desired directory on the host, fiduswriter will not run correctly.
~~~~
$ sudo chmod -R 777 /host/directory
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
