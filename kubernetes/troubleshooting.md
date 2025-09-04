# troubleshooting

```
kubectl get secret smbcreds -n default -o yaml
kubectl get secret smbcreds -n default -o jsonpath='{.data}' | jq -r 'keys[]'
# context
kubectl config get-contexts
# pvc
kubectl get pvc smb-pvc -n default


# to check mounting logs
kubectl logs -n kube-system csi-smb-node-ll82v -c smb --tail=50
```


## Create a debug pod
```
apiVersion: v1
kind: Pod
metadata:
  name: smb-debug
  namespace: default
spec:
  containers:
  - name: debug
    image: alpine:latest
    command: ["/bin/sh"]
    args: ["-c", "apk add --no-cache cifs-utils && sleep 3600"]
    securityContext:
      privileged: true
  nodeSelector:
    kubernetes.io/hostname: ip-10-0-4-23.eu-west-1.compute.internal

```
