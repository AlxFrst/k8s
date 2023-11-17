resource "proxmox_vm_qemu" "k8s_storage" {
  count       = 1
  name        = "${var.pm_vm_name_prefix}-storage"
  target_node = var.pm_node
  clone       = var.pm_template_name
  agent       = 1
  os_type     = "cloud-init"
  cores       = var.storage_cores
  sockets     = 1
  cpu         = "host"
  memory      = var.storage_memory
  scsihw      = "virtio-scsi-pci"
  ipconfig0   = "ip=dhcp"
  ciuser      = var.vm_user
  cipassword  = var.vm_password
  sshkeys = var.ssh_public_key
  disk {
    slot    = 0
    size    = var.storage_disk_size
    type    = "scsi"
    storage = var.pm_storage
  }

  network {
    model  = "virtio"
    bridge = var.pm_bridge
  }
  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      user        = var.vm_user
      private_key = var.ssh_private_key
      host        = self.ssh_host
    }
    inline = [
      "echo 'Starting Storage VM Provisioner 🚀'",
      "sudo apt-get update", # update the apt cache
      "sudo apt-get install -y nfs-kernel-server", # install the nfs server
      "sudo mkdir -p /mnt/nfs_share", # create the nfs share folder
      "sudo chown nobody:nogroup /mnt/nfs_share", # set the owner of the nfs share folder
      "sudo chmod 777 /mnt/nfs_share", # set the permissions of the nfs share folder
      "echo '/mnt/nfs_share *(rw,sync,no_subtree_check,no_root_squash)' | sudo tee -a /etc/exports", # add the nfs share to the exports file
      "sudo exportfs -a", # export the nfs share
      "sudo systemctl restart nfs-kernel-server", # restart the nfs server
      "sudo systemctl enable nfs-kernel-server", # enable the nfs server to start on boot
      "echo 'Storage VM Provisioner Complete 🎉'",
    ]
  }

}
