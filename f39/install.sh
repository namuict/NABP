#!/bin/bash
source ./.env

ABP_FQDN=${ABP_NAME}.${ABP_DOMAIN}
ABP_IP=$(docker-compose exec -it web ip a s | grep 'scope global' | awk '{print $2}' | awk -F'/' '{print $1}')
ABP_PREFIX=$(docker-compose exec -it web ip a s | grep 'scope global' | awk '{print $2}' | awk -F'/' '{print $2}')
ABP_MAC=$(docker-compose exec -it web ip a s | grep 'link/ether' | awk '{print $2}')
PROXY_IP=$(docker-compose exec -it proxy ip a s | grep 'scope global' | awk '{print $2}' | awk -F'/' '{print $1}')
PROXY_MAC=$(docker-compose exec -it proxy ip a s | grep 'link/ether' | awk '{print $2}')

docker-compose exec -it web hammer organization create --name NamuICT
docker-compose exec -it web hammer location create --name Research
docker-compose exec -it web hammer user update --organization NamuICT --location Research --locale en --default-location Research --default-organization NamuICT --timezone Seoul --login admin
docker-compose exec -it web hammer os create --name AlmaLinux --major 8 --minor 9 --family Redhat --architecture-ids 1
docker-compose exec -it web hammer puppet-environment create --name production --locations Research --organizations NamuICT
docker-compose exec -it web hammer domain create --name example.com --organization NamuICT --location Research




docker-compose exec -it web hammer settings set --name 'remote_execution_connect_by_ip' --value 'true'
docker-compose exec -it web hammer settings set --name 'safemode_render' --value 'false'

docker-compose exec -it web \
bash -c "
hammer proxy create \
--name ${PROXY_FQDN} \
--url https://${PROXY_FQDN}:8443 \
--location Research \
--organization NamuICT \
"

NET_GWDEVICE=$(docker-compose exec -it web ip route list | awk '/^default/ {print $5}')
NET_GWIP=$(docker-compose exec -it web ip route list | awk '/^default/ {print $3}')

NET_IPSUBNET=$(docker-compose exec -it web ip -o -f inet addr show ${NET_GWDEVICE} | awk '{print $4}')

NET_NETSUBNET=$(docker-compose exec -it web ip route list | grep "${NET_GWDEVICE}" | grep -v default | awk '{print $1}')
ABP_IP_ADDR=$(echo ${NET_IPSUBNET} | awk -F'/' '{print $1}')
ABP_IP_NET=$(echo ${NET_NETSUBNET} | awk -F'/' '{print $1}')
ABP_IP_MASK=$(ipcalc -4 -m ${NET_NETSUBNET} | awk -F'=' '/^NETMASK/ {print $2}')
ABP_IP_PREFIX=$(ipcalc -4 -p ${NET_NETSUBNET} | awk -F'=' '/^PREFIX/ {print $2}')

docker-compose exec -it web \
hammer subnet create \
--name "${ABP_IP_NET}/${ABP_IP_MASK}" \
--network-type "IPv4" \
--network "${ABP_IP_NET}" \
--prefix "${ABP_IP_PREFIX}" \
--mask "${ABP_IP_MASK}" \
--gateway "${NET_GWIP}" \
--tftp-id 1 \
--dhcp-id 1 \
--remote-execution-proxy-ids 1 \
--ipam "DHCP" \
--mtu "1500" \
--boot-mode "Static" \
--domains example.com \
--httpboot-id 1 \
--template-id 1 \
--bmc-id 1 \
--organization NamuICT \
--location Research

docker-compose exec -it web \
bash -c "
hammer host create \
--name ${ABP_FQDN} \
--organization NamuICT \
--location Research \
--puppet-environment production \
--managed no \
--build no \
--architecture-id 1 \
--operatingsystem-id 1 \
--interface \"mac=${ABP_MAC}, \
             ip=${ABP_IP}, \
             identifier=eth0, \
             type=interface, \
             primary=true, \
             provision=true, \
             execution=true, \
             subnet_id=1, \
             domain_id=1, \
             name=${ABP_FQDN}\" \
"

docker-compose exec -it web \
bash -c "
hammer host create \
--name ${PROXY_FQDN} \
--organization NamuICT \
--location Research \
--puppet-environment production \
--managed no \
--build no \
--architecture-id 1 \
--operatingsystem-id 1 \
--interface \"mac=${PROXY_MAC}, \
             ip=${PROXY_IP}, \
             identifier=eth0, \
             type=interface, \
             primary=true, \
             provision=true, \
             execution=true, \
             subnet_id=1, \
             domain_id=1, \
             name=${PROXY_FQDN}\" \
"

