#!/usr/bin/env cwl-runner
doc: |
    A CWL wrapper for [run_MarkDuplicates.py](https://github.com/broadinstitute/gtex-pipeline/blob/master/rnaseq/src/run_MarkDuplicates.py)

    Runs [Picard](https://github.com/broadinstitute/picard) [MarkDuplicates](https://broadinstitute.github.io/picard/command-line-overview.html#MarkDuplicates)

    This CWL Tool was developed as step 2 of the TOPMed RNA-seq workflow.

    [GitHub Repo](https://github.com/heliumdatacommons/cwl_workflows)

cwlVersion: v1.0
class: CommandLineTool
label: "run-MarkDuplicates"
baseCommand: [picard, MarkDuplicates]

hints:
  EnvVarRequirement:
    envDef:
      JAVA_TOOL_OPTIONS: "-Xmx$(runtime.ram)M" 
  DockerRequirement:
    dockerPull: quay.io/biocontainers/picard:2.9.2--2

inputs:
  input_bam:
    type: File
  prefix_str:
    type: string

arguments:
  - I=$(inputs.input_bam.path)
  - O=$(runtime.outdir)/$(inputs.input_bam.nameroot).md.bam
  - M=$(runtime.outdir)/$(inputs.prefix_str).marked_dup_metrics.txt
  - ASSUME_SORT_ORDER=coordinate
  - OPTICAL_DUPLICATE_PIXEL_DISTANCE=100

outputs:
  bam_file:
    type: File
    outputBinding:
      glob: $(inputs.input_bam.nameroot).md.bam
  metrics:
    type: File
    outputBinding:
      glob: $(inputs.prefix_str).marked_dup_metrics.txt

