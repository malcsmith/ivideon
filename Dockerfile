FROM ubuntu:14.04

MAINTAINER malcsmith

# Run a quick apt-get update/upgrade
RUN apt-get update && apt-get upgrade -y && apt-get autoremove -y --purge

# Install dependencies
RUN apt-get update && \
    apt-get install -y \
    wget \
    psmisc

# Run as root
USER root

# Setup default environment variables for the server
ENV USER "root"
ENV TZ="Europe/London"
ENV ENABLE_WEB_INTERFACE="true"
ENV DEBIAN_FRONTEND="noninteractive"

# Setup volumes
#VOLUME ["/data"]
VOLUME ["/opt/ivideon/videoserverd"]
VOLUME ["/video_archive"]

# Prepare iVideon repository
RUN wget http://packages.ivideon.com/public/keys/ivideon.list -O /etc/apt/sources.list.d/ivideon.list && \
    wget -O - http://packages.ivideon.com/public/keys/ivideon.key | apt-key add - && \
    apt-get update

# Install iVideon
#RUN apt-get update && \
#    apt-get install -y \
#    ivideon-server

# Install iVideon
RUN apt-get update && \
    apt-get install -y \
    ivideon-server-headless
    
# Cleanup
RUN apt-get clean

# Start the server
ADD start.sh /start.sh
ENTRYPOINT ["/start.sh"]