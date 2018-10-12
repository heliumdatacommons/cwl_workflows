#!/usr/bin/env cwl-runner
cwlVersion: v1.0
class: ExpressionTool

requirements: { InlineJavascriptRequirement: {} }

inputs:
  a_File:
    type: File
    inputBinding:
      loadContents: true

expression: |
  ${ return { "a_string": inputs.a_File.contents.split(" ")[0] }; }

outputs:
  a_string: string
