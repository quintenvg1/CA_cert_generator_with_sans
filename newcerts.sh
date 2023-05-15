#replace hostname with the fqdn of your service !! on all lines!!
#generate a ca certificate (certificate authority)
openssl genrsa -out rootCA.key 4096
openssl req -x509 -new -nodes -key rootCA.key -sha256 -days 1024 -out rootCA.crt

#generate a certificate for the host to be signed with the rootca
openssl genrsa -out hostname.key 4096
openssl req -new -key hostname.key -out hostname.csr
#create an external datafile for use with the certificates.
echo 'subjectKeyIdentifier   = hash
authorityKeyIdentifier = keyid:always,issuer:always
basicConstraints       = CA:TRUE
keyUsage               = digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment, keyAgreement, keyCertSign
subjectAltName         = DNS:hostname, DNS:*.hostname
issuerAltName          = issuer:copy' >> v3.ext

openssl x509 -req -in hostname.csr -CA rootCA.crt -CAkey rootCA.key -CAcreateserial -out hostname.crt -days 500 -sha256 -extfile v3.ext

openssl pkcs12 -export -in hostname.crt -inkey hostname.key -name self-signed-ssl -out keystore.p12
keytool -v -importkeystore -srckeystore keystore.p12 -srcstoretype PKCS12 -destkeystore mykeystore -deststoretype JKS

rm -rf v3.ext
echo "done"