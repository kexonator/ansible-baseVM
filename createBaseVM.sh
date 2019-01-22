#!/bin/bash
USER=$USER
SCRIPT_FILE=/home/$USER/prepareVM.sh
LOG_FILE=/home/$USER/prepareVM.log

echo "Please make sure to create a snapshot of your VM, before proceeding, if this VM is of ANY value to you!"
echo "Please also make sure that you are running this script on a fresh VM, with no modified /etc/fstab, as it could break it!"
read -p "Press ENTER to continue..."
sudo apt-get install -y virtualbox-guest-dkms virtualbox-guest-utils virtualbox-guest-x11 || exit 1
if [ -f /etc/rc.local ]; then
    echo "Found existing rc.local, performing backup..."
	sudo mv /etc/rc.local /home/$USER/rc.local.bk
fi

echo "\
#!/bin/bash
VBoxControl guestproperty set /VirtualBox/GuestAdd/SharedFolders/shared /home/$USER/shared &&\
VBoxControl guestproperty set /VirtualBox/GuestAdd/SharedFolders/scanner /home/$USER/Downloads &&\
adduser $USER vboxsf &&\
echo \"shared /home/$USER/shared vboxsf defaults,fmode=700,uid=1000,umask=0077 0 0\" | tee -a /etc/fstab &&\
echo \"scanner /home/$USER/Downloads vboxsf defaults,fmode=700,uid=1000,umask=0077 0 0\" | tee -a /etc/fstab &&\
echo \"deb http://ppa.launchpad.net/ansible/ansible/ubuntu trusty main\" | tee -a /etc/apt/sources.list &&\
 apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 93C4A3FD7BB9C367 &&\
apt-get update &&\
apt-get install -y ansible 
rm /etc/rc.local
if [ -f /home/$USER/rc.local.bk ]; then
    echo "Found saved rc.local, restoring..."
	mv /home/$USER/rc.local.bk /etc/rc.local
fi
echo \"Rebooting in 5 seconds ...\" &&\
sleep 5s &&\
reboot now &&\
exit 0
" > $SCRIPT_FILE &&
chmod +x $SCRIPT_FILE &&
echo "#!/bin/bash
$SCRIPT_FILE > $LOG_FILE
exit 0" | sudo tee -a /etc/rc.local &&\
sudo chmod +x /etc/rc.local
echo "Rebooting in 5 seconds ..."
sleep 5s
sudo reboot now
