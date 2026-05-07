Name:           ddeploy
Version:        $VERSION
Release:        1%{?dist}
Summary:        Automation tool for backend deployment and managment.

License:        MIT
URL:            https://github.com/Nave-Cohen/ddeploy
Source0:        %{name}.tar.gz
Source1:        preinst
Source2:        postinst
Source3:        prerm

BuildArch:      noarch

%description
A longer description of what ddeploy does.

%prep
%setup -q -n %{name}

%install
rm -rf %{buildroot}

# Define variables for paths
%global etc_ddeploy %{buildroot}/etc/ddeploy
%global etc_logrotate %{buildroot}/etc/logrotate.d
%global etc_systemd %{buildroot}/etc/systemd/system
%global usr_bin %{buildroot}/usr/local/bin
%global usr_share %{buildroot}/usr/local/share/ddeploy

# Create directories and copy files
mkdir -p %{etc_ddeploy}
cp -r etc/ddeploy/* %{etc_ddeploy}/

mkdir -p %{etc_logrotate}
cp -r etc/logrotate.d/* %{etc_logrotate}/

mkdir -p %{etc_systemd}
cp -r etc/systemd/system/* %{etc_systemd}/

mkdir -p %{usr_bin}
cp -r usr/local/bin/* %{usr_bin}/

mkdir -p %{usr_share}
cp %{SOURCE1} %{usr_share}/
cp %{SOURCE2} %{usr_share}/
cp %{SOURCE3} %{usr_share}/

# Make scripts executable
chmod +x %{usr_share}/preinst
chmod +x %{usr_share}/postinst
chmod +x %{usr_share}/prerm

%pre
set -e

# Functions for pre-installation tasks
remove_old_cron() {
    crontab -l | grep -vF '/etc/ddeploy/maintence/rebuilder.sh' | crontab -
}

backup_old_conf() {
    conf_path="/etc/ddeploy/configs"
    conf_folder="/var/tmp/ddeploy/conf"
    rm -f $conf_path/variables.env
    [ ! -d "$conf_folder" ] && mkdir $conf_folder
    [ -n "$(find "$conf_path" -mindepth 1 -maxdepth 1 -print -quit)" ] && cp -f $conf_path/* $conf_folder
}

if [ "$1" == "2" ]; then
    echo "Remove old cronjobs ..."
    remove_old_cron
    echo "Backup configuration files ..."
    backup_old_conf
fi

%post
/usr/local/share/ddeploy/postinst "$1"

%preun
# Functions for pre-uninstallation tasks
remove_cron() {
    crontab -l | grep -vF '/etc/ddeploy/maintence/rebuilder.sh' | crontab -
    crontab -l | grep -vF '/etc/ddeploy/maintence/backup.sh' | crontab -
}

backup_old_conf() {
    conf_folder="/var/tmp/ddeploy/conf"
    [ ! -d "$conf_folder" ] && mkdir -p $conf_folder
    [ -n "$(find "/etc/ddeploy/configs" -mindepth 1 -maxdepth 1 -print -quit)" ] && cp -f /etc/ddeploy/configs/* $conf_folder
}

# Stop service on uninstallation
systemctl stop ddeploy
if [ "$1" == "0" ]; then
    # Package removal
    backup_old_conf
    echo "Removing cronjobs ..."
    remove_cron
elif [ "$1" == "1" ]; then
    # Package upgrade
    backup_old_conf
fi


%files
/etc/ddeploy
/etc/logrotate.d/ddeploy
/etc/systemd/system/ddeploy-cleaner.service
/etc/systemd/system/ddeploy.service
/usr/local/bin/
/usr/local/share/ddeploy

%changelog
* Fri May 30 2024 Nave Cohen <nave1616@hotmail.com> - $VERSION-1
- preun: stop service before uninstallation.
- reformat spec file.
