#!/bin/bash

#if [ ! -f /tmp/run_nabp ]; then
#    echo "The NABP is not installed. if you want to uninstall it, please install it first."
#    exit
#fi

## Unloading my ABP front & backend 
docker-compose exec -it app rm -rvf /etc/puppetlabs/* 
rm -rf ./puppetlabs/*
rm -f ./cert-abpproxy.example.com.tar
docker-compose down -v 
docker-compose -f docker-compose-proxy.yml down -v


## Unloading my DHCP relay safely
#if docker ps -q --filter "name=ABP_DHCP_Relay" | grep -q .; then
#    docker stop $(docker ps -q --filter "name=ABP_DHCP_Relay") 2>/dev/null
#    docker rm $(docker ps -aq --filter "name=ABP_DHCP_Relay") 2>/dev/null
#    echo "dhcprelay container stopped and removed."
#else
#    echo "No running dhcprelay container found."
#fi

rm -f /tmp/run_nabp
