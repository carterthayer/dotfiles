# Dotfiles
---

These are the dotfiles I use in my virtual machine for both work and school.

## setup.sh
---

This bash script has required arguments. Run with sudo in the cloned directory.
* programs - Install my favorite and required programs from apt-get and pip.
* files - Link the dot files to the home directory.
* virtual - Install the VirtualBox guest additions, you must mount that to the machine first.
* all - Do all of the above.


### Notes
---

* Before installing these. Make sure the required proxy settings are in .profile and visudo.
* If the virtual machine doesn't detect the resolution correctly. You will have to edit .xsessionrc.
