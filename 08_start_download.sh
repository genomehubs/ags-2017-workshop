#!/bin/bash
##==============================================================================
##  08_start_download.sh
##==============================================================================

docker run -d \
  --name genomehubs-h5ai \
  -v ~/genomehubs/v1/download/conf:/conf:ro \
  -v ~/genomehubs/v1/download/data:/var/www/v1:ro \
  -p 8082:8080 \
  genomehubs/h5ai:latest

