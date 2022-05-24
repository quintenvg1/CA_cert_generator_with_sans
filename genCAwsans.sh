echo "this script should work on ubuntu 22.04 by default"
#change filesnames and don't forget to change the string parameters | if you have problems try running tis script line by line
openssl genrsa -out rootCA.key 4096
openssl req -x509 -new -nodes -key rootCA.key -sha256 -days 1024 -out rootCA.crt
openssl genrsa -out hostname.key 2048
openssl req -new -sha256 -key hostname.key -subj "/C=US/ST=CA/O=MyOrg, Inc./CN=hostname" -reqexts SAN -config <(cat /etc/ssl/openssl.cnf <(printf "\n[SAN]\nsubjectAltName=DNS:www.hostname")) -out hostname.csr
openssl req -in hostname.csr -noout -text
openssl x509 -req -in hostname.csr -CA rootCA.crt -CAkey rootCA.key -CAcreateserial -out hostname.crt -days 500 -sha256
openssl x509 -in hostname.crt -text -noout
openssl pkcs12 -export -in hostname.crt -inkey hostname.key -name self-signed-ssl -out keystore.p12
keytool -v -importkeystore -srckeystore keystore.p12 -srcstoretype PKCS12 -destkeystore mykeystore -deststoretype JKS
echo "this script should have created the certificates and keystores with SANS make sure to double and triple check, it might save you a headache"