# docker-fiduswriter

> This is still in development!! No guarantee on anything ;)

[FidusWriter](https://www.fiduswriter.org/how-it-works/) is a collaborative online writing tool. This is a docker image following the official installation manual as closely as possible.

The docker container should technically work but does not offer persistent data storage via the /data-directory yet.

To run use: 
~~~~
$ docker run -d -v /host/directory:/data -p 8000:8000 --name moritzf-fiduswriter moritzf/fiduswriter:latest
~~~~
(Replace "/host/directory" with a valid directory on your host machine)
