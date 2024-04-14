#!/bin/bash

/opt/namuict/abp/abp-setup.bash 2>&1 | grep -v -w '.aprc' | tee -a /opt/namuict/abp/abp-install.log
