# == Dockerized ChronixDB
#

FROM phusion/baseimage:0.9.22

MAINTAINER Eric Faden <efaden@gmail.com>

ENV DEBIAN_FRONTEND="noninteractive" 

# Use baseimage-docker's init system.
CMD ["/sbin/my_init"]

# Install Required Stuff
RUN apt-get -y update && apt-get -y install \
      golang \
      git \
	&& rm -rf /var/lib/apt/lists/*

# Add Chronix Service
RUN mkdir /etc/service/chronix-ingester
COPY chronix-ingester.sh /etc/service/chronix-ingester/run
RUN chmod +x /etc/service/chronix-ingester/run

# Download and Install Chronix
RUN mkdir /chronix-ingester && \
      export GOPATH=/chronix-ingester && \
      cd chronix-ingester && \
      go get github.com/ChronixDB/chronix.ingester && \
      cd /chronix-ingester/src/github.com/ChronixDB/chronix.ingester && \
      go build && \
      cp chronix.ingester /usr/local/bin && \
      cd / && \
      rm -rf /chronix-ingester

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Volume for Checkpoint File
VOLUME /data

# Environment Variables
RUN echo "http://127.0.0.1:8983/solr/chronix" > /etc/container_environment/CHRONIX_URL
RUN echo "8985" > /etc/container_environment/INGESTER_LISTEN_PORT

EXPOSE 8985
