

## Debian installation

``` sh
# import the GPG Key
sudo curl -fsSL https://ddeploy.org/packages/debian/ddeploy-pubkey.asc | sudo tee /etc/apt/keyrings/ddeploy-pubkey.asc

# Add the ddeploy Repository
echo "deb [arch=$(dpkg --print-architecture) sign-by=/etc/apt/keyrings/ddeploy-pubkey.asc] https://ddeploy.org/packages/debian stable main" | sudo tee /etc/apt/sources.list.d/ddeploy.list

# Optional: Make the Docker installation script executable and run it
curl -L https://raw.githubusercontent.com/Nave-Cohen/ddeploy/main/docker-install.sh > docker-install.sh
chmod +x docker-install.sh
./docker-install.sh

# Update Package Lists and Install ddeploy
sudo apt update
sudo apt install -y ddeploy
```

## RHL installation

``` sh
# Add the ddeploy Repository
sudo yum-config-manager --add-repo http://ddeploy.org/rpm/ddeploy.repo

# Optional: Make the Docker installation script executable and run it
curl -L https://raw.githubusercontent.com/Nave-Cohen/ddeploy/main/docker-install.sh > docker-install.sh
chmod +x docker-install.sh
./docker-inst all.sh

#Import the GPG Key
sudo rpm --import http://ddeploy.org/packages/rpm/ddeploy.gpg.key

#  Install ddeploy
sudo yum install ddeploy
```

## create new project

```sh
  # Replace [github-repository] with the GitHub repository URL of your project.
  # Replace [branch name] with the name of the branch you want to use.
  mkdir -p /path/to/project
  cd /path/to/project
  ddeploy init [github-repository] [branch name]
```

## setup & project configuration

Edit the `ddeploy.env` file already created inside the project folder to match your project configuration.

## deploy

```sh
# Deploy the project using ddeploy
ddeploy up
ddeploy status # Get deployment status
```

##### for more information & command
```sh
# Get general help for ddeploy
ddeploy help

# Get help for a specific command
ddeploy help [command]
```

### roadmap

- add build from source info to README

<p align="center">
  <a href="https://www.docker.com/">
    <img src="https://img.shields.io/badge/Docker-2496ED?style=for-the-badge&logo=Docker&logoColor=white" alt="Docker">
  </a>
  <a href="https://www.gnu.org/software/bash/">
    <img src="https://img.shields.io/badge/bash-black?style=for-the-badge&logo=gnubash&logoColor=white" alt="GNU Bash">
  </a>
</p>

<div align="center" style="text-align: center;">
  <a href="https://github.com/Nave-Cohen/ddeploy/actions/workflows/development.yml">
    <img src="https://img.shields.io/github/actions/workflow/status/Nave-Cohen/ddeploy/development.yml?branch=main&label=Build%20debian%20package&job=build_packages" alt="Build debian package">
  </a>
  <a href="https://github.com/Nave-Cohen/ddeploy/actions/workflows/development.yml">
    <img src="https://img.shields.io/github/actions/workflow/status/Nave-Cohen/ddeploy/development.yml?branch=main&label=Test%20package&job=test_packages" alt="Test package">
  </a>
</div>


