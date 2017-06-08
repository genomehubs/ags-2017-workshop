##==============================================================================
##  02_setup_mysql.sh
##==============================================================================

## WORKSHOP PARTICIPANTS DO THIS STEP BEFORE RUNNING THIS SCRIPT
## Edit database.ini config file to import two Ensembl mysql databases
## eg, pick any from ftp://ftp.ensemblgenomes.org/pub/release-32/metazoa/mysql
## and append to SPECIES_DBS
## SPECIES_DBS = [ melitaea_cinxia_core_32_85_1 aedes_aegypti_core_32_85_3 ]

# nano ~/genomehubs/v1/ensembl/conf/database.ini

##------------------------------------------------------------------------------
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

