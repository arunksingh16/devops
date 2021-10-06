
## kubectl output

List the API versions that are available
```
kubectl api-versions
```

full schema for K8s objects
```
kubectl explain services --recursive
```

Sorting using Kubectl
```
kubectl get pods -o wide --sort-by=.spec.nodeName

```

Switch 

```
alias kc='kubectl config use-context'
alias kn='kubectl config set-context `kubectl config current-context` --namespace'

```

Bash format https://twitter.com/micahhausler/status/785833744863268871

```
NORMAL="\[\033[00m\]"
BLUE="\[\033[01;34m\]"
RED="\[\e[1;31m\]"
YELLOW="\[\e[1;33m\]"
GREEN="\[\e[1;32m\]"
PS1_WORKDIR="\w"
PS1_HOSTNAME="\h"
PS1_USER="\u"

__kube_ps1()
{
    CONTEXT=$(kubectl config current-context)
    if [ -n "$CONTEXT" ]; then
        case "$CONTEXT" in
          *prod*)
            echo "${RED}(k8s: ${CONTEXT})"
            ;;
          *test*)
            echo "${YELLOW}(k8s: ${CONTEXT})"
            ;;
          *)
            echo "${GREEN}(k8s: ${CONTEXT})"
            ;;
        esac
    fi
}

export PROMPT_COMMAND='PS1="${GREEN}${PS1_USER}@${PS1_HOSTNAME}${NORMAL}:$(__kube_ps1)${BLUE}${PS1_WORKDIR}${NORMAL}\$ "'
```

# Azure File Share and Kubernetes 
Yyou only can control the permission of the whole Azure file share when you mount it as the persistent volume on the pods. It does not support to change the permission of a special file inside the share. But you can control folder permission
https://stackoverflow.com/questions/58301985/permissions-on-azure-file



Imp Links
- https://github.com/so0k/powerline-kubernetes
- https://gist.github.com/so0k/42313dbb3b547a0f51a547bb968696ba
- 
