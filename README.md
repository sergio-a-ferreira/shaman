* * *
# shaman #

<p align="center">
<img alt="Logo" src="assets/banner.jpg" style="width:95%; height:120px;">
</p>


##### shell automation management framework #####

Shaman is a bourne again compatible shells (bash, ksh) normalization tool, for CLI and scripting, providing an uniform environment and trying to be distro agnostic.

It's aimed at the command line, but it's functionality also helps process automation and schedulling, providing logging and monitoring tools, enabling event correlation and alarmistics.


* * * 

#### Getting Started ####

Shaman try to be both ksh and bash compatible, so the core scripts and modules are not headed by a she-bang line (#!/path/to/shell). 

The shell used is defined by the calling environment; on scripting mode the shellscript type defined in the she-bang.

To enable shaman in the command line, source shaman/shaman.sh in your user profile file; usually ~/.bashrc in bash or ~/.kshrc in korn shell.

To enable from a shellscript source shaman/shaman.sh before using it's functionality.

```
. /path/to/shaman.sh
```

#### Prerequisites ####

It's coded exclusivelly in sh and GNU standard tools, with alias to support command differences between shells; so it shall run in any modern linux environment without major problems.

Some specific modules require additional software; to enable these modules check the [requirements.txt](requirements.txt) file and install if needed.

> all of the software listed in the requirements.txt file are well known tools that can be installed from distro official or community repositories using your usual package manager.

To make a system wide installation or to enable some specific modules or functionality you will need root previleges; otherwise you're good to go.

#### Installation / Deployment ####

Shaman can be installed in a system wide mode or a user only mode. 

The system wide is available to all system users without needing to be sourced from the login profile file. 

Copy / move the shaman directory to the system software directory - usually /usr/share ou /opt:

```
sudo mv shaman /opt
```

Edit /opt/shaman/shaman.sh script and change the SHAMAN_PATH variable to the path where you copied / moved it:

```
export SHAMAN_PATH=/opt/shaman
```

Finally link the shaman.sh file in /etc/profile.d:

```
sudo ln -s /opt/shaman/shaman.sh /etc/profile.d/shaman.sh

```

For the user only mode, install in the home directory and source in the profile file:

```
. ~/shaman/shaman.sh
```

To load shaman functionality in scripting, just source the shaman.sh in your ksh / bash scripts:

```
. ~/shaman/shaman.sh
```

or 

```
. /opt/shaman/shaman.sh
```


#### Authors ####

* **Sergio Ferreira** - *Initial work* - [sergio-a-ferreira](https://github.com/sergio-a-ferreirashaman.git)



#### License ####

This project is licensed under the Unlicense - see the [LICENSE.md](LICENSE.md) file for details



