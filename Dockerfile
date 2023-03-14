FROM ubuntu

LABEL maintainer="Lucas Harrison <Lucas.Harrison@fda.hhs.gov>"

# Maintainer for the original Dockerfile is Arjun Prasad
# Keeping their label in comments to ensure credit
# LABEL maintainer="Arjun Prasad <aprasad@ncbi.nlm.nih.gov>"

ARG VERSION

USER root

# basic setup
RUN apt-get update

RUN DEBIAN_FRONTEND=noninteractive apt-get -y install tzdata

RUN apt-get install -y roary hmmer ncbi-blast+ libcurl4-openssl-dev curl git

ARG SOFTWARE_VERSION

ARG BINARY_URL

# Install AMRFinderPlus
WORKDIR /usr/local/bin
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN curl --silent -L ${BINARY_URL} | tar xvfz - \
    && curl -O https://raw.githubusercontent.com/ncbi/amr/master/test_dna.fa \
         -O https://raw.githubusercontent.com/ncbi/amr/master/test_prot.fa \
         -O https://raw.githubusercontent.com/ncbi/amr/master/test_prot.gff \
         -O https://raw.githubusercontent.com/ncbi/amr/master/test_both.expected \
         -O https://raw.githubusercontent.com/ncbi/amr/master/test_dna.expected \
         -O https://raw.githubusercontent.com/ncbi/amr/master/test_prot.expected

ARG DB_VERSION

RUN amrfinder -u

# Test installation
# WORKDIR /usr/local/bin

# RUN amrfinder --plus -n test_dna.fa -p test_prot.fa -g test_prot.gff -O Escherichia > test_both.got \
#     && diff test_both.expected test_both.got

WORKDIR /home
RUN git clone https://github.com/lbharrison/lociq.git && cd lociq && git clone https://github.com/harry-thorpe/piggy.git

RUN R -e "install.packages(c('remotes', 'pacman', 'optparse', 'BiocManager'))" && \
     R -e "pacman::p_install_version(c('plyr','tidyr','dplyr','Hmisc','shiny','shinythemes','DT','genoPlotR'), c('1.8.6', '1.2.0', '1.0.9', '4.7-1','1.7.3', '1.2.0', '0.27', '0.8.11'))" && \
     R -e "remotes::install_version('corrplot', '0.84')" && \
     R -e "system('/home/lociq/checkdep.R')" && \
     R -e "BiocManager::install('DECIPHER')"

WORKDIR /home/lociq
