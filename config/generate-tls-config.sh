#!/bin/bash

CFGDIR=$(cd -P -- "$(dirname "${BASH_SOURCE[0]}")" && pwd)
SUBJECT="/C=US/ST=CA/O=Security/OU=OpenShift3/CN=maintenance.test"
CASUBJECT="/C=US/ST=CA/O=Security/OU=OpenShift3 test CA/CN=maintenance.test CA"
CADIR="${CFGDIR}/CA"
VALIDITY=7305  #  7305 days is 20 years and if the started docker
               #  container is around at that time ... kudos!! Its time for
               #  a new cert!!


#
#  main():
#
cd ${CFGDIR}

mkdir -p ${CADIR}/crl
echo "01" > ${CADIR}/serial
touch ${CADIR}/index.txt

echo "  - Generating CA private key and certificate ... "
OPENSSL=${CADIR}/ca.conf  \
  openssl req -x509 -nodes -days ${VALIDITY} -newkey rsa:1024  \
              -out ${CADIR}/cacert.pem  -outform PEM -keyout ${CADIR}/cakey.pem  \
	      -subj "${CASUBJECT}"

echo "  - Generating 2048 bit key ... "
openssl genrsa -out "${CFGDIR}/key.pem" 2048

echo "  - Generating csr ... "
openssl req -new -nodes -sha256 -key "${CFGDIR}/key.pem"  \
            -out "${CFGDIR}/req.csr" -subj "${SUBJECT}"

echo "  - Signing generated cert with CA ... "
OPENSSL_CONF=${CADIR}/ca.conf  \
  openssl ca -batch -notext -in "${CFGDIR}/req.csr"   \
             -days ${VALIDITY}  -out "${CFGDIR}/cert.pem"
