#!/bin/bash
imagename="heliumdatacommons/topmed-rnaseq"

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
echo $DIR
cd $DIR

mkdir src
cp ../src/run_rnaseqc.py src/run_rnaseqc.py

docker build -t "$imagename" -f Dockerfile .
