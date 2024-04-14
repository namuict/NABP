#!/bin/bash

MY_HOSTNAME=$(hostname -f)
MY_IP=$(hostname -I | awk '{print $1}')

sed -i.bak -e "s/.*\$ModLoad imudp.*/\$ModLoad imudp/g" -e "s/.*\$UDPServerRun.*/\$UDPServerRun 514/g" -e "s/.*\$ModLoad imtcp.*/\$ModLoad imtcp/g" -e "s/.*\$InputTCPServerRun.*/\$InputTCPServerRun 514/g" -e "/.*\$InputTCPServerRun.*/a \\n\$template RemoteLogs,\"/var/log/abp/%fromhost-ip%.log\"\n*.* ?RemoteLogs\n& STOP\n" /etc/rsyslog.conf
systemctl restart rsyslog

echo "[ABP-SETUP] ABP install Completed."

