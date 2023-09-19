#!/bin/bash
echo "🚀 Installation du contrôleur Kubernetes..."

while ! (apt-get update); do sleep 1; done

# check if the system have 2 cpus
echo "✅ Vérification du nombre de cœurs"
if [ $(nproc) -lt 2 ]; then
    echo "❌ Vous devez avoir au moins 2 cœurs de processeur pour créer un contrôleur Kubernetes."
    exit 1
fi

echo "📦 Installation des dépendances..."

# Mise à jour du système
echo "$nrconf{restart} = 'a';" > /etc/needrestart/conf.d/nointeractive.conf
while ! (apt-get update); do sleep 1; done
sudo apt update
sudo apt upgrade -y

# Génération d'un nom d'hôte aléatoire de 6 caractères
RANDOM_SUFFIX=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 6 | head -n 1)
HOSTNAME="k8s-ctrlr-$RANDOM_SUFFIX"
echo "✅ Génération d'un nom d'hôte aléatoire $HOSTNAME"

# Configuration du nom d'hôte
sudo hostnamectl set-hostname $HOSTNAME

# Ajoutez également une entrée dans /etc/hosts
echo "127.0.1.1 $HOSTNAME" | sudo tee -a /etc/hosts

# Installation des dépendances
sudo apt install -y docker.io

# Installation de kubeadm, kubelet et kubectl
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

# Configuration du contrôleur
echo "🔧 Configuration du contrôleur..."
sudo kubeadm init --pod-network-cidr=10.244.0.0/16
echo "✅ Configuration du contrôleur"

# Configuration kubectl pour l'utilisateur courant
echo "🔧 Configuration kubectl pour l'utilisateur courant..."
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
echo "✅ Configuration kubectl pour l'utilisateur courant"

# Installation d'un réseau pour les pods (Calico dans cet exemple)
echo "📦 Installation d'un réseau pour les pods (Calico dans cet exemple)..."
kubectl apply -f https://docs.projectcalico.org/v3.18/manifests/calico.yaml
echo "✅ Installation d'un réseau pour les pods (Calico dans cet exemple)"

# Tâches facultatives (désactivez-les si vous ne les voulez pas)
# Déverrouillage du réseau local pour les services de type LoadBalancer
# kubectl taint nodes --all node-role.kubernetes.io/master-
# Installation du dashboard Kubernetes (attention : n'exposez pas cela publiquement)
# kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.4.0/aio/deploy/recommended.yaml

echo "🚀 Le contrôleur Kubernetes a été configuré avec succès!"

# Affichez la commande pour joindre les nœuds au cluster (à conserver en sécurité)
echo "🔧 Affichez la commande pour joindre les nœuds au cluster (à conserver en sécurité)"



