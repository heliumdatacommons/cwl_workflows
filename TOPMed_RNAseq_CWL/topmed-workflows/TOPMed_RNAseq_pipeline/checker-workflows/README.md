# TOPMed RNA-seq pipeline - Checker Workflow

The checker workflow verifies the output of the CWL workflow, more information [here](https://docs.dockstore.org/docs/publisher-tutorials/checker-workflows/).

## Quick start
1. Dockstore CLI, CWLTool, Git, [Git LFS](https://git-lfs.github.com/) and Docker should be installed.
2. Clone this GitHub repository:
    ```
    git clone https://github.com/heliumdatacommons/cwl_workflows.git
    ```
3. Decompress sample files.
    ```
    ./topmed-workflows/TOPMed_RNAseq_pipeline/input-examples/download_examples.sh
    ```
4. Use [this](topmed-workflows/TOPMed_RNAseq_pipeline/checker-workflows/inputs/rnaseq_pipeline_fasta_checker.yml) input file or edit the file paths based on your local machine paths.
5. Run the checker workflow with CWLTool.
    ```
    cwltool topmed-workflows/TOPMed_RNAseq_pipeline/checker-workflows/rnaseq_pipeline_fastq_checker.cwl \
    topmed-workflows/TOPMed_RNAseq_pipeline/checker-workflows/inputs/rnaseq_pipeline_fasta_checker.yml
    ```

### Verification steps
The main workflow has 2 verification options:
1. [Verify BAM file](topmed-workflows/TOPMed_RNAseq_pipeline/checker-workflows/check_bams_wf.cwl) - compares the BAM file output to a previously generated BAM file.
2. [Verify file md5 sum](topmed-workflows/TOPMed_RNAseq_pipeline/checker-workflows/check_md5_wf.cwl) - compares the md5 sum of the new file to a previously computed md5 sum.

The full checker workflow is [here](topmed-workflows/TOPMed_RNAseq_pipeline/checker-workflows/rnaseq_pipeline_fastq_checker.cwl) and is on Dockstore [here](https://dockstore.org/workflows/github.com/heliumdatacommons/cwl_workflows/TOPMed_RNAseq_pipeline_cwl_checker).

An example input file for the checker workflow is [here](topmed-workflows/TOPMed_RNAseq_pipeline/checker-workflows/inputs/rnaseq_pipeline_fasta_checker.yml).

Individual CWL Tools used in the checker workflow are [here](topmed-workflows/TOPMed_RNAseq_pipeline/checker-workflows/components) with input examples [here](topmed-workflows/TOPMed_RNAseq_pipeline/checker-workflows/components/input-examples).

### Input files
Sample input files to run the checker workflow are available within this repo. Follow the steps [here](topmed-workflows/TOPMed_RNAseq_pipeline/README.md#quick-start) to obtain the main workfow inputs. The checker workflow speific files are [here](topmed-workflows/TOPMed_RNAseq_pipeline/checker-workflows/checker-data).
