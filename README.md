# Workshop Basics

Log into the machine using the IP address and password you were given (`$` indicates a command prompt that you should copy-paste and press enter)

```
# replace IP address:
$ ssh ubuntu@34.248.77.11
```

Get a copy of the workshop scripts:

```
$ cd ~
$ git clone https://github.com/genomehubs/ags-2017-workshop.git
$ cd ~/ags-2017-workshop
```

If you type:
```
$ ls -1 *sh
```
you should see eight `.sh` scripts that you have to run in order:
```
01_prepare.sh
02_setup_mysql.sh
03a_test_ensembl.sh
03_import.sh
04_export_files.sh
08_start_download.sh
09_start_blast.sh
11_start_ensembl.sh
```

To run each script, you would type
```
$ ./0N_script_name.sh
```

In scripts 03a 09 and 11, you will be prompted to edit a particular file. After editing the file, type `Ctrl+x` to save it

# GenomeHubs Overview

The full documentation is at https://genomehubs.gitbooks.io/genomehubs/content/, but we are only going to run a subset of the quick start guide (no analyses like repeatmasker/interproscan etc) as we have limited time.

Today we're going to use five docker containers (double lines: MySQL, EasyMirror, EasyImport, SequenceServer, h5a1) to set up three websites:
* ensembl.example.com
* blast.example.com
* download.example.com

![overview](images/GenomeHubs_schematic_overview.png)

## 01_prepare.sh

Make sure you are in the ags-2017-workshop folder and then type:
```
$ ./01_prepare.sh
```

As you wait for it to run, let's look at what it does:


```bash
#!/bin/bash
##==============================================================================
##  01_prepare.sh
##==============================================================================

## Update system

sudo apt update
sudo apt upgrade -y

## Install docker.io and git

sudo apt install -y docker.io git
sudo usermod -aG docker $USER

## Pull docker repos

docker pull genomehubs/easy-mirror
docker pull genomehubs/easy-import
docker pull genomehubs/sequenceserver
docker pull genomehubs/h5ai

##------------------------------------------------------------------------------
## Create a new directory in your home directory

mkdir ~/genomehubs && cd ~/genomehubs

##------------------------------------------------------------------------------
## Clone the example configuration files from genomehubs/template:
## Naming the template directory v1 is convenient for site versioning

git clone https://github.com/genomehubs/template v1

##------------------------------------------------------------------------------
## Install and configure lighttpd for redirecting domain names

sudo apt install -y lighttpd

sudo perl -i.bak -plne 's/mod_rewrite",/mod_rewrite",\n  "mod_proxy",/' \
  /etc/lighttpd/lighttpd.conf

echo '
$HTTP["host"] =~ "ensembl.example.com"{
  proxy.server = ("" => ("" => (
    "host" => "127.0.0.1",
    "port" => "8081",
    "fix-redirects" => 1
  )))
}
$HTTP["host"] =~ "download.example.com"{
  proxy.server = ("" => ("" => (
    "host" => "127.0.0.1",
    "port" => "8082",
    "fix-redirects" => 1
  )))
}
$HTTP["host"] =~ "blast.example.com"{
  proxy.server = ("" => ("" => (
    "host" => "127.0.0.1",
    "port" => "8083",
    "fix-redirects" => 1
  )))
}
' | sudo tee -a /etc/lighttpd/lighttpd.conf >/dev/null

sudo service lighttpd restart
```

## 02_setup_mysql.sh

This step will download all the tables  copy of a default ensembl species database (the butterfly *Melitaea cinxia*) and all the other tables needed for Ensembl to run.

![mysql](GenomeHubs_MySQL.png)

```bash
#!/bin/bash
##==============================================================================
##  02_setup_mysql.sh
##==============================================================================

## Create a mysql/data directory to allow the databases to be stored
## outside of the MySQL container:

mkdir -p ~/genomehubs/mysql/data

##------------------------------------------------------------------------------
## Create a MySQL Docker container to host the Ensembl Databases
## for your GenomeHub and wait 10 seconds for it to start:

docker run -d \
  --name genomehubs-mysql \
  -v ~/genomehubs/mysql/data:/var/lib/mysql \
  -e MYSQL_ROOT_PASSWORD=CHANGEME \
  -e MYSQL_ROOT_HOST='172.17.0.0/255.255.0.0' \
  -p 3306:3306 \
  mysql/mysql-server:5.5

sleep 10

##------------------------------------------------------------------------------
## Increase MySQL max_allowed_packet to allow import of large scaffolds:

docker exec genomehubs-mysql mysql -u root --password=CHANGEME -e \
  'set global max_allowed_packet=10000000000;'

##------------------------------------------------------------------------------
## Run the `database.sh` script in a `genomehubs/easy-mirror` Docker container:
## This script will set up database users and import databases into your MySQL
## container based on the information in the `database.ini` configuration file.

docker run --rm \
  --name genomehubs-ensembl \
  --volume ~/genomehubs/v1/ensembl/conf:/ensembl/conf:ro \
  --link genomehubs-mysql \
  genomehubs/easy-mirror:latest \
  /ensembl/scripts/database.sh /ensembl/conf/database.ini
```
