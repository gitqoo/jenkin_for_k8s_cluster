#!/bin/bash

IP=$1

# jenkins介面上輸入的ip會儲存在/tmp/hosts內，透過shell把/tmp/hosts覆蓋每台主機的/etc/hosts
expect << EOF
spawn scp -o StrictHostKeyChecking=no  /tmp/hosts root@${IP}:/etc/hosts
    expect {
    "*password:"  { send "1qaz2wsx\n" }
    }
expect eof;
EOF


# 把jenkins上的/root/k8s_install.sh丟給每台主機
expect << EOF
spawn scp -o StrictHostKeyChecking=no  /root/k8s_install.sh root@${IP}:/tmp/
    expect {
    "*password:"  { send "1qaz2wsx\n" }
    }
expect eof;
EOF
