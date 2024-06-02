

## Clone project & Install Dependencies

```sh
# Clone the ddeploy project
git clone https://github.com/Nave-Cohen/ddeploy.git
cd ddeploy

# Make the Docker installation script executable and run it
chmod +x docker-install.sh
./docker-install.sh

# Install the ddeploy package and resolve dependencies
dpkg -i ddeploy.deb
apt install -f

# Start the ddeploy service
systemctl start ddeploy
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

- MongoDB Integration (Next Update)
- MongoDB support will be added in the next update.
- Stay tuned for more information and instructions on incorporating MongoDB into your projects.

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


