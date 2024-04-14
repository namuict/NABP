#!/bin/bash
set -e

export PATH=~/bin:/usr/share/foreman/bin:${PATH}

# Remove a potentially pre-existing server.pid for Rails.
rm -f ~/pids/server.pid

ABP_NAME=${ABP_NAME:=abpmaster}
ABP_DOMAIN=${ABP_DOMAIN:=example.com}
ABP_FQDN=${ABP_NAME}.${ABP_DOMAIN}
PROXY_FQDN=${PROXY_FQDN:=abpproxy.example.com}
ABP_UI_FQDN=${ABP_UI_FQDN:=abpui.example.com}
ABP_QL_FQDN=${ABP_QL_FQDN:=abpql.example.com}

ABP_DB_NAME=${ABP_DB_NAME:=foreman}
ABP_DB_USER=${ABP_DB_USER:=foreman}
ABP_DB_PW=${ABP_DB_PW:=root123}
ABP_DB_FQDN=${ABP_DB_FQDN:=abpdb.example.com}

MY_FQDN=$(hostname -f)

# Setup only at first run on app.
if [ ! -f "/etc/.setupcompleted" ]; then

  echo "Run setup only at the first time."

  sed -i \
      -e "s/ABP_FQDN/${ABP_FQDN}/g" /etc/httpd/conf.d/05-foreman.conf \
      -e "s/ABP_FQDN/${ABP_FQDN}/g" /etc/httpd/conf.d/05-foreman-ssl.conf \
      -e "s/ABP_FQDN/${ABP_FQDN}/g" /etc/httpd/conf/httpd.conf \
      -e "s/ABP_FQDN/${ABP_FQDN}/g" /etc/foreman/settings.yaml \
      -e "s/ABP_FQDN/${ABP_FQDN}/g" /etc/hammer/cli.modules.d/foreman.yml \
      -e "s/ABP_DB_FQDN/${ABP_DB_FQDN}/g" -e "s/ABP_DB_NAME/${ABP_DB_NAME}/g" \
      -e "s/ABP_DB_USER/${ABP_DB_USER}/g" -e "s/ABP_DB_PW/${ABP_DB_PW}/g" /etc/foreman/database.yml && sleep 1

  echo "Initial setup completed."
  touch /etc/.setupcompleted
fi

if [ ! -f "/etc/puppetlabs/puppetserver/ca/ca_crt.pem" ] && [ "${ABP_FQDN}" = "${MY_FQDN}" ]; then

  echo "Create CA certs with puppetserver ca setup"
    
  rm -rvf /etc/puppetlabs/* && sleep 1
  cp -rpfv /etc/puppetlabs.orig/* /etc/puppetlabs/ && sleep 1
  
  sed -i \
      -e "s/ABP_FQDN/${ABP_FQDN}/g" /etc/puppetlabs/puppet/puppet.conf \
      -e "s/ABP_FQDN/${ABP_FQDN}/g" /etc/puppetlabs/puppet/foreman.yaml \
      -e "s/ABP_FQDN/${ABP_FQDN}/g" /etc/puppetlabs/puppetserver/conf.d/auth.conf \
      -e "s/ABP_FQDN/${ABP_FQDN}/g" /etc/puppetlabs/puppetserver/conf.d/metrics.conf \
      -e "s/ABP_FQDN/${ABP_FQDN}/g" /etc/puppetlabs/puppetserver/conf.d/webserver.conf && sleep 1
  
  /opt/puppetlabs/bin/puppetserver ca setup \
  --subject-alt-names DNS:${ABP_FQDN},DNS:*.${ABP_DOMAIN},DNS:127.0.0.1 \
  --certname ${ABP_FQDN} \
  --ca-name ${ABP_FQDN} && sleep 1

  /opt/puppetlabs/bin/puppetserver ca generate \
  --certname ${PROXY_FQDN} \
  --subject-alt-names DNS:${PROXY_FQDN},DNS:*.${ABP_DOMAIN},DNS:127.0.0.1 \
  --ttl 3650 --ca-client --force && sleep 1

  /opt/puppetlabs/bin/puppetserver ca generate \
  --certname ${ABP_UI_FQDN} \
  --subject-alt-names DNS:${ABP_UI_FQDN},DNS:*.${ABP_DOMAIN},DNS:127.0.0.1 \
  --ttl 3650 --ca-client --force && sleep 1

  /opt/puppetlabs/bin/puppetserver ca generate \
  --certname ${ABP_QL_FQDN} \
  --subject-alt-names DNS:${ABP_QL_FQDN},DNS:*.${ABP_DOMAIN},DNS:127.0.0.1 \
  --ttl 3650 --ca-client --force && sleep 1
fi

echo "Starting Crond..."
/usr/sbin/crond -n &

echo "Starting SSHD..."
/usr/bin/ssh-keygen -A
SSH_USE_STRONG_RNG=0 /usr/sbin/sshd -D &

# Then exec the container"s main process (what"s set as CMD in the Dockerfile).
exec "$@"
