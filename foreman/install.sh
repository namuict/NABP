#!/bin/bash


CURRENT_DIR=`pwd`

#if [ -f /tmp/run_nabp ]; then
#    echo "The NABP is already installed. if you want to reinstall it, please uninstall it first"
#    exit
#fi

source ./.env

#ORG="Default Organization"
#LOC="Default Location"

ORG="NamuICT"
LOC="Research"


## Setting Firewalld 
systemctl stop firewalld 
systemctl enable docker --now
sleep 1

#firewall-cmd \
#--add-port="80/tcp" --add-port="443/tcp" \
#--add-port="5647/tcp" --add-port="8000/tcp" \
#--add-port="8140/tcp" --add-port="8443/tcp" \
#--add-port="53/udp" --add-port="53/tcp" \
#--add-port="67/udp" --add-port="69/udp" \
#--add-port="514/tcp" --add-port="514/udp"

#firewall-cmd --runtime-to-permanent
#firewall-cmd --reload
#firewall-cmd --list-all


## Load my Docker images
#for file in $CURRENT_DIR/docker_images/*.tar; do
#    echo "Loading $file.."
#    docker load -i "$file"
#done


## Loading my ABP backend 
echo ""
echo "### Loading my ABP Backend ###" 
docker-compose run --rm app sudo -u foreman -E foreman-rake db:create db:migrate
sleep 1

docker-compose run --rm app sudo -u foreman -E foreman-rake db:seed permissions:reset password=root123
if [ $? -ne 0 ]; then
  echo "❌ Error: Restart this script after Uninstall" 
  exit 1
fi
sleep 10

docker-compose up -d  

sleep 5
## Set Puppetlabs
docker-compose exec -it web bash -c "
rm -f \
  /etc/puppetlabs/puppet/ssl/certs/${PROXY_FQDN}.pem \
  /etc/puppetlabs/puppet/ssl/private_keys/${PROXY_FQDN}.pem \
  /etc/puppetlabs/puppet/ssl/public_keys/${PROXY_FQDN}.pem \
  /etc/puppetlabs/puppetserver/ca/signed/${PROXY_FQDN}.pem"

sleep 15

docker-compose exec -it web ls /etc/puppetlabs/puppet/ssl/certs/*


docker-compose exec -it web /opt/puppetlabs/bin/puppetserver ca generate \
--certname ${PROXY_FQDN} \
--subject-alt-names DNS:${PROXY_FQDN},DNS:*.${ABP_DOMAIN} \
--ttl 3650 --ca-client --force

sleep 5

docker-compose exec -it web \
bash -c "
tar -C /etc -cvpf /tmp/cert-${PROXY_FQDN}.tar \
puppetlabs/puppet/ssl/certs/ca.pem \
puppetlabs/puppet/ssl/certs/${PROXY_FQDN}.pem \
puppetlabs/puppetserver/ca/signed/${PROXY_FQDN}.pem \
puppetlabs/puppet/ssl/private_keys/${PROXY_FQDN}.pem \
puppetlabs/puppet/ssl/public_keys/${PROXY_FQDN}.pem \
puppetlabs/puppet/ssl/crl.pem"

docker-compose cp web:/tmp/cert-${PROXY_FQDN}.tar ./
docker-compose exec -it web rm -f /tmp/cert-${PROXY_FQDN}.tar
tar xvpf ./cert-abpproxy.example.com.tar

docker-compose -f docker-compose-proxy.yml up -d  
if [ $? -ne 0 ]; then
  echo "❌ Error: Restart this script after Uninstall" 
  exit 1
fi
sleep 20


## Set gloabal variables 
ABP_FQDN=${ABP_NAME}.${ABP_DOMAIN}
ABP_IP=$(docker-compose exec -it web ip a s | grep 'scope global' | awk '{print $2}' | awk -F'/' '{print $1}')
ABP_PREFIX=$(docker-compose exec -it web ip a s | grep 'scope global' | awk '{print $2}' | awk -F'/' '{print $2}')
ABP_MAC=$(docker-compose exec -it web ip a s | grep 'link/ether' | awk '{print $2}')

#PROXY_IP=$(docker-compose exec -it proxy ip a s | grep 'scope global' | awk '{print $2}' | awk -F'/' '{print $1}')
#PROXY_MAC=$(docker-compose exec -it proxy ip a s | grep 'link/ether' | awk '{print $2}')

PROXY_IP=$(docker-compose exec -it dhcp ip a s | grep 'scope global' | grep $PROXY_TFTP_IP | awk '{print $2}' | cut -d'/' -f1)
#if [ "$PROXY_IP"XX != XX ]; then
#    PROXY_IP=$ABP_EXTERNAL_IP_ADDR
#fi
PROXY_MAC=$(docker-compose exec -it dhcp ip a s | grep $PROXY_TFTP_IP -B 3 | grep 'link/ether' | awk '{print $2}')


NET_GWDEVICE=$(docker-compose exec -it web ip route list | awk '/^default/ {print $5}'); sleep 1
NET_GWIP=$(docker-compose exec -it web ip route list | awk '/^default/ {print $3}'); sleep 1
NET_IPSUBNET=$(docker-compose exec -it web ip -o -f inet addr show ${NET_GWDEVICE} | awk '{print $4}'); sleep 1
NET_NETSUBNET=$(docker-compose exec -it web ip route list | grep "${NET_GWDEVICE}" | grep -v default | awk '{print $1}'); sleep 1
ABP_IP_ADDR=$(echo ${NET_IPSUBNET} | awk -F'/' '{print $1}')
ABP_IP_NET=$(echo ${NET_NETSUBNET} | awk -F'/' '{print $1}')
ABP_IP_MASK=$(ipcalc -4 -m ${NET_NETSUBNET} | awk -F'=' '/^NETMASK/ {print $2}')
ABP_IP_PREFIX=$(ipcalc -4 -p ${NET_NETSUBNET} | awk -F'=' '/^PREFIX/ {print $2}')

PROXY_NET_GWDEVICE=$PROXY_PXE_DEV
PROXY_NET_GWIP=$(docker-compose exec -it dhcp ip route list | grep ^default | grep ${PROXY_NET_GWDEVICE} |  awk '/^default/ {print $3}'); sleep 1
PROXY_NET_IPSUBNET=$(docker-compose exec -it dhcp ip -o -f inet addr show ${PROXY_NET_GWDEVICE} | awk '{print $4}'); sleep 1
PROXY_NET_NETSUBNET=$(docker-compose exec -it dhcp ip route list | grep "${PROXY_NET_GWDEVICE}" | grep -v default | awk '{print $1}'); sleep 1
PROXY_ABP_IP_ADDR=$(echo ${PROXY_NET_IPSUBNET} | awk -F'/' '{print $1}')
PROXY_ABP_IP_NET=$(echo ${PROXY_NET_NETSUBNET} | awk -F'/' '{print $1}')
PROXY_ABP_IP_MASK=$(ipcalc -4 -m ${PROXY_NET_NETSUBNET} | awk -F'=' '/^NETMASK/ {print $2}')
PROXY_ABP_IP_PREFIX=$(ipcalc -4 -p ${PROXY_NET_NETSUBNET} | awk -F'=' '/^PREFIX/ {print $2}')



echo ABP_EXTERNAL_IP_ADDR $ABP_EXTERNAL_IP_ADDR
echo PROXY_IP $PROXY_IP
echo PROXY_MAC $PROXY_MAC
echo NET_GWDEVICE $NET_GWDEVICE
echo NET_GWIP $NET_GWIP
echo NET_IPSUBNET $NET_IPSUBNET
echo NET_NETSUBNET $NET_NETSUBNET
echo ABP_IP_ADDR $ABP_IP_ADDR
echo ABP_IP_NET $ABP_IP_NET
echo ABP_IP_MASK $ABP_IP_MASK
echo ABP_IP_PREFIX $ABP_IP_PREFIX

echo PROXY_NET_GWDEVICE $PROXY_NET_GWDEVICE
echo PROXY_NET_GWIP $PROXY_NET_GWIP
echo PROXY_NET_IPSUBNET $PROXY_NET_IPSUBNET
echo PROXY_NET_NETSUBNET $PROXY_NET_NETSUBNET
echo PROXY_ABP_IP_ADDR $PROXY_ABP_IP_ADDR
echo PROXY_ABP_IP_NET $PROXY_ABP_IP_NET
echo PROXY_ABP_IP_MASK $PROXY_ABP_IP_MASK
echo PROXY_ABP_IP_PREFIX $PROXY_ABP_IP_PREFIX

## Set my ABP configs 
echo ""
echo "### Set my NABP configs ###"
docker-compose exec -it web hammer organization create --name NamuICT
sleep 1
docker-compose exec -it web hammer location create --name Research
sleep 1
docker-compose exec -it web hammer user update --organization NamuICT --location Research --locale en --default-location Research --default-organization NamuICT --timezone Seoul --login admin
sleep 1
docker-compose exec -it web hammer os create --name AlmaLinux --major 8 --minor 9 --family Redhat --architecture-ids 1
sleep 1
docker-compose exec -it web hammer puppet-environment create --name production --locations Research --organizations NamuICT
sleep 1
docker-compose exec -it web hammer domain create --name example.com --organization NamuICT --location Research
sleep 1
docker-compose exec -it web hammer settings set --name 'remote_execution_connect_by_ip' --value 'true'
sleep 1
docker-compose exec -it web hammer settings set --name 'safemode_render' --value 'false'
sleep 1
docker-compose exec -it web hammer settings set --name 'append_domain_name_for_hosts' --value 'false'


#SETUP_PROXY=$(docker-compose exec -it proxy systemctl status setup-proxy | grep Active | awk '{print $2}')
#if [ $SETUP_PROXY != "active" ]; then
#    # Start Setup_proxy 
#    echo "### Start setup-proxy in my smart-proxy ###"
#    docker-compose exec -it proxy systemctl start setup-proxy
#    sleep 1
#    docker-compose exec -it proxy systemctl status setup-proxy --no-pager
#    sleep 5
#fi


## Create a smart proxy 
echo ""
echo "### Create a smart proxy ###"
docker-compose exec -it web \
bash -c "
hammer proxy create \
--name abpproxy \
--url https://${PROXY_FQDN}:8443 \
--location Research \
--organization NamuICT \
"

sleep 1


## Create web subnet
echo ""
echo "### Create a service subnet ###"
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
sleep 1


## Create a host
echo ""
echo "### Create a service host(abpmaster) ###"
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
sleep 1



## Create a Proxy Subnet 
echo ""
echo "### Create a proxy subnet(abpproxy) ###"
docker-compose exec -it web \
hammer subnet create \
--name "${PROXY_ABP_IP_NET}/${PROXY_ABP_IP_MASK}" \
--network-type "IPv4" \
--network "${PROXY_ABP_IP_NET}" \
--prefix "${PROXY_ABP_IP_PREFIX}" \
--mask "${PROXY_ABP_IP_MASK}" \
--gateway "${PROXY_NET_GWIP}" \
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
sleep 1


PROXY_SUBNET_ID=$(docker-compose exec -T web hammer --no-headers --output csv subnet info --name "${PROXY_ABP_IP_NET}/${PROXY_ABP_IP_MASK}" --fields Id | tr -d '[:space:]')
## Create a Proxy 
echo ""
echo "### Create a proxy host(abpproxy) ###"
docker-compose exec -T web bash -c "
hammer host create \
--name '${PROXY_FQDN}' \
--organization 'NamuICT' \
--location 'Research' \
--puppet-environment 'production' \
--managed no \
--build no \
--architecture-id 1 \
--operatingsystem-id 1 \
--interface mac='${PROXY_MAC}',ip='${PROXY_IP}',identifier='eth0',type='interface',primary=true,provision=true,execution=true,subnet_id=${PROXY_SUBNET_ID},domain_id=1,name='${PROXY_FQDN}'
"

sleep 1




#################  Create a lo-Proxy ####################

echo "### Create a lo-proxy(lo-abpproxy) ###"
#PROXY_ID=$(docker-compose exec -it web hammer --no-headers --output csv proxy info --name "${PROXY_FQDN}" --fields Id)
PROXY_ID=$(docker-compose exec -it web hammer --no-headers --output csv proxy info --name "abpproxy" --fields Id)
sleep 1
docker-compose exec -T web hammer subnet create \
  --name "lo-abpproxy" \
  --network-type "IPv4" \
  --network "127.0.0.0" \
  --prefix "8" \
  --mask "255.0.0.0" \
  --remote-execution-proxy-ids "${PROXY_ID}" \
  --template-id "${PROXY_ID}" \
  --ipam "None" \
  --mtu "65536" \
  --boot-mode "Static" \
  --organization "${ORG}" \
  --location "${LOC}"
sleep 2

echo "### Create a lo-proxy host(lo-abpproxy) ###"
#SUBNET_ID=$(docker-compose exec -it web hammer --no-headers --output csv subnet info --name "lo-${PROXY_FQDN}" --fields Id)
SUBNET_ID=$(docker-compose exec -T web hammer --no-headers --output csv subnet info --name "lo-abpproxy" --fields Id | tr -d '[:space:]')
sleep 1
echo SUBNET_ID $SUBNET_ID
docker-compose exec -T web bash -c "
hammer host create \
--name lo-abpproxy \
--organization '${ORG}' \
--location '${LOC}' \
--managed no \
--build no \
--architecture-id 1 \
--operatingsystem-id 1 \
--interface 'type=interface,ip=127.0.0.1,primary=true,provision=true,execution=true,managed=false,subnet_id=${SUBNET_ID},name=lo-abpproxy'
"

sleep 1


## Set access token
echo ""
echo "### Set access token ###"
expired_date=`date -d "+1 years" "+%Y-%m-%d"`
access_token=`docker-compose exec -it app hammer user access-token create --name admin --expires-at $expired_date --user admin | cut -d":" -f2 | tr -d '[:space:]'`
docker-compose exec -it app hammer global-parameter set --name personal_access_token --value "$access_token"
sleep 1 
docker-compose exec -it app hammer global-parameter set --name personal_access_user --value admin


## Set dhcprelay
#echo ""
#echo "### Set DHCP realy ###" 
#sh ./scripts/f39/dhcp_relay_start.sh

## Set proxy sshkey to web & hosts (설치 호스트 ~/.ssh/authorized_keys)
sshkey=`docker-compose exec proxy cat ~/.ssh/authorized_keys`
docker-compose exec web mkdir ~/.ssh
docker-compose exec web chmod 700 ~/.ssh
docker-compose exec web touch  ~/.ssh/authorized_keys
docker-compose exec web sh -c "echo \"$sshkey\" >> ~/.ssh/authorized_keys"
docker-compose exec web chmod 600 ~/.ssh/authorized_keys

echo "$sshkey" >> ~/.ssh/authorized_keys  # to HOST 


## Forwarding host ip local proxy
#default_interface=$(ip route | grep default | awk '{print $5}')
#echo "Default Interface: $default_interface"
#host_ip=$(ip a s | grep "$default_interface" | grep -A1 "^[0-9]\+: $default_interface:" | grep 'inet ' | head -n1 | awk '{print $2}' | cut -d/ -f1)
#echo "Host IP: $host_ip"
#docker-compose exec proxy bash -c "echo '${host_ip} abpmaster.example.com abpmaster' > /root/abpmaster"


## Import my ABP templates 
echo ""
echo "### Importing my ABP Templates ###"
CONTAINER_NAME="app"
SOURCE_FILE="./configs/abp-setup/abp-rawdata-release.tar"
DEST_PATH="/root/"

echo "🚀 Copying $SOURCE_FILE to $CONTAINER_NAME:$DEST_PATH..."
docker-compose cp "$SOURCE_FILE" "$CONTAINER_NAME:$DEST_PATH"

COMMANDS="
cd /root/ &&
tar xvf abp-rawdata-release.tar &&
cd abp-rawdata-release &&
sh abp-restore.bash
"

echo "🚀 Executing commands inside $CONTAINER_NAME..."
docker-compose exec "$CONTAINER_NAME" /bin/bash -c "$COMMANDS"

echo "🚀 Restore process completed successfully."


## Set my ABP template config 
DB_CONTAINER="db"               
DB_USER="foreman"               
DB_NAME="foreman"               
DB_HOST="abpdb.example.com"     

SQL_COMMAND="UPDATE templates SET \"default\" = 't'; COMMIT;"

echo "🚀 Executing SQL update on PostgreSQL..."
docker-compose exec -T "$DB_CONTAINER" psql -h "$DB_HOST" -U "$DB_USER" -d "$DB_NAME" -c "$SQL_COMMAND"
echo "🚀 Update completed successfully."


## Restrict permission from being executed 
echo ""
echo "### Restrict permission from being executed ###"
ENV_FILE=".env"

CHANGE_SCRIPT="/root/abp-rawdata-release/change_org_loc.sh"
LOCK_SCRIPT="/root/abp-rawdata-release/lock.sh"

# 컨테이너 서비스 이름 (docker-compose.yml에서 확인)
APP_CONTAINER="app"

if [[ ! -f "$ENV_FILE" ]]; then
    echo "❌ Error: Not found $ENV_FILE."
    exit 1
fi

ABP_IP=$(grep "^ABP_EXTERNAL_IP_ADDR" "$ENV_FILE" | cut -d '=' -f2)

if ! docker-compose exec -T "$APP_CONTAINER" test -f "$CHANGE_SCRIPT"; then
    echo "❌ Error: Not found $CHANGE_SCRIPT."
    exit 1
fi

echo "🚀 Updating Backend_URL in $CHANGE_SCRIPT inside container..."
docker-compose exec -T "$APP_CONTAINER" /bin/bash -c "sed -i 's|^FOREMAN_URL=.*|FOREMAN_URL=\"https://$ABP_IP\"|' $CHANGE_SCRIPT"

echo "🚀 Updated Backend_URL to https://$ABP_IP"
docker-compose exec -T "$APP_CONTAINER" grep "^FOREMAN_URL" "$CHANGE_SCRIPT"

echo "🚀 Running $CHANGE_SCRIPT inside $APP_CONTAINER..."
docker-compose exec -T "$APP_CONTAINER" /bin/bash -c "sh $CHANGE_SCRIPT"

echo "🚀 Updating Backend_URL in $LOCK_SCRIPT inside container..."
docker-compose exec -T "$APP_CONTAINER" /bin/bash -c "sed -i 's|^FOREMAN_URL=.*|FOREMAN_URL=\"https://$ABP_IP\"|' $LOCK_SCRIPT"

echo "🚀 Updated Backend_URL to https://$ABP_IP"
docker-compose exec -T "$APP_CONTAINER" grep "^FOREMAN_URL" "$LOCK_SCRIPT"

echo "🚀 Running $LOCK_SCRIPT inside $APP_CONTAINER..."
docker-compose exec -T "$APP_CONTAINER" /bin/bash -c "sh $LOCK_SCRIPT"

#echo "🚀 Copying systemctl lib script to /lib ..."
#cp ./scripts/f39/nabp.service /lib/systemd/system/ && ln -s /lib/systemd/system/nabp.service /lib/systemd/system/multi-user.target.wants/nabp.service
#cp ./scripts/f39/nabp.service /bin/
#chmod +x /bin/nabp.service

systemctl enable nabp
systemctl start nabp
systemctl status nabp

echo "🚀 Process completed successfully."


## Set Media Path
docker-compose exec web -hammer medium update --name RHEL-8.9-x86_64 --path http://${ABP_EXTERNAL_IP_ADDR}/EFI/pub/rhel-8.9-x86_64-dvd

## Set Foreman URL
docker-compose exec web hammer settings set --name "foreman_url" --value "https://${ABP_EXTERNAL_IP_ADDR}"

