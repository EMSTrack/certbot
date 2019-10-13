#!/bin/ash

if [ -e /etc/certificates/localhost/server.key ];
then

    echo "Local certificates already exist, skipping..."

else

    echo "Generating local certificates..."

    mkdir -p /etc/certificates/localhost
    cd /etc/certificates/localhost

    sed -i'' \
        -e 's/RANDFILE/#RANDFILE/' \
        /etc/ssl/openssl.cnf

    # https://mosquitto.org/man/mosquitto-tls-7.html
    # RUN openssl genrsa -des3 -passout env:$PASSWORD -out server.key 2048
    openssl genrsa -passout env:$PASSWORD -out server.key 2048

    openssl req -out server.csr -key server.key -passin env:$PASSWORD -new \
            -subj "/C=US/ST=CA/L=San Diego/O=EMSTrack Certification/OU=Certification/CN=localhost"

    # https://asciinema.org/a/201826
    #RUN openssl req -new -x509 -days 365 -extensions v3_ca -keyout server-ca.key -out server-ca.crt \
    #    -passout env:$PASSWORD -passin env:$PASSWORD \
    #    -subj "/C=US/ST=CA/L=San Diego/O=EMSTrack MQTT/OU=MQTT/CN=localhost"
    openssl req -new -x509 -days 365 -keyout server-ca.key -out server-ca.crt \
            -passout env:$CA_PASSWORD -passin env:$PASSWORD \
            -subj "/C=US/ST=CA/L=San Diego/O=EMSTrack MQTT/OU=MQTT/CN=localhost"

    openssl x509 -req -in server.csr -CA server-ca.crt -CAkey server-ca.key -CAcreateserial \
            -passin env:$CA_PASSWORD -out server.crt -days 180

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
