#!/bin/bash
source /opt/namuict/abp/.abpenv

MY_IP=$(hostname -I | awk '{print $1}')
MY_IP_DEV=$(ip -oneline -4 addr show scope global | grep $MY_IP | awk '{print $2}')
MY_IP_GW=$(ip route | grep default | grep $MY_IP_DEV | awk '{print $3}')
# If you want to override
# MY_IP="10.1.1.10"
# MY_IP_DEV="eth0"

organization=${organization:="NamuICT"}
location=${location:="Research"}
admin_username=${admin_username:="admin"}
admin_password=${admin_password:="root123"}
domainname=${domainname:="example.com"}
certs_country=${certs_country:="KR"}
certs_state=${certs_state:="gyeonggido"}
certs_city=${certs_city:="suwon"}
dhcp_network=${dhcp_network:="none"}
dhcp_netmask=${dhcp_netmask:="255.255.255.0"}
MY_TIMEZONE=${MY_TIMEZONE:="Asia/Seoul"}
EXTERNAL_IP=${EXTERNAL_IP:=${MY_IP}}
ex_port_template=${ex_port_template:=":8000"}         


MY_IP_REV=$(hostname -I | awk -F. '{ print $3, $2, $1 }' OFS='.')

timedatectl set-timezone ${MY_TIMEZONE}

#foreman-installer \
#--scenario katello \
#--disable-system-checks \
#--foreman-initial-organization "${organization}" \
#--foreman-initial-location "${location}" \
#--foreman-initial-admin-username "${admin_username}" \
#--foreman-initial-admin-password "${admin_password}" \
#--enable-foreman \
#--enable-foreman-cli \
#--enable-puppet \
#--enable-foreman-proxy \
#--enable-foreman-plugin-templates \
#--enable-foreman-cli-templates \
#--foreman-proxy-bmc "true" \
#--foreman-proxy-bmc-default-provider "freeipmi" \
#--foreman-proxy-dns "true" \
#--foreman-proxy-dns-managed "true" \
#--foreman-proxy-dns-forwarders "8.8.8.8; 8.8.4.4" \
#--foreman-proxy-dns-interface "${MY_IP_DEV}" \
#--foreman-proxy-dns-reverse "${MY_IP_REV}.in-addr.arpa" \
#--foreman-proxy-dns-server "127.0.0.1" \
#--foreman-proxy-dns-zone "${domainname}" \
#--foreman-proxy-dhcp true \
#--foreman-proxy-dhcp-managed "true" \
#--foreman-proxy-dhcp-interface "${MY_IP_DEV}" \
#--foreman-proxy-dhcp-gateway "${MY_IP_GW}" \
#--foreman-proxy-dhcp-nameservers "${MY_IP}" \
#--foreman-proxy-tftp "true" \
#--foreman-proxy-tftp-managed "true" \
#--foreman-proxy-tftp-servername "${MY_IP}" \
#--foreman-proxy-puppet "true" \
#--enable-foreman-compute-libvirt \
#--enable-foreman-compute-vmware \
#--foreman-proxy-registration "true" \
#--foreman-proxy-templates "true" \
#--foreman-proxy-http "true" \
#--foreman-proxy-httpboot "true" \
#--foreman-proxy-templates-listen-on both \
#--foreman-proxy-template-url="http://${EXTERNAL_IP}${ex_port_template}" \
#--enable-foreman-plugin-ansible \
#--enable-foreman-proxy-plugin-ansible \
#--enable-foreman-plugin-remote-execution \
#--enable-foreman-proxy-plugin-remote-execution-ssh \
#--enable-foreman-cli-remote-execution \
#--enable-foreman-plugin-bootdisk \
#--certs-country "${certs_country}" \
#--certs-state "${certs_state}" \
#--certs-city "${certs_city}"

#if [ $? -ne 0 ]; then exit 1; fi

if [ ${dhcp_network} != "none" ]; then echo "subnet ${dhcp_network} netmask ${dhcp_netmask} {}" >> /etc/dhcp/dhcpd.conf; fi
echo 'deny unknown-clients;' >> /etc/dhcp/dhcpd.conf

chown -R root:foreman-proxy /etc/dhcp
systemctl restart dhcpd

echo "[ABP-SETUP] foreman install completed"

