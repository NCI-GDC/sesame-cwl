#!/usr/bin/env cwl-runner

cwlVersion: v1.0

class: Workflow

requirements:
  - class: SubworkflowFeatureRequirement
  - class: InlineJavascriptRequirement
  - class: StepInputExpressionRequirement

inputs:
  - id: green_input
    type: File
  - id: red_input
    type: File
  - id: workflow_uuid
    type: string

outputs:
  - id: lvl3betas
    type: File
    outputSource: rename_lvl3/OUTPUT 
  - id: metadata
    type: File
    outputSource: sesame_beta_levels/metadata

steps:
  - id: sanitize_idats
    run: sanitize_idats.cwl
    in:
      - id: green_idat
        source: green_input
      - id: red_idat
        source: red_input
    out:
      - id: sanitized_green
      - id: sanitized_red

  - id: sesame_beta_levels
    run: ../tools/sesame_beta_levels.cwl
    in:
      - id: green_idat
        source: sanitize_idats/sanitized_green
      - id: red_idat
        source: sanitize_idats/sanitized_red
    out:
      - id: lvl3betas
      - id: metadata

  - id: rename_lvl3
    run: ../tools/rename.cwl
    in:
      - id: INPUT
        source: sesame_beta_levels/lvl3betas
      - id: OUTNAME
        source: workflow_uuid
        valueFrom: $(self).methylation_array.sesame.level3betas.txt
    out:
      - id: OUTPUT
