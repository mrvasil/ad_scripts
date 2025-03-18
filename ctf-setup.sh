sudo apt update -y
sudo apt upgrade -y

sudo apt install git byobu zsh curl python3 python3-pip python3-full htop nginx ipython3 wget micro nmap lsof neofetch tree openvpn -y

sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
sed -i 's/plugins=(/plugins=(zsh-autosuggestions /' ~/.zshrc
chsh -s /bin/zsh
sed -i 's/ZSH_THEME=".*"/ZSH_THEME="lukerandall"/' ~/.zshrc

curl -sSL https://get.docker.com/ | sudo sh
sudo usermod -aG docker $USER
sudo apt install docker-compose -y

#wget https://github.com/fatedier/frp/releases/download/v0.60.0/frp_0.60.0_linux_arm64.tar.gz

sudo snap install ttyd --classic
ttyd btop

cat << 'EOF' > lsof_port_checker.sh
#!/bin/bash
output_file="open_ports.txt"
> "$output_file"
echo "Open TCP Ports:" >> "$output_file"
lsof -iTCP -sTCP:LISTEN -P -n | awk '{print $1, $9}' | grep -Eo ':[0-9]+' | sort -u >> "$output_file"
echo -e "\nOpen UDP Ports:" >> "$output_file"
lsof -iUDP -P -n | awk '{print $1, $9}' | grep -Eo ':[0-9]+' | sort -u >> "$output_file"
cat $output_file
EOF
sudo chmod +x lsof_port_checker.sh

cat << 'EOF' > restart-docker.sh
sudo docker compose down -v
sudo docker compose up -d --build
EOF
chmod +x restart-docker.sh

sudo apt install fail2ban -y
sudo systemctl enable fail2ban
sudo systemctl start fail2ban

git clone https://github.com/DestructiveVoice/DestructiveFarm.git
cd DestructiveFarm/server
python3 -m pip install -r requirements.txt
screen -dmS farm bash -c 'cd ~/DestructiveFarm/server && ./start_server.sh'
#screen -X -S farm quit

git clone https://gitlab.com/packmate/starter.git
cat << 'EOF' > restart-packmate.sh
#!/bin/bash
sudo docker compose down -v
sudo rm -rf data/postgres_data
sudo docker compose up -d --build
EOF
chmod +x restart-packmate.sh

mkdir test-dir
mkdir sploits

snap install gotop-cjbassi
gotop-cjbassi -c monokaig

docker volume create portainer_data
docker run -d -p 16982:9000 --name=portainer --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer

git clone https://github.com/stefanprodan/dockprom
cd dockprom
docker-compose up -d

curl -fsSL https://code-server.dev/install.sh | sh
sudo systemctl enable --now code-server@$USER
sed -i 's/127.0.0.1:8080/0.0.0.0:21836/' ~/.config/code-server/config.yaml
sudo systemctl restart code-server@$USER
cat ~/.config/code-server/config.yaml | grep password

#sudo tcpdump -A -i any | grep -E '[A-Z0-9]{31}='