# from repository
sudo apt-get update
sudo apt install docker.io
sudo systemctl start docker
sudo systemctl enable docker

# from docker
sudo apt update
sudo apt install apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo apt update
sudo apt install docker-ce
