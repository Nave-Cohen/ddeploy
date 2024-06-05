Name:           ddeploy
Version:        1.0.0
Release:        1%{?dist}
Summary:        Description of ddeploy

License:        Your License
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

# Copy ddeploy directory
mkdir -p %{buildroot}/etc/ddeploy
cp -r etc/ddeploy/* %{buildroot}/etc/ddeploy/

# Copy logrotate configuration
mkdir -p %{buildroot}/etc/logrotate.d
cp -r etc/logrotate.d/* %{buildroot}/etc/logrotate.d/

# Copy systemd services
mkdir -p %{buildroot}/etc/systemd/system
cp -r etc/systemd/system/* %{buildroot}/etc/systemd/system/

# Copy ddeploy main executable
mkdir -p %{buildroot}/usr/local/bin
cp -r usr/local/bin/* %{buildroot}/usr/local/bin/

# Copy scripts to /usr/local/share/ddeploy
mkdir -p %{buildroot}/usr/local/share/ddeploy
cp %{SOURCE1} %{buildroot}/usr/local/share/ddeploy/
cp %{SOURCE2} %{buildroot}/usr/local/share/ddeploy/
cp %{SOURCE3} %{buildroot}/usr/local/share/ddeploy/
chmod +x %{buildroot}/usr/local/share/ddeploy/preinst
chmod +x %{buildroot}/usr/local/share/ddeploy/postinst
chmod +x %{buildroot}/usr/local/share/ddeploy/prerm

%pre
set -e

remove_old_cron() {
    crontab -l | grep -vF '/etc/ddeploy/maintence/rebuilder.sh' | crontab -
}

backup_old_conf() {
    conf_path="/etc/ddeploy/configs"
    conf_folder="/var/tmp/ddeploy/conf"
    rm -f $conf_path/variables.env
    if [[ ! -d "$conf_folder" ]]; then
        mkdir $conf_folder
    fi
    if [ ! -z "$(find "$conf_path" -mindepth 1 -maxdepth 1 -print -quit)" ]; then
        cp -f $conf_path/* $conf_folder
    fi
}

if  [ "$1" == "2" ] ; then
    echo "Remove old cronjobs ..."
    remove_old_cron
    echo "Backup configuration files ..."
    backup_old_conf
fi

%post
/usr/local/share/ddeploy/postinst "$1"

%preun
remove_cron() {
    crontab -l | grep -vF '/etc/ddeploy/maintence/rebuilder.sh' | crontab -
    crontab -l | grep -vF '/etc/ddeploy/maintence/backup.sh' | crontab -
}

backup_old_conf() {
    conf_folder="/var/tmp/ddeploy/conf"
    if [[ ! -d "$conf_folder" ]]; then
        mkdir -p $conf_folder
    fi
    if [ ! -z "$(find "/etc/ddeploy/configs" -mindepth 1 -maxdepth 1 -print -quit)" ]; then
        cp -f /etc/ddeploy/configs/* $conf_folder
    fi
}

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
* Fri May 30 2024 Nave Cohen <nave1616@hotmail.com> - 1.0.0-1
- Initial package