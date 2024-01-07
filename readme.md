### clone & Install dependencies

#### install docker
1. copy the script from https://get.docker.com/
1. paste inside docker-install.sh

```sh
  chmod +X docker-install.sh
  ./docker-install.sh
```
#### clone and install package
```sh
git clone https://github.com/Nave-Cohen/ddeploy.git
cd ddeploy
dpkeg -i ddeploy.deb
systemctl start ddeploy
```

### create new project

```sh
  mkdir -p /path/to/project
  cd /path/to/project
  ddeploy init [github-repositry] [branch name]
```

### :warning: Edit /path/to/project/ddeploy.env that created :warning:

#### deploy 
```sh
ddeploy up
```

