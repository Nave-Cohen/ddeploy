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

