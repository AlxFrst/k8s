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
while ! (apt-get update); do sleep 1; done
sudo apt update

# Génération d'un nom d'hôte aléatoire de 6 caractères
RANDOM_SUFFIX=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 6 | head -n 1)
HOSTNAME="k8s-master-$RANDOM_SUFFIX"
echo "✅ Génération d'un nom d'hôte aléatoire $HOSTNAME"

# Configuration du nom d'hôte
sudo hostnamectl set-hostname $HOSTNAME

# Ajoutez également une entrée dans /etc/hosts
echo "127.0.1.1 $HOSTNAME" | sudo tee -a /etc/hosts

# Installation des dépendances
sudo apt install  -y containerd apt-transport-https software-properties-common
sudo systemctl enable docker
sudo systemctl start docker

sudo modprobe br_netfilter
echo 1 | sudo tee /proc/sys/net/ipv4/ip_forward

sudo apt install -y apt-transport-https curl

sudo rm /etc/containerd/config.toml
sudo systemctl restart containerd


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
sudo kubectl apply -f https://docs.projectcalico.org/v3.18/manifests/calico.yaml
echo "✅ Installation d'un réseau pour les pods (Calico dans cet exemple)"

# Tâches facultatives (désactivez-les si vous ne les voulez pas)
# Déverrouillage du réseau local pour les services de type LoadBalancer
# kubectl taint nodes --all node-role.kubernetes.io/master-
# Installation du dashboard Kubernetes (attention : n'exposez pas cela publiquement)
# kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.4.0/aio/deploy/recommended.yaml

# installing metallb
echo "📦 Installation de MetalLB..."
sudo kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.11.0/manifests/namespace.yaml
sudo kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.11.0/manifests/metallb.yaml
# Configuration de MetalLB
echo "🔧 Configuration de MetalLB..."
# create a file metallb-config.yaml
cat <<EOF | sudo tee /tmp/metallb-config.yaml
apiVersion: v1
kind: ConfigMap
metadata:
    namespace: metallb-system
    name: config
data:
    config: |
        address-pools:
        - name: default
          protocol: layer2
          addresses:
          - 192.168.1.240-192.168.1.250
EOF
sudo kubectl apply -f /tmp/metallb-config.yaml
echo "✅ Installation de MetalLB"

# installation du dashboard
echo "📦 Installation du dashboard Kubernetes..."
sudo kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.4.0/aio/deploy/recommended.yaml
# start the proxy in the background
sudo kubectl proxy &
# echo the token to connect to the dashboard
echo "🔧 Token pour se connecter au dashboard Kubernetes"
sudo kubectl -n kubernetes-dashboard describe secret $(sudo kubectl -n kubernetes-dashboard get secret | grep admin-user | awk '{print $1}') | grep token: | awk '{print $2}'
echo "✅ Installation du dashboard Kubernetes"

echo "🚀 Le contrôleur Kubernetes a été configuré avec succès!"

# Affichez la commande pour joindre les nœuds au cluster (à conserver en sécurité)
echo "🔧 Affichez la commande pour joindre les nœuds au cluster (à conserver en sécurité)"


