#!/usr/bin/env bash

# diff with colors
diff() {
  colordiff -u "$@"
}

# build golang static binary (useful for dockerize)
# Usage: go_build_static -o app app.go
go_build_static() {
  local version
  local timestamp
  local commit

  version=${1:-dev}
  timestamp="$(TZ=UTC date -u '+%Y-%m-%dT%H:%M:%SZ')"
  commit=$(git rev-parse HEAD)

  # GOOS=linux GOARCH=amd64
  CGO_ENABLED=0 go build -a -trimpath -ldflags "-s -w \
                                        -extldflags '-static' \
                                        -X main.Version=${version} \
                                        -X main.BuildTime=${timestamp} \
                                        -X main.GitHash=${commit}" "$@"
}

# forwarded port ${2} on server to ${1} on the local (client)
# Usage: ssh-forward 5900 5901 login@remote-server
ssh-forward() {
  # shellcheck disable=SC2029
  ssh -L "${1}":localhost:"${2}" -N -f "${3}"
}

# create SOCKS 5 proxy on local (client) at port ${1}
# Usage: ssh-socks 9999 login@remote-server
ssh-socks() {
  # shellcheck disable=SC2029
  ssh -f -C2qTnN -D "${1}" "${2}"
}

# Get information about IP address
ipinfo() {
  curl -s -H "Authorization: Bearer ${IPINFO_TOKEN}" "https://ipinfo.io/$*"
}

# Lookup MAC vendor
macvendors() {
  curl -G "https://api.macvendors.com/v1/lookup/$*" \
    -H "Authorization: Bearer ${MACVENDORS_TOKEN}" \
    -H "Accept: text/plain"
}

# Public Diffie-Hellman Parameter Service/Tool
# https://2ton.com.au/dhtool/
dhparam() {
  size=${1:-4096}
  curl -sSL "https://2ton.com.au/dhparam/$size" -o dhparam.pem
}

weather() {
  location=${1:-sgn} # sgn: HCM, han: HN
  curl -4 "http://wttr.in/${location}"
}

# bashlogger
bashlogger() {
  script /tmp/log.txt
}

if [[ "$OSTYPE" == linux* ]]; then
  # Usage: vpn aws up/down
  vpn() {
    location=${1:-office}
    action=${2:-up}
    case ${location} in
      hk)
        nmcli con "${action}" id 'PIA - Hong Kong'
        ;;
      us)
        nmcli con "${action}" id 'PIA - US West'
        ;;
      sg)
        nmcli con "${action}" id 'PIA - Singapore'
        ;;
      office)
        nmcli con "${action}" id 'Office'
        ;;
      *)
        nmcli con "${action}" id 'Office'
        ;;
    esac
  }
fi

# echo "You can simulate on-screen typing just like in the movies" | pv -qL 10
typing-echo() {
  echo "$@" | pv -qL 10
}

# fast-sync user@<source>:<source_dir> <dest_dir>
fast-sync() {
  rsync -aHAXxv --numeric-ids --delete --progress -e "ssh -T -c arcfour -o Compression=no -x" "$@"
}

# htpasswd
htpasswd() {
  printf "Username: "
  read -r LOGIN_USER
  printf "%s:$(openssl passwd -apr1)\\n" "${LOGIN_USER}"
}

### OpenSSL shortcut ###
openssl-view-certificate() {
  openssl x509 -text -noout -in "${1}"
}

openssl-view-csr() {
  openssl req -text -noout -verify -in "${1}"
}

openssl-view-key() {
  openssl rsa -check -in "${1}"
}

openssl-view-pkcs12() {
  openssl pkcs12 -info -in "${1}"
}

# Connecting to a server (Ctrl C exits)
openssl-client() {
  openssl s_client -status -connect "${1}":443
}

# Convert PEM private key, PEM certificate and PEM CA certificate
# (used by nginx, Apache, and other openssl apps) to a PKCS12 file
# (typically for use with Windows or Tomcat)
openssl-convert-pem-to-p12() {
  openssl pkcs12 -export -inkey "${1}" -in "${2}" -certfile "${3}" -out "${4}"
}

# Convert a PKCS12 file to PEM
openssl-convert-p12-to-pem() {
  openssl pkcs12 -nodes -in "${1}" -out "${2}"
}

# Check the modulus of a certificate (to see if it matches a key)
openssl-check-certificate-modulus() {
  openssl x509 -noout -modulus -in "${1}" | shasum -a 256
}

# Check the modulus of a key (to see if it matches a certificate)
openssl-check-key-modulus() {
  openssl rsa -noout -modulus -in "${1}" | shasum -a 256
}

# Check the modulus of a certificate request
openssl-check-key-modulus() {
  openssl req -noout -modulus -in "${1}" | shasum -a 256
}

# Encrypt a file (because zip crypto isn't secure)
openssl-encrypt() {
  openssl aes-256-cbc -salt -in "${1}" -out "${2}"
}

# Decrypt a file
openssl-decrypt() {
  openssl aes-256-cbc -d -in "${1}" -out "${2}"
}

# End of file
