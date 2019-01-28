# ansible-baseVM
For non-Vagrant environments, those scripts create a new "base" Virtual Machine, installing VBoxAdditions, adding mounts to fastab and installing ansible.

# requirements
You need a virtual machine with pre-installed debian OS (tested with Kubuntu 18.04.1 LTS). Make sure to either create folders in VM, named "scanner" and "shared", or to adapt the script. Those folders will be mounted into VM, using fstab, as described further.

# general behaviour
usually, preparing virtual machines for ansible provisioning is not in any scope. For a very special use case, where it is not possible to use vagrant, i have created this script, which will:
1. install virtual box additions.
2. add current user to the vboxsf group.
3. prepare further scripts, so they will be ran after a reboot (current rc.local will be backed up, as it will be replaced).
4. reboot.
5. set VirtualBox properties and add fstab entries, so two shared folders will be automatically mounted from the host system: shared (to ~/shared) and scanner (to ~/Downloads). Use case for the latter one is scanning downloads externally by antivirus software.
6. add public key and install latest version of ansible.
7. restore original rc.local (if one was backed up).
8. reboot.

a logfile will be placed into the home folder of configured user (current user by default).

# configuration
currently it is possibe to pick a user and location for the logfile

# future features
- it is planned to checkout pre-defined ansible script from a configurable repository and start provisioning.
