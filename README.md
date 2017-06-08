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

There should be 8 `.sh` scripts that you have to run in order:

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
