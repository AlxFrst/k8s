resource "proxmox_vm_qemu" "k8s_controller" {
  depends_on  = [proxmox_vm_qemu.k8s_storage]
  count       = 1
  name        = "${var.pm_vm_name_prefix}-controller"
  target_node = var.pm_node
  clone       = var.pm_template_name
  agent       = 1
  os_type     = "cloud-init"
  cores       = var.controller_cores
  sockets     = 1
  cpu         = "host"
  memory      = var.controller_memory
  scsihw      = "virtio-scsi-pci"
  ipconfig0   = "ip=dhcp"
  ciuser      = var.vm_user
  cipassword  = var.vm_password
  sshkeys     = var.ssh_public_key
  qemu_os     = "l26"
  disk {
    slot    = 0
    size    = var.controller_disk_size
    type    = "scsi"
    storage = var.pm_storage
  }

  network {
    model  = "virtio"
    bridge = var.pm_bridge
  }

  # share the assets folder with the VMx
  provisioner "file" {
    connection {
      type        = "ssh"
      user        = var.vm_user
      private_key = var.ssh_private_key
      host        = self.ssh_host
    }
    source      = "assets/installController.sh"
    destination = "/tmp/installController.sh"
  }

  provisioner "file" {
    connection {
      type        = "ssh"
      user        = var.vm_user
      private_key = var.ssh_private_key
      host        = self.ssh_host
    }
    source      = "assets/metallb-config.yaml"
    destination = "/tmp/metallb-config.yaml"
  }

  provisioner "file" {
    connection {
      type        = "ssh"
      user        = var.vm_user
      private_key = var.ssh_private_key
      host        = self.ssh_host
    }
    source      = "assets/gitlab-deployment.yaml"
    destination = "/tmp/gitlab-deployment.yaml"
  }

    provisioner "file" {
    connection {
      type        = "ssh"
      user        = var.vm_user
      private_key = var.ssh_private_key
      host        = self.ssh_host
    }
    source      = "assets/itop.yaml"
    destination = "/tmp/itop.yaml"
  }

    provisioner "file" {
    connection {
      type        = "ssh"
      user        = var.vm_user
      private_key = var.ssh_private_key
      host        = self.ssh_host
    }
    source      = "assets/babybuddy.yaml"
    destination = "/tmp/babybuddy.yaml"
  }

      provisioner "file" {
    connection {
      type        = "ssh"
      user        = var.vm_user
      private_key = var.ssh_private_key
      host        = self.ssh_host
    }
    source      = "assets/mysql.yaml"
    destination = "/tmp/mysql.yaml"
  }

  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      user        = var.vm_user
      private_key = var.ssh_private_key
      host        = self.ssh_host
    }
    inline = [
      "echo 'Starting Controller VM Provisioner 🚀'",
      "chmod +x /tmp/installController.sh",
      "sudo /tmp/installController.sh",
      "sudo kubeadm token create --print-join-command > /tmp/joinCommand.sh",

      # Install helm
      "echo 'Installing Helm'",
      "sudo curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3",
      "sudo bash get_helm.sh",
      "sudo rm get_helm.sh",
      "echo 'Helm installed'",

      # Install Kompose
      "echo 'Installing Kompose'",
      "sudo curl -L https://github.com/kubernetes/kompose/releases/download/v1.31.2/kompose-linux-amd64 -o kompose",
      "sudo chmod +x kompose",
      "sudo mv ./kompose /usr/local/bin/kompose",
      "echo 'Kompose installed'",

      # Install metallb & configure metallb
      "echo 'Installing metallb'",
      "sudo kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.11.0/manifests/namespace.yaml",
      "sudo kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.11.0/manifests/metallb.yaml",
      "sudo sed -i 's/#RANGE#/${var.metallb_ip_range}/g' /tmp/metallb-config.yaml",
      "sudo kubectl apply -f /tmp/metallb-config.yaml",
      "echo 'metallb installed'",
      "echo 'Controller VM Provisioner Complete 🎉'",

      # Store files in the VM
      "sudo mkdir -p /home/${var.vm_user}/clusterFiles",
      "sudo mv /tmp/metallb-config.yaml /home/${var.vm_user}/clusterFiles/metallb-config.yaml",
      "sudo mkdir -p /home/${var.vm_user}/clusterApps",
      "sudo mv /tmp/gitlab-deployment.yaml /home/${var.vm_user}/clusterApps/gitlab-deployment.yaml",
      "sudo mv /tmp/itop.yaml /home/${var.vm_user}/clusterApps/itop.yaml",
      "sudo mv /tmp/babybuddy.yaml /home/${var.vm_user}/clusterApps/babybuddy.yaml",
      "sudo mv /tmp/mysql.yaml /home/${var.vm_user}/clusterApps/mysql.yaml",

      # Deploy apps
      "sudo sed -i 's/#NFS_SERVER_IP#/${proxmox_vm_qemu.k8s_storage.0.ssh_host}/g' /home/${var.vm_user}/clusterApps/mysql.yaml",
      # "sudo kubectl apply -f /home/${var.vm_user}/clusterApps/mysql.yaml",
    
    ]
  }
}

