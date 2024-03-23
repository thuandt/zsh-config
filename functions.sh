#!/usr/bin/env bash

# diff with colors
diff() {
  colordiff -u "$@"
}

# git diff with bat
batdiff() {
  git diff --name-only --diff-filter=d 2>/dev/null | xargs bat --diff
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
  CGO_ENABLED=0 \
    go build -a \
    -gcflags=all="-l -B" \
    -trimpath \
    -ldflags "-s -w \
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
  curl -fsSL -4 "https://wttr.in/${location}"
}

# bashlogger
bashlogger() {
  script /tmp/log.txt
}

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

# Create Tailscale one time key
create-new-tailscale-key() {
  curl -fsSL -X POST "https://api.tailscale.com/api/v2/tailnet/${TAILNET}/keys" \
    -u "${TAILSCALE_API_KEY}:" \
    -H 'Content-Type: application/json' \
    -d '{"capabilities":{"devices":{"create":{"reusable":false,"ephemeral":false,"preauthorized":true,"tags":[]}}}}' |
    jq -r '.key'
}

# Update tailscale-auth-key in all AWS accounts
update-bastion-tailscale-auth-key() {
  IFS=" " read -r -A aws_active_profiles <<<"${TAILSCALE_AWS_PROFILES}"
  for profile in "${aws_active_profiles[@]}"; do
    export AWS_PROFILE="${profile}"
    aws secretsmanager put-secret-value \
      --secret-string "${TAILSCALE_BASTION_AUTH_KEY}" \
      --secret-id "${TAILSCALE_BASTION_AUTH_KEY_SECRET_ID}"
  done
  unset AWS_PROFILE
}

# Access Wireguard VPN via Session Manager
ssm-vpn() {
  aws ssm start-session \
    --target "$(aws ec2 describe-instances \
      --filters 'Name=tag:Name,Values=wgvpn' \
      --query 'Reservations[*].Instances[*].InstanceId' \
      --region ap-southeast-1 \
      --profile nonprod \
      --output text)" \
    --profile nonprod \
    --region ap-southeast-1
}

# Access Firezone via Session Manager
ssm-firezone() {
  aws ssm start-session \
    --target "$(aws ec2 describe-instances \
      --filters 'Name=tag:Name,Values=firezone-wgvpn' \
      --query 'Reservations[*].Instances[*].InstanceId' \
      --region ap-southeast-1 \
      --profile nonprod \
      --output text)" \
    --profile nonprod \
    --region ap-southeast-1
}

# Access Gitlab via Session Manager
ssm-gitlab() {
  aws ssm start-session \
    --target "$(aws ec2 describe-instances \
      --filters 'Name=tag:Name,Values=gitlab-ce' \
      --query 'Reservations[*].Instances[*].InstanceId' \
      --region ap-southeast-1 \
      --profile prod \
      --output text)" \
    --profile prod \
    --region ap-southeast-1
}

# Access to devops-bastion via Session Manager
ssm-bastion() {
  aws ssm start-session \
    --target "$(aws ec2 describe-instances \
      --filters 'Name=tag:Name,Values=*devops-bastion' \
      --query 'Reservations[*].Instances[*].InstanceId' \
      --output text)"
}

create-airflow-fernet-key() {
  python -c "import os,base64;print(base64.urlsafe_b64encode(os.urandom(32)).decode())"
}

create-airflow-webserver-secret-key() {
  python -c "import os;print(os.urandom(30).hex())"
}

create-rails-secret-key-base() {
  openssl rand -hex 64
}

# End of file
