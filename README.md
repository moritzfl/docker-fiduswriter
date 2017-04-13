# docker-fiduswriter

> This is still in development!! No guarantee on anything ;)

[FidusWriter](https://www.fiduswriter.org/how-it-works/) is a collaborative online writing tool. This is a docker image following the official installation manual as closely as possible.

You will need to modify the entries for ALLOWED_HOSTS in the file /data/configuration.py in order to allow access from any other URL than localhost.

Until you define a mail-server, the mails and contained links required for user registration get printed to the outputstream of the container.

To run use: 
~~~~
$ docker run -d -v /host/directory:/data -p 8000:8000 --name moritzf-fiduswriter moritzf/fiduswriter:latest
~~~~
(Replace "/host/directory" with a valid directory on your host machine)
