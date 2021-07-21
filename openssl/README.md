## Openssl Important Commands

Test connectivity to an https service.

```
openssl s_client -connect <hostname>:<port>

openssl s_client -connect <hostname>:<port> -showcerts

openssl s_client -connect <hostname>:<port> -cipher <CIPHER>

```

Displaying Selective certificate details

```
openssl x509 -text -noout -in <certificate-file> -certopt no_subject,no_header,no_version,no_serial,no_signame,no_validity,no_issuer,no_pubkey,no_sigdump,no_aux
openssl s_client -showcerts -connect server:443
openssl s_client -showcerts -cipher TLS_DHE_RSA_WITH_AES_256_CBC_SHA -connect server:443

```

Cipher Control -

```
openssl s_client -cipher HIGH -host SERVER_NAME:PORT

```

Find out which cipher can have a response [./script hostname:443]
```
#!/usr/bin/env bash

# OpenSSL requires the port number.
SERVER=$1
DELAY=1
ciphers=$(openssl ciphers 'ALL:eNULL' | sed -e 's/:/ /g')

echo Obtaining cipher list from $(openssl version).

for cipher in ${ciphers[@]}
do
echo -n Testing $cipher...
result=$(echo -n | openssl s_client -cipher "$cipher" -connect $SERVER 2>&1)
if [[ "$result" =~ ":error:" ]] ; then
  error=$(echo -n $result | cut -d':' -f6)
  echo NO \($error\)
else
  if [[ "$result" =~ "Cipher is ${cipher}" || "$result" =~ "Cipher    :" ]] ; then
    echo YES
  else
    echo UNKNOWN RESPONSE
    echo $result
  fi
fi
sleep $DELAY
done
```
