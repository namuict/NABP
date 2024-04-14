1. Install 
[ git ]
modify redhat.repo 

[BaseOS]
name=CentOS-8 - Base
baseurl=http://vault.centos.org/centos/8.4.2105/BaseOS/x86_64/os/
enabled=1
gpgcheck=0


[AppStream]
name=CentOS-8 - AppStream
baseurl=http://vault.centos.org/centos/8.4.2105/AppStream/x86_64/os/
enabled=1
gpgcheck=0

[root@localhost yum.repos.d]# dnf clean all
[root@localhost yum.repos.d]# dnf makecache
# [root@localhost yum.repos.d]# dnf install git --disablerepo=docker-ce-stable 
[root@localhost yum.repos.d]# dnf install git
[root@localhost yum.repos.d]# dnf install git-lfs
[root@localhost NABP]# git lfs install

[root@localhost ~ ]# git clone https://github.com/namuict/NABP.git
[root@localhost ~ ]# git lfs pull
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
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

   -> [root@localhost KT_Cloud_PKGs]# sh get_file.sh
   -> mv proxy.tar /root/NABP/docker_images
   -> [root@localhost app]# pwd
      /root/NABP/docker_images/app
   -> [root@localhost app]# ls
        blobs  index.json  manifest.json  oci-layout  repositories
      [root@localhost app]# tar cvf app.tar ./*
      [root@localhost app]# mv app.tar /root/NABP/docker_images/

   -> cp KT_Cloud_PKGs/docker-ce.repo /etc/yum.repos.d/  ;  yum repolist all ; dnf makecache
   -> [root@localhost ~]# yum install ./KT_Cloud_PKGs/yum-utils-4.0.21-23.el8.noarch.rpm
   -> [root@localhost ~]# dnf install docker-ce docker-ce-cli containerd.io docker-compose-plugin --disablerepo=* --enablerepo=docker-ce-stable

      dnf install ipcalc --disablerepo=* --enablerepo=docker-ce-stable
   -> [root@localhost ~]# dnf install ./KT_Cloud_PKGs/ipcalc-0.2.4-4.el8.x86_64.rpm
   -> curl -L "https://github.com/docker/compose/releases/download/v2.25.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/bin/docker-compose
   -> chmod +x /usr/bin/docker-compose
   -> docker-compose --version


2. firewalld
firewall-cmd \
--add-port="80/tcp" --add-port="443/tcp" \
--add-port="5647/tcp" --add-port="8000/tcp" \
--add-port="8140/tcp" --add-port="8443/tcp" \
--add-port="53/udp" --add-port="53/tcp" \
--add-port="67/udp" --add-port="69/udp" \
--add-port="514/tcp" --add-port="514/udp"

firewall-cmd --runtime-to-permanent
firewall-cmd --reload
firewall-cmd --list-all


3. ABP 
docker load -i alma-f39-pkg.tar
docker load -i postrgres.tar
docker load -i dhcprelay.tar
docker save -o redis.tar redis
docker load -i alma-f39-proxy-pkg.tar
...

   [ working process ]

   3-1. DB (rake)
   3-2. Template restore 
   3-3. SQL DB
   3-4. install.sh
   3-5. Org/Loc (change_loc_org)
  

3-1. 
[root@nabp-allinone f39]# cat .env 
ABP_NAME=abpmaster
ABP_DOMAIN=example.com
ABP_DB_NAME=foreman
ABP_DB_USER=foreman
ABP_DB_PW=root123
ABP_DB_FQDN=abpdb.example.com
PROXY_FQDN=abpproxy.example.com
ABP_EXTERNAL_IP_ADDR=10.1.13.91   (시작전 IP변경)

source .env

1. docker-compose run --rm app sudo -u foreman -E foreman-rake db:create db:migrate
2. docker-compose run --rm app sudo -u foreman -E foreman-rake db:seed permissions:reset password=root123
3. docker-compose run --rm app sudo -u foreman -E foreman-rake apipie:cache:index
4. docker-compose up -d

sh install.sh 

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



3-2. 
  [ foreman template ] 
  importing (abp-restore.sh)
 [root@AlmaLinux8 f39]#  docker-compose cp ./configs/abp-setup/abp-rawdata-release.tar app:/root
 [root@AlmaLinux8 f39]# docker-compose exec -it app /bin/bash
 [root@abpapp ~]# tar xvf abp-rawdata-release.tar
 abp-rawdata-release/

3-3. 
### docker-compose exec -it db /bin/bash
### psql -h abpdb.example.com -U foreman
### psql
### \c foreman

UPDATE templates SET "default" = 't';
COMMIT;


3-5. ABP 내 Machine Group Location/Organization 수정 
 [root@abpapp ~]#  sh change_loc_org.sh  (시작전 IP 수정)
                   sh lock.sh
DEFAULT_LOCATION_ID=2
DEFAULT_ORGANIZATION_ID=1
NAMUICT_ORGANIZATION_ID=3
RESEARCH_LOCATION_ID=4

http://115.68.131.11:60080/pub