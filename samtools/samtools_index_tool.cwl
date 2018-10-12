#!/usr/bin/env cwl-runner
doc: |
    A wrapper for running `samtools index <cram>`.

cwlVersion: v1.0
class: CommandLineTool
label: "run-index-bam"
baseCommand: [ samtools, index ]

requirements:
  DockerRequirement:
    dockerPull: statgen/alignment:1.0.0
  InitialWorkDirRequirement:
    listing:
      - $(inputs.input_bam)
  ResourceRequirement:
    ramMin: 7500
    coresMin: 2

inputs:
  input_bam:
    type: File
    inputBinding:
      position: 1
      valueFrom: $(self.basename)

outputs:
  bam_index:
    type: File
    outputBinding:
      glob: '*.crai'
