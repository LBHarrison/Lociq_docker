# Lociq_docker
A containerized setup for Lociq
## Installation

The [AMRFinder](https://github.com/ncbi/amr/wiki) dependency of [Lociq](https://github.com/LBHarrison/lociq) uses a script to collect up-to-date information regarding the reference database, so Lociq installation will use a modified version of this script.

To build the Lociq_docker image:

```
wget https://github.com/LBHarrison/Lociq_docker/raw/main/build-image.sh
wget https://github.com/LBHarrison/Lociq_docker/raw/main/Dockerfile
./build-image.sh
```
Setup may take 20-30 minutes to complete and up to 3.6Gb of disk space.

One way to run the application in [Docker](http://www.docker.com/) is to navigate to the directory that contains your data (GFF folder, reference database, reference plasmid type info and additional sequence files for analysis) and run the following:
```
docker run -it -v ${PWD}:/data lociq bash
```

This will start an interactive docker container where:
  - The contents of your current directory are now in /data/
  - The Lociq program is located in /home/lociq/
  - The piggy executable is /home/lociq/piggy/bin/piggy
  - The user starts in /home/lociq/


Note: when using this [Docker](http://www.docker.com/) container, the only files that are saved are the ones you write to the /data/ folder.  These files will show up in the directory you start [Docker](http://www.docker.com/) in, but nothing else will be saved from the session.

As an example, if the user is in the directory that contains their data, the following commands would run the first step of the analysis:

```
docker run -it -v ${PWD}:/data lociq bash
./T.step1 -G /data/GFF/ -P /home/lociq/piggy/bin/piggy
```

Then, to save the pangenome presence-absence matrix that was generated in this step, the user would need to copy the file to the /data/ directory:

```
scp /home/lociq/Loci_PAM.png /data/
```

This will create the Loci_PAM.png file in the directory the user ran [Docker](http://www.docker.com/) from.


If you have setup the sample data (including external database) and would like to run though the sample data, start the lociq container from your data directory (in the sample setup, this is the 'db' directory) and enter the following:

```
./T.step1 -G /data/GFF/ -P /home/lociq/piggy/bin/piggy

scp /data/combinedplasmid.csv /home/lociq/

./R.step2 -m combinedplasmid.csv -i 0.9 -o 0.1 -p IncC_1__JN157804

./T.step3 -p IncC_1__JN157804 -D /data/plsdb -M /data/plsdb.names -i 0.9 -o 0.01

./T.step4 -d /data/plsdb -f /home/lociq/IncC_1__JN157804/validated/IncC_1__JN157804_validated.fasta -i 1000 -p IncC_1__JN157804

./T.step5 -p IncC_1__JN157804 -d /data/plsdb -f /home/lociq/IncC_1__JN157804/validated/IncC_1__JN157804_validated.fasta

scp -r /IncC_1__JN157804/ /data/
```

This will copy the results of your analysis of the IncC plasmids to your starting directory.
