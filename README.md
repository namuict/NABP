# NABP v3.5.0

This branch contains the **NABP v3.5.0** source code.

NABP (NamuICT Baremetal Platform) is a bare-metal provisioning and lifecycle management platform developed by **NamuICT**.  
As of **February 2026**, v3.5.0 is considered the **current stable release** of NABP.

---

### foreman
The **core engine of NABP**.  
This directory contains the main logic and templates used to integrate with
Foreman for bare-metal provisioning, lifecycle management, and automation.

- `template/`  
  Foreman job templates and provisioning templates used by NABP

### proxy
Implements the **Foreman proxy role** for NABP.  
This component handles proxy services required during provisioning, including
network-related services and communication between Foreman and target hosts.

### install_packages
A collection of **installation packages required to deploy NABP in air-gapped
or disconnected environments**.  
This directory is intended for environments without direct internet access.

---

## Usage

To clone this stable release:

```bash
git clone --branch v3.5.0 https://github.com/namuict/NABP.git
