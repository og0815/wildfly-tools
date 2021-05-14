#!/bin/bash

# installs or upgrades/downgrades one connector

USAGE="Usage: $0 <connector-type> <version> <wildfly-directory> [replace]
\n\t  - connector-type: mariadb or mysql
\n\t  - version: exact version number (e.g. mysql 5.1.49 / mariadb 2.7.3) 
\n\t  - wildfly-directory: directory of the wildfly installation
\n\t  - replace: optional, will replace any mysql or mariadb jar"

if ! [ -x "$(command -v wget)" ]; then
  echo 'Error: wget is not installed.' >&2
  exit 1
fi

if [ $# -lt 3 ]; then
	echo -e $USAGE	
	exit 1
fi

if [ $1 = "mysql" ]; then
	URL="https://repo.maven.apache.org/maven2/mysql/mysql-connector-java/$2/mysql-connector-java-$2.jar"
elif [ $1 = "mariadb" ]; then
	URL="https://downloads.mariadb.com/Connectors/java/connector-java-$2/mariadb-java-client-$2.jar"
else
	echo -e $USAGE
	exit 1
fi

if [ ! -w "$3/standalone/deployments" ]; then 
	echo "$3/standalone/deployments is not writable, verify access rights"; 
	exit 1
fi

if [ $4 = "replace" ]; then
	rm -f -v $3/standalone/deployments/mariadb-java-client-*.jar
	rm -f -v $3/standalone/deployments/mariadb-java-client-*.jar.undeployed
	rm -f -v $3/standalone/deployments/mysql-connector-java-*.jar
	rm -f -v $3/standalone/deployments/mysql-connector-java-*.jar.undeployed
fi

wget -P $3/standalone/deployments/ $URL 
if [ $? -ne 0 ]; then
	echo "Download not successful, verify version and internet connection"
	exit 1
fi
