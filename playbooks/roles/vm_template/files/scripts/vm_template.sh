#!/bin/bash
# Inhoud: files/scripts/build_proxmox_template.sh

# Stop bij de eerste fout
set -e

# Variabelen die we van Ansible krijgen (zie Stap 2)
VM_ID="$1"
VM_NAME="$2"
IMAGE_FILE_PATH="$3"
STORAGE_POOL="$4"

# 1. Maak de VM aan
qm create $VM_ID --name "$VM_NAME" --memory 2048 --cores 2 --net0 virtio,bridge=vmbr0

# 2. Importeer de disk
qm importdisk $VM_ID $IMAGE_FILE_PATH $STORAGE_POOL

# 3. Koppel de hardware en stel deze in
qm set $VM_ID --scsihw virtio-scsi-pci --scsi0 ${STORAGE_POOL}:vm-${VM_ID}-disk-0
qm set $VM_ID --boot c --bootdisk scsi0
qm set $VM_ID --ide2 ${STORAGE_POOL}:cloudinit
qm set $VM_ID --agent 1
qm set $VM_ID --serial0 socket --vga serial0

# 4. Converteer naar Template
qm template $VM_ID

echo "Template $VM_NAME (ID: $VM_ID) succesvol aangemaakt."