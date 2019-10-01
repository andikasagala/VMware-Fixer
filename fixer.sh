#!/bin/sh

#########################################################
#							#
#							#
#		---== VMware Fixer ==---		#
#							#
#		Coder: Andika Sagala			#
#		Date: Oct, 2019				#
#							#
#							#
#							#
#########################################################






#### detecting the OS
Clr=`clear`
echo "$Clr"
Myos=`uname -s`


case "$Myos" in
    Linux)
	LinuxOsVerifier=`uname -r|grep fc`
        case "$LinuxOsVerifier" in
		*fc*)
		echo "You are using Fedora Operating System"
		OSGlobalValue="LF1"
		;;
        esac


	;;

    *)echo "Your Operating System is not listed."
        ;;
esac
########### detecting the OS. Done #########

##############################################
## checking and fixing
case "$OSGlobalValue" in
	LF1)
      	VMwareVersion=`vmware -v |awk '{print $3}'`
	dnf update;dnf upgrade
	dnf install elfutils-libelf-devel
	dnf groupinstall "Development tools"
	rpm -qa | grep kernel-headers
	dnf install kernel-headers
	dnf install kernel-devel
	yum install kernel-headers-`uname -r` kernel-devel-`uname -r`
	wget https://github.com/mkubecek/vmware-host-modules/archive/workstation-$VMwareVersion.tar.gz
	tar -xzf workstation-$VMwareVersion.tar.gz
	cd vmware-host-modules-workstation-$VMwareVersion
	tar -cf vmmon.tar vmmon-only
	tar -cf vmnet.tar vmnet-only
	cp -v vmmon.tar vmnet.tar /usr/lib/vmware/modules/source/
	vmware-modconfig --console --install-all
	openssl req -new -x509 -newkey rsa:2048 -keyout MOK.priv -outform DER -out MOK.der -nodes -days 36500 -subj "/CN=VMware/"
	/usr/src/kernels/$(uname -r)/scripts/sign-file sha256 ./MOK.priv ./MOK.der $(modinfo -n vmmon)
	/usr/src/kernels/$(uname -r)/scripts/sign-file sha256 ./MOK.priv ./MOK.der $(modinfo -n vmnet)
	mokutil --import MOK.der
	echo "Finish, do not forget to enroll it later!"
	sleep 2
	;;

esac


#### done. ########

clear
echo "Hola Papacito & Mamacita !!! I need to reboot now. In 5 secs!"
echo "5"
sleep 1
echo "4"
sleep 1
echo "3"
sleep 1
echo "2"
sleep 1
echo "1"
sleep 1
reboot now;power off;shutdown now; shutdown 1; reboot 1




