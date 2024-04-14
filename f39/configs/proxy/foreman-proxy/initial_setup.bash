#!/bin/bash
set -e

source /etc/foreman-proxy/.setup_env

PROXY_FQDN=$(uname -n)
ABP_FQDN=${ABP_NAME}.${ABP_DOMAIN}

if [ _"${ABP_EXTERNAL_IP_ADDR}" = _ ]; then echo "Environment parameter ABP_EXTERNAL_IP_ADDR does not exist."; exit 1; fi
if [ _"${PROXY_FQDN}" = _ ]; then echo "Proxy hostname PROXY_FQDN does not exist."; exit 1; fi
if [ _"${ABP_NAME}" = _ ]; then echo "Environment parameter ABP_NAME does not exist."; exit 1; fi
if [ _"${ABP_DOMAIN}" = _ ]; then echo "Environment parameter ABP_DOMAIN does not exist."; exit 1; fi

NET_GWDEVICE=$(ip route list | awk '/^default/ {print $5}')
NET_GWIP=$(ip route list | awk '/^default/ {print $3}')
NET_IPSUBNET=$(ip -o -f inet addr show ${NET_GWDEVICE} | awk '{print $4}')
NET_NETSUBNET=$(ip route list | grep "${NET_GWDEVICE}" | grep -v default | awk '{print $1}')
ABP_IP_ADDR=$(echo ${NET_IPSUBNET} | awk -F'/' '{print $1}')
ABP_IP_NET=$(echo ${NET_NETSUBNET} | awk -F'/' '{print $1}')
ABP_IP_MASK=$(ipcalc -4 -m ${NET_NETSUBNET} | awk -F'=' '/^NETMASK/ {print $2}')

sleep 1
# Run setup only at the first time.
if [ ! -f "/etc/.setupcompleted" ]; then

  echo "Run setup only at the first time."

  sed -i \
      -e "s/ABP_EXTERNAL_IP_ADDR/${ABP_EXTERNAL_IP_ADDR}/g" \
      -e "s/ABP_IP_NET/${ABP_IP_NET}/g" \
      -e "s/ABP_IP_MASK/${ABP_IP_MASK}/g" \
      -e "s/NET_GWIP/${NET_GWIP}/g" /etc/dhcp/dhcpd.conf \
      -e "s/ABP_EXTERNAL_IP_ADDR/${ABP_EXTERNAL_IP_ADDR}/g" /etc/foreman-proxy/settings.d/templates.yml \
      -e "s/ABP_EXTERNAL_IP_ADDR/${ABP_EXTERNAL_IP_ADDR}/g" /etc/foreman-proxy/settings.d/tftp.yml \
      -e "s/NET_GWDEVICE/${NET_GWDEVICE}/g" /etc/systemd/system/dhcpd.service.d/interfaces.conf \
      -e "s/PROXY_FQDN/${PROXY_FQDN}/g" /etc/foreman-proxy/settings.d/dns_nsupdate_gss.yml \
      -e "s/PROXY_FQDN/${PROXY_FQDN}/g" /etc/foreman-proxy/settings.d/puppet_proxy_puppet_api.yml \
      -e "s/PROXY_FQDN/${PROXY_FQDN}/g" /etc/foreman-proxy/settings.d/puppetca_http_api.yml \
      -e "s/PROXY_FQDN/${PROXY_FQDN}/g" -e "s/ABP_FQDN/${ABP_FQDN}/g" /etc/foreman-proxy/settings.yml \
      -e "s/PROXY_FQDN/${PROXY_FQDN}/g" -e "s/ABP_FQDN/${ABP_FQDN}/g" /etc/foreman-proxy/ansible.env && sleep 1

  echo "Proxy initial setup completed."
  touch /etc/.setupcompleted
fi

sleep 1
if [ ! -f "/etc/puppetlabs/puppet/ssl/certs/${PROXY_FQDN}.pem" ]; then
    echo "CA certs of proxy does not exist."
    echo "Check cert file /etc/puppetlabs/puppet/ssl/certs/${PROXY_FQDN}.pem exist."
fi

sleep 1
systemctl daemon-reload
sleep 1
systemctl start dhcpd.service
sleep 1
systemctl start foreman-proxy.service
