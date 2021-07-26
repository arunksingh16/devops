## Openssl Important Commands

OpenSSL does not come with a collection of trusted root certificates (also known as a root store or a trust store). Curl project provides a regularly updated conversion in Privacy-Enhanced Mail (PEM) format, which you can use directly:

http://curl.haxx.se/docs/caextract.html

all you need to do is point the -CAfile switch to your root store


List Supported Protocols 
```
openssl ciphers -v | awk '{print $2}' | sort | uniq
```

DEBUG
```
openssl s_client -cipher ECDHE-RSA-AES256-GCM-SHA384 -connect server:443 --debug -msg -tls1_2

```

Cipher Control -

```
openssl s_client -cipher HIGH -host SERVER_NAME:PORT

# using sec level (1-5) Level 5	Security level set to 256 bits of security.
openssl ciphers -v -s -tls1_2 'EECDH+AESGCM @SECLEVEL=5'

```

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
Certificate Conversion

```
# PEM to DER format:

openssl x509 -inform PEM -in fd.pem -outform DER -out fd.der

# To convert a certificate from DER to PEM format:

openssl x509 -inform DER -in fd.der -outform PEM -out fd.pem

# PEM format to PKCS#12

openssl pkcs12 -export \
    -name "My Certificate" \
    -out fd.p12 \
    -inkey fd.key \
    -in fd.crt \
    -certfile fd-chain.crt
    
    
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

Configuring openssl.cnf
```
[default_conf]
ssl_conf = ssl_section

[ssl_section]
system_default = system_default_section

[system_default_section]
MinProtocol = TLSv1.2
CipherString = DEFAULT:@SECLEVEL=2
Ciphersuites = TLS_AES_128_GCM_SHA256:TLS_CHACHA20_POLY1305_SHA256
Options = ServerPreference,PrioritizeChaCha
```
