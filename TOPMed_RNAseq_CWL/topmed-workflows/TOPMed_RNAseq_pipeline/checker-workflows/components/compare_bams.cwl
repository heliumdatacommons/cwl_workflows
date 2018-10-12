#!/usr/bin/env cwl-runner
doc: |
    Compare 2 input BAM files using [BamUtil diff](https://genome.sph.umich.edu/wiki/BamUtil:_diff)

cwlVersion: v1.0
class: CommandLineTool
baseCommand: ["/usr/local/bin/bam", "diff"]

requirements:
- class: DockerRequirement
  dockerPull: quay.io/biocontainers/bamutil:1.0.14--2

inputs:
  bam_one:
    type: File
    inputBinding:
      position: 1
      prefix: --in1
  bam_two:
    type: File
    inputBinding:
      position: 2
      prefix: --in2

outputs:
  std_out:
    type: stdout
