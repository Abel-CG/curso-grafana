#!/bin/sh

# Install k3d
curl -s https://raw.githubusercontent.com/rancher/k3d/main/install.sh | bash
k3d cluster create micluster

# Install kubectl
sudo apt-get install kubectl
curl -LO "https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x ./kubectl
sudo mv ./kubectl /usr/local/bin/kubectl

#Install helm
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh

# Add repos to helm
helm repo add stable https://charts.helm.sh/stable
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update


#Install prometheus operator
helm upgrade --install prometheus prometheus-community/kube-prometheus-stack --version 13.4.1 --values kube-prometheus-stack-values.yaml
kubectl port-forward svc/prometheus-kube-prometheus-prometheus 8090:9090
