resource "proxmox_vm_qemu" "k8s_controller" {
  count       = 1
  name        = "${var.pm_vm_name_prefix}-controller"
  target_node = var.pm_node
  clone       = var.pm_template_name
  agent       = 1
  os_type     = "cloud-init"
  cores       = var.vm_controller_cores
  sockets     = 1
  cpu         = "host"
  memory      = var.vm_controller_memory
  scsihw      = "virtio-scsi-pci"
  ipconfig0   = "ip=dhcp"
  ciuser      = var.vm_user
  cipassword  = var.vm_password
  sshkeys     = var.ssh_publickey
  disk {
    slot    = 0
    size    = var.vm_controller_disk_size
    type    = "scsi"
    storage = var.pm_storage
  }

  network {
    model  = "virtio"
    bridge = var.pm_bridge
  }

  # share the assets folder with the VM


  provisioner "file" {
    connection {
      type        = "ssh"
      user        = var.vm_user
      private_key = var.ssh_privatekey
      host        = self.ssh_host
    }
    source      = "assets/installController.sh"
    destination = "/tmp/installController.sh"
  }

  provisioner "file" {
    connection {
      type        = "ssh"
      user        = var.vm_user
      private_key = var.ssh_privatekey
      host        = self.ssh_host
    }
    source      = "assets/metallb-namespace.yaml"
    destination = "/tmp/metallb-namespace.yaml"
  }

  provisioner "file" {
    connection {
      type        = "ssh"
      user        = var.vm_user
      private_key = var.ssh_privatekey
      host        = self.ssh_host
    }
    source      = "assets/metallb-config.yaml"
    destination = "/tmp/metallb-config.yaml"
  }

  provisioner "file" {
    connection {
      type        = "ssh"
      user        = var.vm_user
      private_key = var.ssh_privatekey
      host        = self.ssh_host
    }
    source      = "assets/gitlab-deployment.yaml"
    destination = "/tmp/gitlab-deployment.yaml"
  }

  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      user        = var.vm_user
      private_key = var.ssh_privatekey
      host        = self.ssh_host
    }
    inline = [
      "chmod +x /tmp/installController.sh",
      "sudo /tmp/installController.sh",
      "sudo kubeadm token create --print-join-command > /tmp/joinCommand.sh",

      # Install helm
      "sudo curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3",
      "sudo bash get_helm.sh",

      # Install metallb & configure metallb
      "echo 'Installing metallb'",
      "sudo kubectl apply -f /tmp/metallb-namespace.yaml",
      "sudo kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.11.0/manifests/metallb.yaml",
      "sudo sed -i 's/#RANGE#/${var.metallb_ip_range}/g' /tmp/metallb-config.yaml",
      "sudo kubectl apply -f /tmp/metallb-config.yaml",

      # Install gitlab
      # change #EXTERNAL_URL# to the value of var.gitlab_external_url
      "sudo sed -i 's/#EXTERNAL_URL#/${var.gitlab_external_url}/g' /tmp/gitlab-deployment.yaml",
      "sudo kubectl apply -f /tmp/gitlab-deployment.yaml",
      
    ]
  }

}