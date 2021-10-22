#!/usr/bin/bash

echo -e "\n  [$(date +'%Y-%m-%dT%H:%M:%S%z')]: SSH enable password login"
sed -i 's/^PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config && echo -e "\n\tSSH OK"
systemctl reload sshd

echo -e "\n  [$(date +'%Y-%m-%dT%H:%M:%S%z')]: Install Postgre"
grep -q "exclude=postgresql*" /etc/yum.repos.d/CentOS-Base.repo || echo "exclude=postgresql*" >> /etc/yum.repos.d/CentOS-Base.repo
yum install -y https://download.postgresql.org/pub/repos/yum/reporpms/EL-7-x86_64/pgdg-redhat-repo-latest.noarch.rpm
yum install -y postgresql11-server

echo -e "\n  [$(date +'%Y-%m-%dT%H:%M:%S%z')]: Create DB"
/usr/pgsql-11/bin/postgresql-11-setup initdb && echo -e "\ninitdb OK"

echo -e "\n  [$(date +'%Y-%m-%dT%H:%M:%S%z')]: Start Postgre"
systemctl restart postgresql-11
systemctl enable postgresql-11

sed -i\
 -e "s/^#listen_addresses =.*/listen_addresses = '*'/" \
 -e "s/^#port =.*/port = 5432/" \
/var/lib/pgsql/11/data/postgresql.conf && echo -e "\tListen address/port Config OK"

echo -e "\n  [$(date +'%Y-%m-%dT%H:%M:%S%z')]: Create db, user"
sudo -u postgres psql -c 'create database sonarqubedb;'
sudo -u postgres psql -c "create user sonaruser with encrypted password 'sonarpassword';"
sudo -u postgres psql -c 'grant all privileges on database sonarqubedb to sonaruser;'

systemctl restart postgresql-11

#sudo -u postgres psql -c 'SHOW config_file'
#