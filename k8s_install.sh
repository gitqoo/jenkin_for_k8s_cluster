#/bin/bash

tee /etc/yum.repos.d/kubernetes.repo<<`EOF`
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
`EOF`

yum clean all && sudo yum -y makecache
yum -y install epel-release vim git curl wget kubelet kubeadm kubectl --disableexcludes=kubernetes

kubeadm version
kubectl version --client

sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab
swapoff -a

modprobe overlay
modprobe br_netfilter

tee /etc/sysctl.d/kubernetes.conf<<`EOF`
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
`EOF`

sysctl --system

OS=CentOS_7
VERSION=1.22
curl -L -o /etc/yum.repos.d/devel:kubic:libcontainers:stable.repo https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/CentOS_7/devel:kubic:libcontainers:stable.repo

curl -L -o /etc/yum.repos.d/devel:kubic:libcontainers:stable:cri-o:$VERSION.repo https://download.opensuse.org/repositories/devel:kubic:libcontainers:stable:cri-o:$VERSION/$OS/devel:kubic:libcontainers:stable:cri-o:$VERSION.repo

yum remove docker-ce docker-ce-cli containerd.io
yum install -y cri-o

systemctl daemon-reload
systemctl start crio
systemctl enable crio

lsmod | grep br_netfilter
systemctl enable kubelet
kubeadm config images pull
