FROM ubuntu:latest

COPY entrypoint.sh /entrypoint.sh
COPY daemon.sh /daemon.sh

RUN apt-get update
RUN apt-get -y install git vim

ENTRYPOINT ["/daemon.sh"]
