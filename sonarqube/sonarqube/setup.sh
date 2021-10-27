#!/usr/bin/bash

echo -e "\n  [$(date +'%Y-%m-%dT%H:%M:%S%z')]: SSH enable password login\n"
sed -i 's/^PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config && echo -e "\tSSH [ OK ]"
systemctl reload sshd

echo -e "\n  [$(date +'%Y-%m-%dT%H:%M:%S%z')]: Install additional packages"
yum install -y -q java-11-openjdk java-11-openjdk-devel unzip lsof net-tools postgresql
yum update -y -q

echo -e "\n  [$(date +'%Y-%m-%dT%H:%M:%S%z')]: Set SonarQube variables\n"
sonarqube_url='https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-9.1.0.47736.zip' &&\
export SONARQUBE_HOME=/opt/sonarqube && echo -e "\tset SONARQUBE_HOME [ OK ]"

echo -e "\n  [$(date +'%Y-%m-%dT%H:%M:%S%z')]: Install SonarQube\n"
curl -sL $sonarqube_url -o /tmp/sonar.zip && echo -e "\tDownload [ OK ]"
unzip -q -o -d /tmp/ /tmp/sonar.zip && echo -e "\tExtracted [ OK ]"
mkdir -p ${SONARQUBE_HOME} && cp -a /tmp/sonarqube-*/. ${SONARQUBE_HOME} && echo -e "\tCopy to ${SONARQUBE_HOME} [ OK ]"
rm -rf /tmp/sonar.zip /tmp/sonarqube-* && echo -e "\tCleanup [ OK ]"

echo -e "\n  [$(date +'%Y-%m-%dT%H:%M:%S%z')]: Add SonarQube user and permissions\n"
useradd -m sonar -s /sbin/nologin || true
usermod -L -a -G sonar sonar &&\
chown -R sonar:sonar ${SONARQUBE_HOME}/ &&\
echo -e "\tPermissions [ OK ]"
mkdir -p /var/sonarqube && chown -R sonar:sonar /var/sonarqube

sysctl -w 'vm.max_map_count=262144'
sysctl -w 'fs.file-max=65535'
sysctl -p
sysctl --system

#echo -e "\n  [$(date +'%Y-%m-%dT%H:%M:%S%z')]: Use PostgresDB\n"
#sed -i\
# -e 's/^#sonar.jdbc.username=/sonar.jdbc.username=sonaruser/'\
# -e 's/^#sonar.jdbc.password=/sonar.jdbc.password=sonarpassword/'\
# -e 's/^#sonar.jdbc.url=/sonar.jdbc.username=jdbc:postgresql:\/\/localhost\/sonarqube/' \
#$SONARQUBE_HOME/conf/sonar.properties && echo -e "\tJDBC Config OK"

sed -i\
 -e 's/^sonar.path.data=/sonar.path.data=\/var\/sonarqube\/data/'\
 -e 's/^sonar.path.temp=/sonar.path.temp=\/var\/sonarqube\/temp/' \
$SONARQUBE_HOME/conf/sonar.properties && echo -e "\tES Config OK"

sed -i\
 -e 's/^#sonar.web.port=.*/sonar.web.port=9000/' \
$SONARQUBE_HOME/conf/sonar.properties && echo -e "\tNetwork port OK"
#sonar.web.host=192.168.0.1


sed -i\
 -e 's/^wrapper.java.command=.*/wrapper.java.command=java/' \
$SONARQUBE_HOME/conf/wrapper.conf && echo -e "\tWEB Config OK"

echo -e "\n  [$(date +'%Y-%m-%dT%H:%M:%S%z')]: Start SONAR and wait 30 sec\n"
#su sonar -c '/opt/sonarqube/bin/linux-x86-64/sonar.sh restart'
sudo -u sonar /opt/sonarqube/bin/linux-x86-64/sonar.sh restart && \
sleep 30 && echo -e "\tWEB Config OK"

echo -e "\n  [$(date +'%Y-%m-%dT%H:%M:%S%z')]: Create users\n"
curl -X POST -v -u admin:admin "http://localhost:9000/api/users/change_password?login=admin&password=admin1&previousPassword=admin"
curl -X POST -v -u admin:admin1 "http://localhost:9000/api/users/create?login=dev&password=dev&name=developer&email=myname@email.com"

#psql -h 192.168.100.101 -p 5432 -U sonaruser -d sonarqubedb -W sonarpassword