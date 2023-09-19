#!/bin/bash

echo "🚀 Installation du nœud Kubernetes..."

while ! (apt-get update); do sleep 1; done

echo "📦 Installation des dépendances..."

# Mise à jour du système
while ! (apt-get update); do sleep 1; done
echo "$nrconf{restart} = 'a';" > /etc/needrestart/conf.d/nointeractive.conf
sudo apt update
sudo apt upgrade -y
echo "✅ Mise à jour du système"

# Génération d'un nom d'hôte aléatoire de 6 caractères
RANDOM_SUFFIX=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 6 | head -n 1)
HOSTNAME="k8s-node-$RANDOM_SUFFIX"

# Configuration du nom d'hôte
sudo hostnamectl set-hostname $HOSTNAME

# Ajoutez également une entrée dans /etc/hosts
echo "127.0.1.1 $HOSTNAME" | sudo tee -a /etc/hosts
echo "✅ Génération d'un nom d'hôte aléatoire $HOSTNAME"

# Installation des dépendances
sudo apt install -y docker.io

# Installation de kubeadm, kubelet et kubectl (si ce n'est pas déjà fait)
# kubelet est nécessaire pour rejoindre le cluster.
# Assurez-vous que les versions correspondent à celles du contrôleur.
echo "📦 Installation de kubeadm, kubelet et kubectl..."
while ! (apt-get update); do sleep 1; done
sudo apt install -y apt-transport-https curl
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
while ! (apt-get update); do sleep 1; done
sudo apt update
sudo apt install -y kubelet kubeadm kubectl
echo "✅ Installation de kubeadm, kubelet et kubectl"

# Désactivation du swap
echo "🔧 Désactivation du swap..."
sudo swapoff -a
sudo sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab
echo "✅ Désactivation du swap"

# Utilisez la commande pour joindre le cluster (obtenue lors de la configuration du contrôleur)
# Assurez-vous d'avoir la bonne commande obtenue depuis le contrôleur.
echo "✅ Nœud Kubernetes installé avec succès !"
echo "🔧 Utilisez la commande pour joindre le cluster (obtenue lors de la configuration du contrôleur)..."

