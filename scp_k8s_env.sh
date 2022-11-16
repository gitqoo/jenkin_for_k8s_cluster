#!/bin/bash

# /tmp/.k8s_env為第一台control-palne建立的token、ca_hash、cer_key等變數
# 把/tmp/.k8s_env丟到每台主機上
for line in $(cat /etc/hosts |awk -F" " '{print $1}')
  do
    expect << EOF
    spawn scp -o StrictHostKeyChecking=no  /tmp/.k8s_env root@$line:/tmp/
      expect {
      "*password:"  { send "1qaz2wsx\n" }
      }
    expect eof;
EOF

done
