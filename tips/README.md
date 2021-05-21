### Sending logs to standard out
There are always three default files open, stdin (the keyboard), stdout (the screen), and stderr (error messages output to the screen). Each open file gets assigned a file descriptor. The file descriptors for stdin, stdout, and stderr are 0, 1, and 2, respectively.
https://tldp.org/LDP/abs/html/io-redirection.html
```
1>filename # Redirect stdout to file "filename."
2>filename # Redirect stderr to file "filename."
&>filename
      # Redirect both stdout and stderr to file "filename."
      # This operator is now functional, as of Bash 4, final release.

   M>N
     # "M" is a file descriptor, which defaults to 1, if not explicitly set.
     # "N" is a filename.
     # File descriptor "M" is redirect to file "N."
   M>&N
     # "M" is a file descriptor, which defaults to 1, if not set.
     # "N" is another file descriptor.
     
These are just symlinked to /proc/self/fd/[012] so you can directly send logs to standard output 

send logs to file > /proc/self/fd/1
```


### OpenSSL

```
openssl s_client -showcerts -connect server:443
openssl s_client -showcerts -cipher TLS_DHE_RSA_WITH_AES_256_CBC_SHA -connect server:443
```
