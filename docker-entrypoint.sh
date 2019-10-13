#!/bin/ash

if [ -e /etc/certificates/localhost/server.key ];
then

    echo "Local certificates already exist, skipping..."

else

    echo "Generating local certificates..."

    mkdir -p /etc/certificates/localhost
    cd /etc/certificates/localhost

    ls

    sed -i'' \
        -e 's/RANDFILE/#RANDFILE/' \
        /etc/ssl/openssl.cnf

    # https://mosquitto.org/man/mosquitto-tls-7.html
    # RUN openssl genrsa -des3 -passout pass:cruzroja -out server.key 2048
    openssl genrsa -passout pass:cruzroja -out server.key 2048

    ls

    openssl req -out server.csr -key server.key -passin pass:cruzroja -new \
            -subj "/C=US/ST=CA/L=San Diego/O=EMSTrack Certification/OU=Certification/CN=localhost"

    ls

    # https://asciinema.org/a/201826
    #RUN openssl req -new -x509 -days 365 -extensions v3_ca -keyout server-ca.key -out server-ca.crt \
    #    -passout pass:cruzroja -passin pass:cruzroja \
    #    -subj "/C=US/ST=CA/L=San Diego/O=EMSTrack MQTT/OU=MQTT/CN=localhost"
    openssl req -new -x509 -days 365 -keyout server-ca.key -out server-ca.crt \
            -passout pass:cruzroja -passin pass:cruzroja \
            -subj "/C=US/ST=CA/L=San Diego/O=EMSTrack MQTT/OU=MQTT/CN=localhost"

    ls

    openssl x509 -req -in server.csr -CA server-ca.crt -CAkey server-ca.key -CAcreateserial \
            -passin pass:cruzroja -out server.crt -days 180

    ls

    cd /opt/certbot

    echo "Done"

fi


# run command

echo "Executing command..."
if exec certbot "$@";
then
    echo "certbot exited with failure"
else
    echo "certbot exited with success"
fi
