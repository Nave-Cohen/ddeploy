

## Debian installation

``` sh
# Download package
curl -L https://github.com/Nave-Cohen/ddeploy/releases/download/v1.0.0/ddeploy.deb > ddeploy.deb

# Optional: Make the Docker installation script executable and run it
chmod +x docker-install.sh
./docker-install.sh

# Install deps
sudo apt install jq git cron

# Install ddeploy package
dpkg -i ./ddeploy.deb
# or
apt install ./ddeploy.deb

```

## RHL installation

``` sh
# Download package
curl -L https://github.com/Nave-Cohen/ddeploy/releases/download/v1.0.0/ddeploy-1.0.0-1.noarch.rpm > ddeploy.rpm

# Optional: Make the Docker installation script executable and run it
chmod +x docker-install.sh
./docker-install.sh

# Install deps
sudo yum install jq git cron

# Install ddeploy package
sudo rpm -i ./ddeploy.rpm
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
  <a href="https://github.com/Nave-Cohen/ddeploy/actions/workflows/deb-package-ci.yml">
    <img src="https://img.shields.io/github/actions/workflow/status/Nave-Cohen/ddeploy/deb-package-ci.yml?branch=main&label=Build%20debian%20package&job=build" alt="Build debian package">
  </a>
  <a href="https://github.com/Nave-Cohen/ddeploy/actions/workflows/deb-package-ci.yml">
    <img src="https://img.shields.io/github/actions/workflow/status/Nave-Cohen/ddeploy/deb-package-ci.yml?branch=main&label=Test%20package&job=test" alt="Test package">
  </a>
  <a href="https://github.com/Nave-Cohen/ddeploy/actions/workflows/deb-package-ci.yml">
    <img src="https://img.shields.io/github/actions/workflow/status/Nave-Cohen/ddeploy/deb-package-ci.yml?branch=main&label=Publish%20debian%20package&job=publish" alt="Publish debian package">
  </a>
</div>


