/etc/ssh/sshd_config

Timeout value = ClientAliveInterval * ClientAliveCountMax

docker run -d jenkins/ssh-agent "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDEJpykWZv0JFqwfapv6TIpETY2C64BfoV4p8CjmEX4s8RJlBkyQYwWlzj8G1cts/A1JeppIrBPPtrROd6sTr4f1v8jgipVJta37wT68JhjZDMOViCxKApERgiDl94kiyidik3hbq9elFNjluhuWx/wrsX1uBuUWVdIv9x13DFeCEenAot4QnUYtg9wEg5VNe9v3E5BlOGFgEfGOg/xEeCOMohj8cKl+M3YX5vOYsJAyvS8CX6KQOZ3fQ3oRMdnQnzKJW4Tmtr7QEMNeiCfcNvKRHY77zdQYdOz7jW5NWbCHgayFDe8HqSP6BnZbiFsgJDqFRiNnGn3LnwYVvpvmqdr"
docker exec -it 75b7a47e1e67 bash 

sed -i 's/[#]?ClientAliveInterval.*/ClientAliveInterval 1200/' /etc/ssh/sshd_config
sed -i 's/[#]?ClientAliveCountMax.*/ClientAliveCountMax 3/' /etc/ssh/sshd_config