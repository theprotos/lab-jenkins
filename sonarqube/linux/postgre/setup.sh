#!/usr/bin/bash

echo -e "\n  [$(date +'%Y-%m-%dT%H:%M:%S%z')]: SSH enable password login"
sed -i 's/^PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config && echo -e "\n\tSSH OK"
systemctl reload sshd

echo -e "\n  [$(date +'%Y-%m-%dT%H:%M:%S%z')]: Install Postgre"
grep -q "exclude=postgresql*" /etc/yum.repos.d/CentOS-Base.repo || echo "exclude=postgresql*" >> /etc/yum.repos.d/CentOS-Base.repo
yum install -y https://download.postgresql.org/pub/repos/yum/reporpms/EL-7-x86_64/pgdg-redhat-repo-latest.noarch.rpm
yum install -y postgresql11-server

echo -e "\n  [$(date +'%Y-%m-%dT%H:%M:%S%z')]: Create DB"
/usr/pgsql-11/bin/postgresql-11-setup initdb && echo -e "\n\initdb OK"

echo -e "\n  [$(date +'%Y-%m-%dT%H:%M:%S%z')]: Start Postgre"
sudo systemctl start postgresql-11
sudo systemctl enable postgresql-11

echo -e "\n  [$(date +'%Y-%m-%dT%H:%M:%S%z')]: Create db, user"
postgres
create database sonarqubedb
create user sonaruser with encrypted password 'sonarpassword';
grant all privileges on database sonarqubedb to sonaruser;
\q

