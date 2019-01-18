#!/usr/bin/env cwl-runner

cwlVersion: v1.0

class: Workflow

requirements:
  - class: InlineJavascriptRequirement
  - class: StepInputExpressionRequirement
  - class: SubworkflowFeatureRequirement

inputs:
  - id: bioclient_config
    type: File
  - id: bioclient_load_bucket
    type: string
  - id: green_input_gdc_id
    type: string
  - id: green_input_file_size
    type: long
  - id: red_input_gdc_id
    type: string
  - id: red_input_file_size
    type: long
  - id: workflow_uuid
    type: string

outputs:
  - id: indexd_lvl3betas_uuid
    type: string
    outputSource: emit_lvl3betas_uuid/output
  - id: indexd_metadata_uuid
    type: string
    outputSource: emit_metadata_uuid/output

steps:
  - id: extract_green_input
    run: ../tools/bio_client_download.cwl
    in:
      - id: config-file
        source: bioclient_config
      - id: download_handle
        source: green_input_gdc_id
      - id: file_size
        source: green_input_file_size
    out:
      - id: output

  - id: extract_red_input
    run: ../tools/bio_client_download.cwl
    in:
      - id: config-file
        source: bioclient_config
      - id: download_handle
        source: red_input_gdc_id
      - id: file_size
        source: red_input_file_size
    out:
      - id: output

  - id: transform
    run: transform.cwl
    in:
      - id: green_input
        source: extract_green_input/output
      - id: red_input
        source: extract_red_input/output
      - id: workflow_uuid
        source: workflow_uuid
    out:
      - id: lvl3betas
      - id: metadata

  - id: load_lvl3betas
    run: ../tools/bio_client_upload_pull_uuid.cwl
    in:
      - id: config-file
        source: bioclient_config
      - id: input
        source: transform/lvl3betas
      - id: upload-bucket
        source: bioclient_load_bucket
      - id: upload-key
        valueFrom: $(inputs.job_uuid)/$(inputs.input.basename)
      - id: job_uuid
        source: workflow_uuid
        valueFrom: $(null)
    out:
      - id: output

  - id: load_metadata
    run: ../tools/bio_client_upload_pull_uuid.cwl
    in:
      - id: config-file
        source: bioclient_config
      - id: input
        source: transform/metadata
      - id: upload-bucket
        source: bioclient_load_bucket
      - id: upload-key
        valueFrom: $(inputs.job_uuid)/$(inputs.input.basename)
      - id: job_uuid
        source: workflow_uuid
        valueFrom: $(null)
    out:
      - id: output

  - id: emit_lvl3betas_uuid
    run: ../tools/emit_json_value.cwl
    in:
      - id: input
        source: load_lvl3betas/output
      - id: key
        valueFrom: did
    out:
      - id: output

  - id: emit_metadata_uuid
    run: ../tools/emit_json_value.cwl
    in:
      - id: input
        source: load_metadata/output
      - id: key
        valueFrom: did
