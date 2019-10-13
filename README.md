# certbot

This builds a container based on the [certbot/certbot](https://hub.docker.com/r/certbot/certbot/) image.

It generates the files

1. `server.key`
2. `server.csr`
3. `server.crt`
4. `server-ca.crt`
5. `server-ca.key`

in the directory `/etc/certificates/localhost`. The files `server.crt` and `server.key` can be used as
a certificate/key pair in nginx, e.g.

    ssl_certificate     /etc/certificates/localhost/server.crt;
    ssl_certificate_key /etc/certificates/localhost/server.key;

and the file `server-ca.crt` as a certification authority certificate.

The certificates and certificate authority paasswords can be set as args `PASSWORD` and `CA_PASSWORD`.