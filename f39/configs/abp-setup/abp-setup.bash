#!/bin/bash
hammer settings set --name 'sync_connect_timeout' --value '1200'
hammer settings set --name 'remote_execution_connect_by_ip' --value 'true'
hammer settings set --name 'safemode_render' --value 'false'

hammer settings set --name 'default_locale' --value 'en'
hammer user update --login admin --locale en
hammer domain update --id 1 --dns-id 1

cd /opt/namuict/abp/abp-rawdata-release && sh ./abp-restore.bash

echo -e "\nNNNNNNNNNNAAAAAAAAAAMMMMMMMMMMUUUUUUUUUU AAAAAAAAAABBBBBBBBBBPPPPPPPPPP"
echo -e "NNNNNNNNNN         [ABP-SETUP] ABP setup Completed           PPPPPPPPPP"
echo -e "NNNNNNNNNNAAAAAAAAAAMMMMMMMMMMUUUUUUUUUU AAAAAAAAAABBBBBBBBBBPPPPPPPPPP\n"

