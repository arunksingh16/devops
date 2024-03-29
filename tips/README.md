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


### kubernetes configmap prints "/n/t" 

```
sed -i -E 's/[[:space:]]+$//g' data.conf

sed -i 's/\t/     /g' file.txt

```

### JAVA Args for Proxy
```
-Djava.net.useSystemProxies=true
-Dhttp.proxyHost=10.10.10.10
-Dhttp.proxyPort=8080
-Dhttp.proxyUser=username
-Dhttp.proxyPassword=password
# https://docs.oracle.com/javase/6/docs/technotes/guides/net/proxies.html
```


### PowerShell


```
# Path 
$env:Path +=";C:\helm-canary-windows-amd64\"
$env:Path -split ';'
# group details
$id = [Security.Principal.WindowsIdentity]::GetCurrent()
$groups = $id.Groups | foreach-object {$_.Translate([Security.Principal.NTAccount])}
$groups | select * | Select-String -Pattern demo-pattern
Get-Alias -Definition Invoke-WebRequest | Format-Table -AutoSize
