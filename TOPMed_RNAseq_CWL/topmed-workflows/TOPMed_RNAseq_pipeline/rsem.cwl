#!/usr/bin/env cwl-runner
doc: |
    A CWL wrapper for [run_RSEM.py](https://github.com/broadinstitute/gtex-pipeline/blob/master/rnaseq/src/run_RSEM.py)

    Runs [RSEM 1.3.0](https://deweylab.github.io/RSEM/)

    This CWL Tool was developed as step 3 of the TOPMed RNA-seq workflow.

cwlVersion: v1.0
class: CommandLineTool
label: "run-rsem"
baseCommand: rsem-calculate-expression

requirements:
  InlineJavascriptRequirement: {}
  InitialWorkDirRequirement:
    listing:
      - entry: $(inputs.rsem_ref_dir)
        writable: true
hints:
  DockerRequirement:
    dockerPull: quay.io/biocontainers/rsem:1.3.0--boost1.64_3

inputs:
  rsem_ref_dir:
    type: Directory
    inputBinding:
      position: 2
      valueFrom: $(self.basename)/rsem_reference
  transcriptome_bam:
    type: File
    inputBinding:
      position: 1
  prefix_str:
    type: string
    inputBinding:
      position: 3
      valueFrom: $(self).rsem
  max_frag_len:
    type: int
    inputBinding:
      prefix: --fragment-length-max
  estimate_rspd:
    type: boolean
    inputBinding:
      prefix: --estimate-rspd
  is_stranded:
    type: boolean
  paired_end:
    type: boolean
    inputBinding:
      prefix: --paired-end

arguments:
  - prefix: --num-threads
    valueFrom: $(runtime.cores)
  - prefix: --fragment-length-max
    valueFrom: "1000"
  - --no-bam-output
  - --bam
  - ${if (inputs.is_stranded) { return ["--forward-prob", "0.0"];} }

outputs:
  gene_results:
    type: File
    outputBinding:
      glob: $(inputs.prefix_str).rsem.genes.results
  isoforms_results:
    type: File
    outputBinding:
      glob: $(inputs.prefix_str).rsem.isoforms.results
