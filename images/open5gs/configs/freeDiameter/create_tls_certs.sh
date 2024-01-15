#!/bin/bash

#GENERATE CA
# openssl genrsa -out ca.key.pem 2048
# openssl req -x509 -new -nodes -key ca.key.pem -sha256 -days 3650 -out cacert.pem

for NAME in "hss" "mme" "pcrf" "smf" 
do
  openssl genrsa -out $NAME.key.pem 2048
  openssl req -new -subj "/C=ES/CN=$NAME.gradiant" \
                -key $NAME.key.pem \
                -out $NAME-csr.pem 
  openssl x509 -days 3650 \
        -req -in $NAME-csr.pem \
        -CA cacert.pem \
        -CAkey ca.key.pem \
        -CAcreateserial \
        -out $NAME.cert.pem 
done

