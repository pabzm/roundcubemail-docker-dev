FROM docker.io/roundcube/roundcubemail

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
 && apt-get install -y --no-install-recommends npm git \
 && apt-get clean

COPY --chmod=0755 docker-entrypoint-dev.sh /

VOLUME /var/www/html

ENTRYPOINT ["/docker-entrypoint-dev.sh"]

# This CMD is from the upstream image, don't know why it needs to be repeated.
CMD ["apache2-foreground"]
