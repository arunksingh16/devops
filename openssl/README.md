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
