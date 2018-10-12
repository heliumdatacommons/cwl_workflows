#!/usr/bin/env cwl-runner
doc: |
    Calculate the MD5 hash for the input file.

cwlVersion: v1.0
class: CommandLineTool
baseCommand: md5sum

requirements:
- class: DockerRequirement
  dockerPull: heliumdatacommons/topmed-rnaseq:latest

inputs:
  in_file:
    type: File
    inputBinding:
      position: 1

outputs:
  out_hash:
    type: stdout
