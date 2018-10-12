#!/usr/bin/env cwl-runner
doc: |
    Compare 2 input BAM files and report results.
    Exit 0 if sucess.
    Exit permanentFail if not sucess.

cwlVersion: v1.0
class: Workflow
id: "Check-bam-file"
label: "Check-bam-file"

requirements:
  - class: SubworkflowFeatureRequirement
  - class: InlineJavascriptRequirement

inputs:
  bam_one:
    type: File
  bam_two:
    type: File
  known_str:
    type: string

outputs:
  out_string:
    type: string

steps:
  run_compare_bams:
    run: components/compare_bams.cwl
    in:
      bam_one: bam_one
      bam_two: bam_two
    out: [std_out]

  read_string:
    run: components/read_file.cwl
    in:
      a_File: run_compare_bams/std_out
    out: [a_string]

  check_string:
    run: components/string_comparison.cwl
    in:
      str_in: read_string/a_string
      known_str: known_str
    out: []
