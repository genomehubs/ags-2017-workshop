#!/bin/bash
##==============================================================================
##  09_start_blast.sh
##==============================================================================

## WORKSHOP PARTICIPANTS DO THIS STEP BEFORE RUNNING THIS SCRIPT
## Edit links.rb to ensure that links from BLAST results are directed
## to your Ensembl site:

## keys in taxa should match your database name(s) and
## values should match the corresponding SPECIES.URL, e.g.,
## taxa["aedes_aegypti_core_32_85_3"] = "Aedes_aegypti"

## modify the url = "http://ensembl.example.com/#{assembly}" to match
## your domain name

# nano ~/genomehubs/v1/blast/conf/links.rb

docker run -d \
  --name genomehubs-sequenceserver \
  -v ~/genomehubs/v1/blast/conf:/conf:ro \
  -v ~/genomehubs/v1/blast/data:/dbs:ro \
  -p 8083:4567 \
  genomehubs/sequenceserver:latest

