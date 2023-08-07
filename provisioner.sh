#!/usr/bin/env bash

echo "Copying daemon.json"
sudo mkdir -p "/etc/docker/"
sudo cp /tmp/daemon.json /etc/docker/daemon.json

# update package
sudo yum -y update

# install git
echo "Installing Git"
sudo yum -y  install git

echo "Installing Docker"
sudo amazon-linux-extras install docker
sudo service docker start
sudo usermod -a -G docker ec2-user
sudo chkconfig docker on
sudo curl -L https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# install SSM
echo "Installing Amazon SSM Agent"
sudo yum -y  install https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/linux_amd64/amazon-ssm-agent.rpm
#sudo systemctl start amazon-ssm-agent

# install cloudwatch agent
echo "Instaling Cloudwatch agent"
sudo yum -y install https://s3.amazonaws.com/amazoncloudwatch-agent/amazon_linux/amd64/latest/amazon-cloudwatch-agent.rpm
sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -m ec2 -a start
sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -m ec2 -a status

# install AWS inspector
echo "Installing AWS Inspector"
curl -O https://inspector-agent.amazonaws.com/linux/latest/install
sudo bash install

echo "Provisioner has finished running"
