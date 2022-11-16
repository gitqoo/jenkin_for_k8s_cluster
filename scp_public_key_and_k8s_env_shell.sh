#!/bin/bash


# 複製jenkins主機上自產的ssh public key到每台機器
for line in $(cat /tmp/hosts |awk -F" " '{print $1}')
  do

expect << EOF
  spawn ssh-copy-id -o StrictHostKeyChecking=no -i /root/.ssh/id_rsa.pub root@$line
  expect {
    "*password:"  { send "1qaz2wsx\n" }
  }
expect eof;
EOF

done


# 複製scp_k8s_env.sh到第一台conteol-plane
for env in $(cat /tmp/hosts |awk -F" " 'NR==1{print $1}')
  do
expect << EOF
  spawn scp -o StrictHostKeyChecking=no /root/scp_k8s_env.sh root@$env:/tmp/
  expect {
    "*password:"  { send "1qaz2wsx\n" }
  }
expect eof;
EOF

done
