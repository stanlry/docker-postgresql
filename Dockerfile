FROM debian:8
MAINTAINER stanlry chong <stanlry.g@gmail.com>

ENV PG_VERSION 9.4

# Install dependencies
RUN apt-get update && apt-get install -y sudo locales postgresql-${PG_VERSION} postgresql-contrib-${PG_VERSION} &&\
    rm -rf /var/lib/postgresql &&\
    rm -rf /var/lib/apt/lists.* &&\ 
    dpkg-reconfigure locales &&\
    echo "en_HK.UTF-8 UTF-8" >> /etc/locale.gen &&\
    locale-gen

ENV LANG en_HK.UTF-8
ENV LANGUAGE en_HK.UTF-8
ENV LC_ALL en_HK.UTF-8

COPY entrypoint.sh /
RUN chmod 755 /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
EXPOSE 5432

CMD ["postgres"]
