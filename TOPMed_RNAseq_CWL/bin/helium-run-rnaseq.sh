#!/bin/bash
source /opt/toil/venv2.7/bin/activate

# Remove jobstore if it exists
rm -rf /renci/irods/home/chris_ball/start-test/jobstore*

# Download input file
wget https://raw.githubusercontent.com/heliumdatacommons/cwl_workflows/master/topmed-workflows/TOPMed_RNAseq_pipeline/input-examples/rnaseq_wf_irods.yml

# Run workflow from GA4GH TRS API
cwltoil --jobStore /toil-intermediate/jobstore1 \
    --batchSystem chronos \
    --workDir /toil-intermediate \
    --outdir /renci/irods/home/chris_ball/start-test \
    https://dockstore.org:8443/api/ga4gh/v2/tools/%23workflow%2Fgithub.com%2Fheliumdatacommons%2Fcwl_workflows%2FTOPMed_RNAseq_pipeline/versions/master/plain-CWL/descriptor/%2Ftopmed-workflows%2FTOPMed_RNAseq_pipeline%2Frnaseq_pipeline_fastq.cwl \
    rnaseq_wf_irods.yml
