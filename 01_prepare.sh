##==============================================================================
##  01_prepare.sh
##==============================================================================

## Update system

#sudo apt update
#sudo apt upgrade -y

## Install docker.io and git

#sudo apt install -y docker.io git
#sudo usermod -aG docker $USER

## Pull docker repos to save time

#docker pull genomehubs/easy-mirror
#docker pull genomehubs/easy-import
#docker pull genomehubs/sequenceserver
#docker pull genomehubs/h5ai

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

