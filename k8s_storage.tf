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
  sshkeys     = var.ssh_public_key
  qemu_os     = "l26"
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
      "until sudo apt-get update; do echo 'apt-get update failed, retrying...'; sleep 5; done",
      "until sudo apt-get install -y nfs-kernel-server; do echo 'nfs-kernel-server installation failed, retrying...'; sleep 5; done",
      "sudo mkdir -p /mnt/nfs-share",
      "sudo chown nobody:nogroup /mnt/nfs-share",
      "sudo chmod 777 /mnt/nfs-share",
      "echo '/mnt/nfs-share 192.168.1.0/24(rw,sync,no_subtree_check,no_root_squash)' | sudo tee -a /etc/exports",
      "sudo exportfs -a",
      "sudo systemctl restart nfs-kernel-server",
      "sudo systemctl enable nfs-kernel-server",
      "echo 'Storage VM Provisioner Complete 🎉'",
    ]
  }
}
