#!/usr/bin/env cwl-runner
doc: |
    Calculates the MD5 hash of the input file and compares it to the input MD5 hash.
    If hashes match: Exit 0
    If not match: Exit permanentFail

cwlVersion: v1.0
class: Workflow
id: "Check-file-hash"
label: "Check-file-hash"

requirements:
  - class: SubworkflowFeatureRequirement
  - class: InlineJavascriptRequirement

inputs:
  file_to_check:
    type: File
  input_hash:
    type: string

outputs:
  out_hash_string:
    type: string
    outputSource: get_hash_string/a_string

steps:
  calc_bam_md5:
    run: components/calc_md5.cwl
    in:
      in_file: file_to_check
    out: [out_hash]

  get_hash_string:
    run: components/read_file.cwl
    in:
      a_File: calc_bam_md5/out_hash
    out: [a_string]

  check_hash:
    run: components/string_comparison.cwl
    in:
      str_in: get_hash_string/a_string
      known_str: input_hash
    out: []
