#!/usr/bin/env cwl-runner
cwlVersion: v1.0
class: CommandLineTool
baseCommand: []

requirements:
  - class: ShellCommandRequirement

inputs:
  str_in:
    type: string
  known_str:
    type: string

outputs:
  str_out: stdout

arguments: [
    {valueFrom: "if", shellQuote: false},
    " [ ",
    "\"",
    {valueFrom: $(inputs.str_in), shellQuote: false},
    "\"",
    {valueFrom: " == ", shellQuote: false},
    "\"",
    {valueFrom: $(inputs.known_str), shellQuote: false},
    "\"",
    " ]; ",
    # {valueFrom: "then echo \"True\"; else echo \"False\"; fi", shellQuote: false}
    {valueFrom: "then exit 0; else exit 1; fi", shellQuote: false}
]
