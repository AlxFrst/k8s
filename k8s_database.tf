resource "proxmox_vm_qemu" "k8s_database" {
  count       = var.database_count
  name        = "${var.pm_vm_name_prefix}-database"
  target_node = var.pm_node
  clone       = var.pm_template_name
  agent       = 1
  os_type     = "cloud-init"
  cores       = var.database_cores
  sockets     = 1
  cpu         = "host"
  memory      = var.database_memory
  scsihw      = "virtio-scsi-pci"
  ipconfig0   = "ip=dhcp"
  ciuser      = var.vm_user
  cipassword  = var.vm_password
  sshkeys     = var.ssh_public_key
  qemu_os     = "l26"
  disk {
    slot    = 0
    size    = var.database_disk_size
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
      "echo 'Starting database VM Provisioner 🚀'",
      "until sudo apt-get update; do echo 'apt-get update failed, retrying...'; sleep 5; done",
      "until sudo apt-get install -y mysql-server; do echo 'mysql-server installation failed, retrying...'; sleep 5; done",

      // Modifier la configuration de MySQL pour écouter sur toutes les interfaces
      "sudo sed -i 's/^bind-address\\s*=\\s*127\\.0\\.0\\.1/bind-address = 0.0.0.0/' /etc/mysql/mysql.conf.d/mysqld.cnf",

      // Redémarrer le service MySQL pour appliquer les changements
      "sudo systemctl restart mysql",

      // Configurer un nouvel utilisateur MySQL
      "echo 'Creating MySQL user'",
      "sudo mysql -e \"CREATE USER '${var.database_user}'@'%' IDENTIFIED BY '${var.database_password}';\"",
      "echo 'Granting privileges to MySQL user'",
      "sudo mysql -e \"GRANT ALL PRIVILEGES ON *.* TO '${var.database_user}'@'%' WITH GRANT OPTION;\"",
      "echo 'Flushing privileges'",
      "sudo mysql -e \"FLUSH PRIVILEGES;\"",
      "echo 'MySQL user created'",
      "echo 'Database VM Provisioner Complete 🎉'",
    ]
  }
}
