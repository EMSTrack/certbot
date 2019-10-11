# Using certbot image as a base
FROM certbot/certbot

RUN set -x && \
    apk --no-cache add openrc openssl && \

# generate certificates
RUN mkdir -p /etc/letsencrypt/live/localhost
WORKDIR /etc/letsencrypt/live/localhost

# COPY --chown=mosquitto:mosquitto etc/mosquitto/certificates /etc/mosquitto/certificates
# https://github.com/openssl/openssl/issues/7754#issuecomment-444063355
RUN sed -i'' \
    -e 's/RANDFILE/#RANDFILE/' \
    /etc/ssl/openssl.cnf
# https://mosquitto.org/man/mosquitto-tls-7.html
# RUN openssl genrsa -des3 -passout pass:cruzroja -out server.key 2048
RUN openssl genrsa -passout pass:cruzroja -out server.key 2048
RUN openssl req -out server.csr -key server.key -passin pass:cruzroja -new \
    -subj "/C=US/ST=CA/L=San Diego/O=EMSTrack Certification/OU=Certification/CN=localhost"
# https://asciinema.org/a/201826
#RUN openssl req -new -x509 -days 365 -extensions v3_ca -keyout my-ca.key -out my-ca.crt \
#    -passout pass:cruzroja -passin pass:cruzroja \
#    -subj "/C=US/ST=CA/L=San Diego/O=EMSTrack MQTT/OU=MQTT/CN=localhost"
RUN openssl req -new -x509 -days 365 -keyout my-ca.key -out my-ca.crt \
    -passout pass:cruzroja -passin pass:cruzroja \
    -subj "/C=US/ST=CA/L=San Diego/O=EMSTrack MQTT/OU=MQTT/CN=localhost"
RUN openssl x509 -req -in server.csr -CA my-ca.crt -CAkey my-ca.key -CAcreateserial \
    -passin pass:cruzroja -out server.crt -days 180

ENTRYPOINT [ "certbot" ]
