##==============================================================================
##  03_import.sh
##==============================================================================

## Run the genomehubs/easy-import Docker container to import FASTA + GFF

docker run --rm \
  -u $UID:$GROUPS \
  --name easy-import-operophtera_brumata_v1_core_32_85_1 \
  --link genomehubs-mysql \
  -v ~/genomehubs/v1/import/conf:/import/conf \
  -v ~/genomehubs/v1/import/data:/import/data \
  -e DATABASE=operophtera_brumata_obru1_core_32_85_1 \
  -e FLAGS="-s -p -g -v" \
  genomehubs/easy-import:latest

