

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

## 1. create new project

```sh
  # Replace [github-repository] with the GitHub repository URL of your project.
  # Replace [branch name] with the name of the branch you want to use.
  mkdir -p /path/to/project
  cd /path/to/project
  ddeploy init [github-repository] [branch name]
```

## 2. setup & project configuration

Edit the `ddeploy.env` file already created inside the project folder to match your project configuration.

## 3. deploy

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

##### roadmap
```sh
# MongoDB Integration (Next Update)
# - MongoDB support will be added in the next update.
# - Stay tuned for more information and instructions on incorporating MongoDB into your projects.
```

<p align="center">
  <a href="https://www.docker.com/">
    <img src="https://img.shields.io/badge/Docker-2496ED?style=for-the-badge&logo=Docker&logoColor=white" alt="Docker">
  </a>
  <a href="https://www.gnu.org/software/bash/">
    <img src="https://img.shields.io/badge/bash-black?style=for-the-badge&logo=gnubash&logoColor=white" alt="GNU Bash">
  </a>
</p>
