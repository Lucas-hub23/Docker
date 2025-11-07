#!/bin/bash
#files/scripts/cloud_init.sh

set -e

VM_ID="$1"
CI_USER="$2"
CI_PASSWORD="$3"
CI_SSHKEY="$4"
CI_IP_PREFIX="$5"
CI_GATEWAY="$6"


qm set $VM_ID --ciuser ${CI_USER}
qm set $VM_ID --cipassword ${CI_PASSWORD}
qm set $VM_ID --sshkey ${CI_SSHKEY}          
qm set $VM_ID --ipconfig0 ip=${CI_IP_PREFIX}${VM_ID}/24,gw=${CI_GATEWAY}  # let op /24 !
qm set $VM_ID --serial0 socket --vga serial0 --agent 1