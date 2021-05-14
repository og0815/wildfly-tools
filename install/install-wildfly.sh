#!/bin/bash

# Download and Basic Install.

USAGE="Usage: $0 <install-mode> <version>
\n\t  - install-mode:
\n\t\t    user   : install under ~/opt
\n\t\t    system : install under /opt
\n\t  - version: exact version number (e.g. 23.0.2.Final)"

if ! [ -x "$(command -v wget)" ]; then
  echo 'Error: wget is not installed.' >&2
  exit 1
fi

if [ $# -lt 2 ]; then
	echo -e $USAGE	
	exit 1
fi

if [ $1 = "user" ]; then
	INSTALL_PATH="$HOME/opt"
elif [ $1 = "system" ]; then
	INSTALL_PATH="/opt"
	if [[ $USER != "root" ]]; then
		echo "install-mode system is only allowed as root but u are $USER"
		exit 1
	fi
else
	echo -e $USAGE
	exit 1
fi

if [ ! -d "$INSTALL_PATH" ]; then
	mkdir "$INSTALL_PATH"
	if [ $? -ne 0 ]; then
		echo "Could not create $INSTALL_PATH"
		exit 1
	fi
fi

if [ ! -w "$INSTALL_PATH" ]; then 
	echo "$INSTALL_PATH is not writable, verify access rights"; 
	exit 1
fi

wget -P /tmp/ "https://download.jboss.org/wildfly/$2/wildfly-$2.tar.gz" 
if [ $? -ne 0 ]; then
	echo "Download not successful, verify version and internet connection"
	exit 1
fi

tar -x -v -z -C $INSTALL_PATH -f /tmp/wildfly-$2.tar.gz
rm -f /tmp/wildfly-$2.tar.gz

if [ $1 = "system" ]; then
	if id wildfly &>/dev/null; then
		chown -R -v wildfly:wildfly $INSTALL_PATH/wildfly-$2
	else
		echo
		echo -e 'Warning: User wildfly does not exist, installation directory keeps user rights'
	fi
fi
	
