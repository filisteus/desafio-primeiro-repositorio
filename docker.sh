#!/bin/bash

echo "Instalando docker e kubenet"
dnf -y upgrade
dnf config-manager --add-repo=https://download.docker.com/linux/centos/docker-ce.repo
dnf install -y https://download.docker.com/linux/centos/7/x86_64/stable/Packages/containerd.io-1.2.6-3.3.el7.x86_64.rpm
 dnf install docker-ce --nobest -y
  systemctl start docker
systemctl enable docker

echo '{
  "exec-opts": ["native.cgroupdriver=systemd"]
}' > /etc/docker/daemon.json

systemctl restart docker

cat < /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-$basearch
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
exclude=kubelet kubeadm kubectl
EOF

dnf upgrade -y 
dnf install -y kubelet kubeadm kubectl --disableexcludes=kubernetes

systemctl enable kubelet
systemctl start kubelet

echo "Criando as imagens......."

cat minha_senha.txt | docker login --username filisteus --password-stdin

 docker build -t filisteus/projeto-backend:1.0 backend/.
 docker build -t filisteus/projeto-database:1.0 database/.

 "Realizando o push das imagens..."

 docker push filisteus/projeto-backend:1.0
 docker push filisteus/projeto-database:1.0

 "Criando serviços no cluster kubernetes..."

 kubectl apply -f ./deployment.yml

exit 0


