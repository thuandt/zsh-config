#!/usr/bin/env bash

# use neovim instead vim
alias vi="nvim"
alias vim="nvim"

# doom-emacs
alias doom="~/.emacs.d/bin/doom"
alias d-doctor="doom doctor"
alias d-purge="doom purge"
alias d-upgrade="doom upgrade"

# use aliases with sudo
alias sudo='sudo '

alias mkdir='mkdir -p'
alias path='echo -e ${PATH//:/\\n}'

alias df="df -kTh"
alias wtf='dmesg -T'

## Generate a Random MAC address
alias random_mac="openssl rand -hex 6 | sed 's/\\(..\\)/\\1:/g; s/.$//'"

## Secure delete file
alias secure-delete='shred -n 200 -z -u'

## Purging configuration files on Debian-based system
alias agpc="sudo aptitude purge '~c'"

# The Sliver Searcher (ag)
# conflict with ubuntu plugin
alias ag='command ag'

# confirmation #
alias cp='cp -vi'
alias mv='mv -vi'
alias ln='ln -vi'

## this one saved by butt so many times ##
alias wget='wget -c'

## What's my public ip address?
# icanhazip.com
# ipecho.net/plain
# ifconfig.me
# ifconfig.io
# ipinfo.io
alias whatismyip='curl ipecho.net/plain'

# Use ptpython inside virtualenv
alias pt2="python2 -m ptpython"
alias pt3="python3 -m ptpython"

# ripgrep search hidden files by default
alias rg='rg --hidden'

# SSH without HostKeyChecking and KnownHosts
alias tssh="ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null"

### BENCHMARK DISK IO ###
alias fio-r='fio --randrepeat=1 --ioengine=libaio --direct=1 --gtod_reduce=1 --name=fio --filename=fio --bs=4k --iodepth=64 --size=4G --readwrite=randread'
alias fio-w='fio --randrepeat=1 --ioengine=libaio --direct=1 --gtod_reduce=1 --name=fio --filename=fio --bs=4k --iodepth=64 --size=4G --readwrite=randwrite'
alias fio-rw='fio --randrepeat=1 --ioengine=libaio --direct=1 --gtod_reduce=1 --name=fio --filename=fio --bs=4k --iodepth=64 --size=4G --readwrite=randrw --rwmixread=75'

### Kubernetes aliases ###
# shellcheck disable=SC2154,SC1087,SC2202,SC2086
if [ $commands[kubectl] ]; then
  alias k="kubectl"
  alias kg="kubectl get"
  alias ke="kubectl edit"

  # get
  alias kn="kubectl get nodes"
  alias ks="kubectl get svc"
  alias kd="kubectl get deployment"
  alias kp="kubectl get pods"
  alias kpl="kubectl get pods -l"
  alias kpa="kubectl get pods --all-namespaces"

  # describe
  alias dsn="kubectl describe node"
  alias dss="kubectl describe svc"
  alias dsd="kubectl describe deployment"
  alias dsp="kubectl describe pod"

  # delete
  alias ddd="kubectl delete deployment"
  alias dds="kubectl delete svc"
  alias ddp="kubectl delete pod"

  alias kx="kubectl exec"
  alias klf="kubectl logs --tail=50 --follow"
  # alias xx="kubectl exec -it"
  xx() {
    kubectl exec -it "${1}" -- "$@"
  }

  ksh() {
    kubectl run shell \
      --image=${1:-"debian:12"} \
      --command -- /bin/bash -c 'trap : TERM INT; sleep infinity & wait'
  }

  alias kcf="kubectl create -f"
  alias kaf="kubectl apply -f"
  alias kdf="kubectl delete -f"

  # kustomize
  alias kz="kustomize"
  alias kzb="kustomize build --enable-alpha-plugins --enable-helm --enable-exec"
  alias kza="kubectl apply -k"
  alias kzg="kubectl get -k"
  alias kzd="kubectl delete -k"

  alias kcxm="kubectl config use-context minikube"
  alias kcxl="kubectl config use-context lab"
  alias kcxn="kubectl config use-context nonprod"
  alias kcxp="kubectl config use-context prod"

  # shellcheck disable=SC2154,SC1087,SC2202,SC2086
  if [ $commands[gcloud] ]; then
    alias gcxlab="gcloud config configurations activate lab && kubectl config use-context lab"
    alias gcxnp="gcloud config configurations activate stg && kubectl config use-context nonprod"
    alias gcxp="gcloud config configurations activate prd && kubectl config use-context prod"
  fi
fi
