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
/usr/local/share/ddeploy/preinst "$1"

%post
/usr/local/share/ddeploy/postinst "$1"

%preun
/usr/local/share/ddeploy/prerm "$1"

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