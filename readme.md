### clone & Install dependencies

#### clone ddeploy project

```sh
git clone https://github.com/Nave-Cohen/ddeploy.git
cd ddeploy
```

#### install docker

```sh
  chmod +X docker-install.sh
  ./docker-install.sh
```

#### install package
```sh
dpkeg -i ddeploy.deb
apt install -f
systemctl start ddeploy
```

### create new project

```sh
  mkdir -p /path/to/project
  cd /path/to/project
  ddeploy init [github-repositry] [branch name]
```

### :warning: Edit /path/to/project/ddeploy.env example that allready created :warning:

#### deploy 
```sh
ddeploy up
```

##### for more information & command
```sh
ddeploy help
ddeploy help [command]
```

