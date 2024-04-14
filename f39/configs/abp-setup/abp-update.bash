#!/bin/bash
source .abpenv

echo -e "Updates to new changed IP addresses..."

MY_IP=$(hostname -I | awk '{print $1}')
MY_IP_DEV=$(ip -oneline -4 addr show scope global | grep $MY_IP | awk '{print $2}')
MY_IP_GW=$(ip route | grep default | grep $MY_IP_DEV | awk '{print $3}')
MY_IP_NET=$(hostname -I | awk -F. '{ print $1, $2, $3, "0" }' OFS='.')

dhcp_network=${dhcp_network:="none"}
dhcp_netmask=${dhcp_netmask:="255.255.255.0"}
EXTERNAL_IP=${EXTERNAL_IP:=${MY_IP}}
ex_port_template=${ex_port_template:=":8000"}

sed -i.bak -e "s/tftp_servername:.*/tftp_servername: ${MY_IP}/g" \
-e "s/dhcp_gateway:.*/dhcp_gateway: ${MY_IP_GW}/g" \
-e "s/dhcp_nameservers:.*/dhcp_nameservers: ${MY_IP}/g" \
-e "s/dhcp_failover_address:.*/dhcp_failover_address: ${MY_IP}/g" \
-e "s/template_url:.*/template_url: http:\/\/${EXTERNAL_IP}${ex_port_template}/g" \
/etc/foreman-installer/scenarios.d/katello-answers.yaml

sed -i.bak -e "s/:tftp_servername:.*/:tftp_servername: ${MY_IP}/g" \
/etc/foreman-proxy/settings.d/tftp.yml

sed -i.bak -e "s/option domain-name-servers.*/option domain-name-servers ${MY_IP}\;/g" \
-e "s/next-server.*/next-server ${MY_IP}\;/g" \
-e "s/http:\/\/.*\/EFI\/grub2\/shimia32\.efi/http:\/\/${EXTERNAL_IP}${ex_port_template}\/EFI\/grub2\/shimia32\.efi/g" \
-e "s/http:\/\/.*\/EFI\/grub2\/shim\.efi/http:\/\/${EXTERNAL_IP}${ex_port_template}\/EFI\/grub2\/shim\.efi/g" \
-e "s/subnet .* netmask 255.255.255.0 {$/subnet ${MY_IP_NET} netmask 255.255.255.0 {/g" \
-e "s/option routers .*/option routers ${MY_IP_GW}\;/g" \
-e "/subnet .* netmask 255.255.255.0 {}$/d" \
/etc/dhcp/dhcpd.conf

echo -e "subnet ${dhcp_network} netmask ${dhcp_netmask} {}" >> /etc/dhcp/dhcpd.conf

sed -i.bak -e "s/template_url:.*/template_url: http:\/\/${EXTERNAL_IP}${ex_port_template}/g" \
/etc/foreman-proxy/settings.d/templates.yml

systemctl restart foreman
systemctl restart foreman-proxy
systemctl restart dhcpd

