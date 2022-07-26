#!/usr/bin/bash

#echo "nameserver 8.8.8.8" > /etc/resolv.conf
#/etc/init.d/networking restart

echo -e "\n  [$(date +'%Y-%m-%dT%H:%M:%S%z')]: SSH enable password login"
sed -i 's/^PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config && echo -e "\tSSH [ OK ]"
systemctl reload sshd

echo -e "\n  [$(date +'%Y-%m-%dT%H:%M:%S%z')]: Install docker"
#apk add --update docker docker-compose openr

#addgroup username docker
#rc-update add docker boot
#service docker start

printf "\n  [$(date +'%Y-%m-%dT%H:%M:%S%z')]: ========== BOOTSTRAP COMPLETED ============"
