# Workshop Basics

Log into the machine using the IP address and password you were given:

```
# replace IP address:
ssh ubuntu@34.248.77.11
```

Get a copy of the workshop scripts:

```
cd ~
git clone https://github.com/genomehubs/ags-2017-workshop.git
cd ~/ags-2017-workshop
```

There should be eight `.sh` scripts that you have to run in order:

```
ls -1 *sh
01_prepare.sh
02_setup_mysql.sh
03a_test_ensembl.sh
03_import.sh
04_export_files.sh
08_start_download.sh
09_start_blast.sh
11_start_ensembl.sh
```

To run the first script, type:
```
./01_prepare.sh
```
to run the second, type:
```
./02_setup_mysql.sh
```
and so on.

In scripts 03a 09 and 11, you will be prompted to edit a particular file. After editing the file, type `Ctrl+x` to save it

## 01_prepare.sh

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
