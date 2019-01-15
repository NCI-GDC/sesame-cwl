#!/usr/bin/env cwl-runner

cwlVersion: v1.0

class: Workflow

inputs:
  - id: green_input
    type: File
  - id: red_input
    type: File
  - id: aliquot_id
    type: string
  - id: workflow_uuid
# TODO Add inputs for workflow UUID and aliquot ID also needs to be added to the tool and Docker R script


outputs:
  - id: lvl3betas
    type: File
    source: sesame_beta_levels/lvl3betas
  - id: metadata
    type: File
    source: sesame_beta_levels/metadata

steps:
  - id: sanitize_idats
    run: santize_idats.cwl
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
        valueFrom: |
        ${
          var output = "";
          output = inputs.workflow_uuid + ".methylation_array.sesame.level3betas.txt"
        } 