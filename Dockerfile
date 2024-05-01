FROM ubuntu

RUN \
  apt-get update && \
  apt-get -y install curl zip

RUN useradd geneweb

# Default language to be English
ENV LANGUAGE en

# Default access to gwsetup is from docker host
ENV HOST_IP 172.17.0.1

# Copy script to local bin folder
COPY bin/*.sh /usr/local/bin/

# Make script executable
RUN chmod a+x /usr/local/bin/*.sh

# Copy AnnieRose DB to local import folder
RUN mkdir -p /tmp/DB/
COPY import/AnnieRose.gw /tmp/DB

# Install geneweb
RUN /usr/local/bin/install.sh

# Change the geneweb home directory to our database path to avoid stomping on debian package path /var/lib/geneweb
RUN usermod -d /opt/geneweb/ geneweb 

# Ensure that the geneweb user own every geneweb files
RUN chown -R geneweb /opt/geneweb

# Create a volume on the container
VOLUME /opt/geneweb

# Expose the geneweb and gwsetup ports to the docker host
EXPOSE 2317
EXPOSE 2316

# Run the container as the geneweb user
USER geneweb

ENTRYPOINT ["main.sh"]
CMD ["start-all"]
