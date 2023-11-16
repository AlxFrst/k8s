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
  sshkeys     = var.ssh_publickey
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
      private_key = var.ssh_privatekey
      host        = self.ssh_host
    }
    inline = [
      # create the .ssh folder
      "sudo mkdir -p /home/${var.vm_user}/.ssh",
      "sudo chown -R ${var.vm_user}:${var.vm_user} /home/${var.vm_user}/.ssh",
      "sudo chmod 700 /home/${var.vm_user}/.ssh",
      "echo '${var.ssh_privatekey}' > /home/${var.vm_user}/.ssh/id_rsa",
      "sed -i 's/\\n//g' /home/${var.vm_user}/.ssh/id_rsa", #remove this line if your private key is not on multiple lines
      "sudo chmod 600 /home/${var.vm_user}/.ssh/id_rsa",

      
    ]
  }

}
