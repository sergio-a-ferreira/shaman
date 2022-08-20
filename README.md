* * *
# shaman #

<p align="center">
<img alt="Logo" src="assets/banner.svg" style="width:90%; height:240px;">
</p>


## Shell Automation Management Framework ##

Shaman is a process uniformization and automation tool for bourne again compatible shells; e.g.: bash, ksh.

Provides a framework with an uniform environment for CLI and scripting - trying to be distro and shell agnostic.

The main objective is to standartize process automation, with tools to inspect, debug and benchmark your processes; manage stdin / stdout and process logs; error monitorization and handling with event correlations such as alarmistics or publication to a dashboard or panel.

At the core it uses only GNU / Linux standard utilities; for specific processes you may need to install additional software.


* * * 

## Getting Started ##

Shaman try to be both ksh and bash compatible, so the core scripts and modules are not headed by the she-bang line. 

The shell used is defined by the calling environment; on scripting mode the shellscript type is defined by the she-bang.

To enable shaman in the command line, source shaman/shaman.sh in your user profile file; usually ~/.bashrc in bash or ~/.kshrc in korn shell.

To enable from a shellscript source shaman/shaman.sh before using it's functionality.

```
. /path/to/shaman.sh
```

## Prerequisites ##

It's coded in sh and uses GNU standard tools (see [GNU coreutils online help](https://www.gnu.org/software/coreutils/)), with alias to support command differences between shells; so it shall run in any modern linux environment without major problems.

Some specific modules require additional software; to enable these modules check the [requirements.txt](requirements.txt) file and install if needed.

> all of the software listed in the requirements.txt file are well known tools that can be installed from distro official or community repositories using your usual package manager.

To make a system wide installation or to enable some specific modules or functionality you will need root previleges; otherwise you're good to go.

## Installation / Deployment ##

Shaman can be installed in a system wide mode or a user only mode. 

The system wide is available to all system users without needing to be sourced from the login profile file. 

Copy / move the shaman directory to the system's software directory - usually /usr/share ou /opt:

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


## Authors ##

* **Sergio Ferreira** - *Initial work* - [sergio-a-ferreira](https://github.com/sergio-a-ferreirashaman.git)



## License ##

This project is licensed under the Unlicense - see the [LICENSE.md](LICENSE.md) file for details

