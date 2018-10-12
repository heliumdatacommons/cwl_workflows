#!/bin/bash
set -e
# wget https://beta.commonsshare.org/django_irods/download/68ce40f872cd48db8b3adb3b334242af/data/star-index-chr12.tar.gz
# wget https://beta.commonsshare.org/django_irods/download/13dd01afa4234f5d8cbbfb1c371e8fef/data/LC_C13_cRNA_sequence_R1_sub.fastq.gz
# wget https://beta.commonsshare.org/django_irods/download/13dd01afa4234f5d8cbbfb1c371e8fef/data/LC_C13_cRNA_sequence_R2_sub.fastq.gz
# wget https://beta.commonsshare.org/django_irods/download/3d004e30823f45ecbe5e5d40279264ba/data/gencode.v26.annotation.chr12.withTranscriptID.gtf
# wget https://beta.commonsshare.org/django_irods/download/1033eba844784b5e8a9cfd0029c9f75c/data/rsem_reference.tar.gz
# wget https://beta.commonsshare.org/django_irods/download/3d004e30823f45ecbe5e5d40279264ba/data/chr12.fa
# wget https://beta.commonsshare.org/django_irods/download/3d004e30823f45ecbe5e5d40279264ba/data/chr12.fai
# wget https://beta.commonsshare.org/django_irods/download/3d004e30823f45ecbe5e5d40279264ba/data/chr12.dict

# gunzip LC_C13_cRNA_sequence_R1_sub.fastq.gz
# gunzip LC_C13_cRNA_sequence_R2_sub.fastq.gz

# tar -zxvf star-index-chr12.tar.gz
# tar -zxvf rsem_reference.tar.gz

BASE_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
DIR="$( cd "$( dirname "${BASE_DIR}" )" && pwd )"
cd $DIR"/test-data/"

tar -zxvkf reference-files.tar.gz
tar -zxvkf rsem_reference.tar.gz
tar -zxvkf star_chr12.tar.gz
