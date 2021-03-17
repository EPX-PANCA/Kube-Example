#!/bin/bash

#author Panca Putra Pahlawan

sudo apt-get update && sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common gnupg2

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key --keyring /etc/apt/trusted.gpg.d/docker.gpg add -

sudo add-apt-repository\
  "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
$(lsb_release -cs) \
  stable"

sudo apt-get update && sudo apt-get install -y\
  containerd.io=1.2.13-2\
  docker-ce=5:19.03.11~3-0~ubuntu-$(lsb_release -cs)\
  docker-ce-cli=5:19.03.11~3-0~ubuntu-$(lsb_release -cs)

cat <<EOF | sudo tee /etc/docker/daemon.json
{
  "exec-opts": ["native.cgroupdriver=systemd"],
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "100m"
  },
  "storage-driver": "overlay2"
}
EOF

sudo mkdir -p /etc/systemd/system/docker.service.d

sudo systemctl daemon-reload

sudo systemctl restart docker

sudo systemctl enable docker

sudo systemctl status docker

sudo usermod -aG docker $USER

sudo systemctl restart docker

echo "Selesai"
