#!/bin/bash

set -e  # Exit immediately if a command exits with a non-zero status

echo "🚀 Updating package lists..."
sudo apt-get update -y

echo "🔑 Adding Jenkins GPG key..."
sudo wget -O /usr/share/keyrings/jenkins-keyring.asc \
  https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key

echo "📦 Adding Jenkins repository..."
echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
  https://pkg.jenkins.io/debian-stable binary/" | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null

echo "🔄 Updating package lists after adding Jenkins repo..."
sudo apt-get update -y

echo "🛠 Installing Jenkins..."
sudo apt-get install -y jenkins

echo "✅ Jenkins installed successfully!"

echo "🔧 Installing Java (OpenJDK 17)..."
sudo apt install -y fontconfig openjdk-17-jre

echo "☕ Verifying Java installation..."
java -version

echo "🐳 Installing Docker..."
sudo apt install -y docker.io

echo "🔄 Enabling and starting Jenkins..."
sudo systemctl enable jenkins
sudo systemctl start jenkins

echo "🚦 Checking Jenkins status..."
sudo systemctl status jenkins --no-pager

echo "🔑 Adding Jenkins user to Docker group..."
sudo usermod -aG docker jenkins
newgrp docker

echo "🔄 Restarting Jenkins to apply Docker permissions..."
sudo systemctl restart jenkins

echo "🎉 Installation complete!"
echo "🔑 Get your Jenkins initial admin password with:"
echo "    sudo cat /var/lib/jenkins/secrets/initialAdminPassword"
echo "🔗 Access Jenkins at: http://your-vm-ip:8080"
