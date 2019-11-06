#!/usr/bin/env bash

# use neovim instead vim
alias vi="nvim"
alias vim="nvim"

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
