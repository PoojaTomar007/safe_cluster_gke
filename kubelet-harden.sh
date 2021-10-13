#!/bin/bash
FILE1=/var/lib/kubelet/kubeconfig
if test -f "$FILE1"; 
then 
  chmod 644 /var/lib/kubelet/kubeconfig
fi

FILE2=/home/kubernetes/kubelet-config.yaml
if test -f "$FILE2"; 
then 
  sed -i 's/10255/0/g' /home/kubernetes/kubelet-config.yaml 
  echo "protectKernelDefaults: true" >> /home/kubernetes/kubelet-config.yaml 
  echo "eventQps: 10" >> /home/kubernetes/kubelet-config.yaml
fi

systemctl daemon-reload && systemctl restart kubelet.service
