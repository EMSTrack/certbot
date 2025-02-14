# Using certbot image as a base
FROM certbot/certbot

ENV PASSWORD=password
ENV CA_PASSWORD=ca_password

# generate certificates
# COPY --chown=mosquitto:mosquitto etc/mosquitto/certificates/ /etc/mosquitto/certificates
# https://github.com/openssl/openssl/issues/7754#issuecomment-444063355
RUN set -x && \
    apk --no-cache add openssl && \
    mkdir -p /etc/certificates/localhost

WORKDIR /opt/certbot

VOLUME ["/etc/certificates/localhost", "/etc/letsencrypt", "/var/lib/letsencrypt"]

# Set up the entry point script and default command
COPY docker-entrypoint.sh /
RUN chmod +x /docker-entrypoint.sh
EXPOSE 1883
ENTRYPOINT ["/docker-entrypoint.sh"]
