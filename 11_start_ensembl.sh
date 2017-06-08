#!/bin/bash
##==============================================================================
##  11_start_ensembl.sh
##==============================================================================

## WORKSHOP PARTICIPANTS DO THIS STEP BEFORE RUNNING THIS SCRIPT
## Edit setup.ini to ensure that your two extra species are in SPECIES_DBS
## eg
## SPECIES_DBS = [
##   mellitaea_cinxia_core_32_85_1
##   operophtera_brumata_obru1_core_32_85_1
##   aedes_aegypti_core_32_85_3
## ]

# nano ~/genomehubs/v1/ensembl/conf/setup.ini

##------------------------------------------------------------------------------
## Start the EasyMirror container after removing the existing one, if any

docker rm -f genomehubs-ensembl

docker run -d \
  --name genomehubs-ensembl \
  -v ~/genomehubs/v1/ensembl/conf:/ensembl/conf:ro \
  --link genomehubs-mysql \
  -p 8081:8080 \
  genomehubs/easy-mirror:latest
