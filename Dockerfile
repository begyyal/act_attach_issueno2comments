FROM ubuntu:latest

COPY entrypoint.sh /entrypoint.sh
COPY shjp /shjp

RUN apt-get update
RUN apt-get -y install git vim

ENTRYPOINT ["/entrypoint.sh"]
