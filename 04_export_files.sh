#!/bin/bash
##==============================================================================
##  04_export_files.sh
##==============================================================================

## Run the genomehubs/easy-import Docker container to export
## FASTA/GFF/json files and to index the search database
## Files for download will be written to directories under
## ~/genomehubs/v1/download/data/
## Files ready to format as BLAST databases will be written to
## ~/genomehubs/v1/blast/data/

docker run --rm \
  -u $UID:$GROUPS \
  --name easy-import-operophtera_brumata_obru1_core_32_85_1 \
  --link genomehubs-mysql \
  -v ~/genomehubs/v1/import/conf:/import/conf \
  -v ~/genomehubs/v1/import/data:/import/data \
  -v ~/genomehubs/v1/download/data:/import/download \
  -v ~/genomehubs/v1/blast/data:/import/blast \
  -e DATABASE=operophtera_brumata_obru1_core_32_85_1 \
  -e FLAGS="-e -f -j -i" \
  genomehubs/easy-import:latest

