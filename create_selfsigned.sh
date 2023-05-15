#this script is supposed to only be ran after the main script has already created a rootca certificate, this script can then be used
#to create a new self signed cert in case the previous one went missing, or expired.
#Keep in mind that this script will not run if no rootCA.crt/key is present in the same folder as this script.
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
