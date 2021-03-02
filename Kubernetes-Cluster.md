# Membuat Kubernetes Cluster
## (Docker, Kubeadm, Kubelet, Kubectl)
> Author Panca Putra Pahlawan
---

### INSTALL DOCKER

#### Step 1

```sh
sudo apt-get update && sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common gnupg2
```

#### Step 2

```sh
curl -fsSL [https://download.docker.com/linux/ubuntu/gpg](https://download.docker.com/linux/ubuntu/gpg) | sudo apt-key --keyring /etc/apt/trusted.gpg.d/docker.gpg add -
```

#### Step 3

```sh
sudo add-apt-repository\
  "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
$(lsb_release -cs) \
  stable"
```

#### Step 4

```sh
sudo apt-get update && sudo apt-get install -y\
  containerd.io=1.2.13-2\
  docker-ce=5:19.03.11~3-0~ubuntu-$(lsb_release -cs)\
  docker-ce-cli=5:19.03.11~3-0~ubuntu-$(lsb_release -cs)
```

#### Step 5

```sh
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
```

#### Step 6

```sh
sudo mkdir -p /etc/systemd/system/docker.service.d
```

#### Step 7

```sh
sudo systemctl daemon-reload
sudo systemctl restart docker
sudo systemctl enable docker
```

#### Step 8

```sh
sudo systemctl status docker
```
---

## KUBERNETES CLUSTER

> Catatan : swap harus off permanen, agar saat Master/Control Plan di Restart container dapat berjalan kembali dengan baik. Caranya (ubuntu), sudo nano /etc/fstab
lalu comment, atau hapus baris yg berisi swap atau swap.img, lalu save. setelah itu, 
sudo swapoff -a

#### Step 1
```sh
cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
br_netfilter
EOF

cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF
```
```sh
sudo sysctl --system
```
> Jika IP v6 di non aktifkan, maka tidak perlu di tambahkan.

#### Step 2

```sh
sudo apt-get update && sudo apt-get install -y apt-transport-https curl
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
cat <<EOF | sudo tee /etc/apt/sources.list.d/kubernetes.list
deb https://apt.kubernetes.io/ kubernetes-xenial main
EOF
sudo apt-get update
sudo apt-get install -y kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl
```

> bisa juga di install kubernetes-cni


> STEP KHUSUS MASTER/CONTROL PLANE

> kubeadm init --pod-network-cidr=10.244.0.0/16 --
apiserver-advertise-address IP_ADDRESS_SERVER_MASTER_TANPA_HTTP

> Jika sudah nanti muncul token, simpan tokennya

> [contoh token]
kubeadm join 172.16.35.221:6443 --token 0fnkri.rabw4e3kv6600ing \
--discovery-token-ca-cert-hash sha256:a83d6276d5643c03a5936b5a040aa3341179b50bd8e0997b396e18a6b0b99579

> Lanjut 😎

> mkdir -p $HOME/.kube

> sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config

> sudo chown $(id -u):$(id -g) $HOME/.kube/config

> kubectl create -f [https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml](https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml) --namespace=kube-system


#### Step 3 
```sh
Copy Token yang didapat dari controlplan atau master, di dalam server worker lalu enter.
```

#### Step 4
```sh
Check Nodes server sudah ready atau belum dengan perintah :

kubectl get nodes
```

#### Step 5
```sh
Copy file config kubernetes (file config akan digunakan di Lens)

Masuk ke directory home

cat /.kube/config
```
