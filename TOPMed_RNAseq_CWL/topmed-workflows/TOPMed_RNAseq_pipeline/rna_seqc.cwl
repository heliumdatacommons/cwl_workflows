#!/usr/bin/env cwl-runner
doc: |
    A CWL wrapper for [run_rnaseqc.py](https://github.com/heliumdatacommons/cwl_workflows/blob/master/topmed-workflows/TOPMed_RNAseq_pipeline/src/run_rnaseqc.py) duplicated from [run_rnaseqc.py](https://github.com/broadinstitute/gtex-pipeline/blob/master/rnaseq/src/run_rnaseqc.py) with minor modifications.

    Runs [RNA-SeQC 1.1.9](https://github.com/francois-a/rnaseqc)

    This CWL Tool was developed as step 4 of the TOPMed RNA-seq workflow.

    [GitHub Repo](https://github.com/heliumdatacommons/cwl_workflows)

cwlVersion: v1.0
class: CommandLineTool
label: "run-seqc"
# run_rnaseqc.py is not an executable file in the docker container.
baseCommand: ["python3", "/src/run_rnaseqc.py"]

requirements:
  InlineJavascriptRequirement: {}
  DockerRequirement:
    dockerPull: heliumdatacommons/topmed-rnaseq:latest

inputs:
  bam_file:
    type: File
    secondaryFiles:
      - .bai
    inputBinding:
      position: 1
  genes_gtf:
    type: File
    inputBinding:
      position: 2
  genome_fasta:
    type: File
    secondaryFiles:
      - .fai
      - ^.dict
    inputBinding:
      position: 3
  prefix_str:
    type: string
    inputBinding:
      position: 4
  rnaseqc_flags:
    type:
      type: array
      items: string
      inputBinding:
        itemSeparator: " "
    inputBinding:
      position: 7
      prefix: --rnaseqc_flags
  # gatk_flags:
  #   type:
  #     type: "null"
  #     type: array
  #     items: string
  #     inputBinding:
  #       itemSeparator: " "
  #   inputBinding:
  #     position: 8
  #     prefix: --gatk_flags

arguments:
  - prefix: --memory
    valueFrom: $(runtime.ram / 1024)
  - prefix: --java
    valueFrom: /usr/lib/jvm/java-1.7.0-openjdk-amd64/bin/java
outputs:
  gene_rpkm:
    type: File
    outputBinding:
      glob: "*.gene_rpkm.gct.gz"
  gene_counts:
    type: File
    outputBinding:
      glob: "*.gene_reads.gct.gz"
  exon_counts:
    type: File
    outputBinding:
      glob: "*.exon_reads.gct.gz"
  count_metrics:
    type: File
    outputBinding:
      glob: "*.metrics.tsv"
  count_outputs:
    type: File
    outputBinding:
      glob: "*.tar.gz"
