FROM ubuntu:20.04

# Set the time zone
ARG TZ=America/Vancouver
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Geoserver version
ARG GV=2.18.2

# Install a smarter package manager
RUN apt-get update 
RUN apt-get -y install aptitude

# Download Geoserver
RUN mkdir /usr/share/geoserver
WORKDIR /usr/share/geoserver
RUN aptitude -y install wget
RUN wget https://sourceforge.net/projects/geoserver/files/GeoServer/$GV/geoserver-$GV-bin.zip/download

# install Geoserver
RUN aptitude -y install openjdk-8-jdk
RUN aptitude -y install unzip
RUN unzip download
RUN rm download

# Expose the Geoserver port
EXPOSE 8080

CMD ["sh", "bin/startup.sh"]
