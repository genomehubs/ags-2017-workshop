#!/bin/bash
##==============================================================================
##  03a_test_ensembl.sh
##==============================================================================

## WORKSHOP PARTICIPANTS DO THIS STEP BEFORE RUNNING THIS SCRIPT
## Edit setup.ini config file, add SPECIES_DBS that you chose in database.ini
## SPECIES_DBS = [ melitaea_cinxia_core_32_85_1 aedes_aegypti_core_32_85_3 ]
## and comment out the 3 lines beginning GENOMEHUBS_PLUGIN_...

# nano ~/genomehubs/v1/ensembl/conf/database.ini

##------------------------------------------------------------------------------
## Run the `genomehubs/easy-mirror` Docker container to launch the site

docker run -d \
  --name genomehubs-ensembl \
  --volume ~/genomehubs/v1/ensembl/conf:/ensembl/conf:ro \
  --link genomehubs-mysql \
  -p 8081:8080 \
  genomehubs/easy-mirror:latest

