#!/usr/bin/env cwl-runner
doc: |
    Extract all files from archive.tar and filter through gzip

cwlVersion: v1.0
class: CommandLineTool
baseCommand: ["tar", "-zxvf"]

requirements:
- class: DockerRequirement
  dockerPull: heliumdatacommons/topmed-rnaseq:latest
- class: InlineJavascriptRequirement

inputs:
  input_tar:
    type: File
    inputBinding:
      position: 1

outputs:
  untarred_dir:
    type: Directory
    outputBinding:
      glob: .

arguments:
  - prefix: --strip-components
    position: 2
    valueFrom: "1"
    shellQuote: false
