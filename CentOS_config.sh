#!/usr/bin/env bash

if  (( EUID != 0 ))
then
	echo "Script should be run as root"
	exit 1
else
	echo "Detected running as root"
fi

# Configure shell
wget -O /etc/profile.d/colorprompt.sh https://gist.githubusercontent.com/kholis/3985921/raw/d55393f64c4a21dbd419c769548c6319a21d84b4/colorprompt.sh

# Enable centosplus
sed -i 's/enabled=0/enabled=1/' /etc/yum.repos.d/CentOS-centosplus.repo

# Enable PowerTools
sed -i 's/enabled=0/enabled=1/' /etc/yum.repos.d/CentOS-PowerTools.repo
if [[ -f /etc/yum.repos.d/CentOS-Stream-PowerTools.repo ]]
then
	sed -i 's/enabled=0/enabled=1/' /etc/yum.repos.d/CentOS-Stream-PowerTools.repo
fi

# Install epel
dnf install -y epel-release

# Install elrepo
rpm --import https://www.elrepo.org/RPM-GPG-KEY-elrepo.org
dnf install -y https://www.elrepo.org/elrepo-release-8.0-2.el8.elrepo.noarch.rpm
sed -i 's/enabled=0/enabled=1/4' /etc/yum.repos.d/elrepo.repo

# Require root password for sudo
echo "Defaults rootpw" > /etc/sudoers.d/Require_Root_Pass

# Modify nano, CentOS 7 has an older version so some options arent'y the same
if [[ $(cat /etc/centos-release | cut -d ' ' -f 4 | cut -d '.' -f 1) -ge 8 ]]
then
  sed -i 's/# set smooth/set smooth/' /etc/nanorc
  sed -i 's/# set constantshow/set constantshow/' /etc/nanorc
else
  sed -i 's/# set smooth/set smooth/' /etc/nanorc
  sed -i 's/# set const/set const/' /etc/nanorc
fi
