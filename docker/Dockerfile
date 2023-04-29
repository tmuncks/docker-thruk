FROM ubuntu:jammy

# persist configs, reports, cache etc
VOLUME /etc/thruk
VOLUME /var/lib/thruk

EXPOSE 80

WORKDIR /tmp

# install image requirements
RUN apt-get update && apt-get -y dist-upgrade
RUN apt-get install -y wget pwgen ssmtp
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y tzdata

# install thruk
RUN \
    wget https://download.thruk.org/pkg/v3.04/ubuntu22.04/amd64/libthruk_3.00_ubuntu22.04_amd64.deb && \
    wget  https://download.thruk.org/pkg/v3.04/ubuntu22.04/amd64/thruk-base_3.04-1_ubuntu22.04_amd64.deb && \
    wget  https://download.thruk.org/pkg/v3.04/ubuntu22.04/amd64/thruk_3.04-1_ubuntu22.04_amd64.deb && \
    wget  https://download.thruk.org/pkg/v3.04/ubuntu22.04/amd64/thruk-plugin-reporting_3.04-1_ubuntu22.04_amd64.deb
RUN apt-get install -y /tmp/*.deb

# clean up image
RUN rm -rf /tmp/*.deb /var/lib/apt/lists/*

# setup apache logging
RUN \
    sed -i -re "/^(Error|Transfer)Log /d" /etc/apache2/apache2.conf && \
    echo "ErrorLog /dev/stderr\nTransferLog /dev/stdout" >> /etc/apache2/apache2.conf

# remove thrukadmin password (prevent login)
RUN : > /etc/thruk/htpasswd

WORKDIR /

COPY docker-entrypoint.sh /docker-entrypoint.sh

CMD ["/docker-entrypoint.sh"]
