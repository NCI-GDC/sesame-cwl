cwlVersion: v1.0
class: Workflow
id: gdc_sesame_workflow
requirements:
  - class: InlineJavascriptRequirement
  - class: StepInputExpressionRequirement
  - class: SubworkflowFeatureRequirement

inputs:
  bioclient_config: File
  bioclient_load_bucket: string
  green_input_gdc_id: string
  green_input_file_size: long
  red_input_gdc_id: string
  red_input_file_size: long
  job_uuid: string

outputs:
  indexd_sesame_methylation_lvl3betas_uuid:
    type: string
    outputSource: emit_lvl3betas_uuid/output
  indexd_sesame_methylation_metadata_uuid:
    type: string
    outputSource: emit_metadata_uuid/output

steps:
  extract_green_input:
    run: ../tools/bio_client_download.cwl
    in:
      config-file: bioclient_config
      download_handle: green_input_gdc_id
      file_size: green_input_file_size
    out: [ output ]

  extract_red_input:
    run: ../tools/bio_client_download.cwl
    in:
      config-file: bioclient_config
      download_handle: red_input_gdc_id
      file_size: red_input_file_size
    out: [ output ]

  transform:
    run: ./subworkflows/gdc_sesame_main_workflow.cwl
    in:
      green_input: extract_green_input/output
      red_input: extract_red_input/output
      job_uuid: job_uuid
    out: [ lvl3betas, metadata ]

  load_lvl3betas:
    run: ../tools/bio_client_upload_pull_uuid.cwl
    in:
      config-file: bioclient_config
      input: transform/lvl3betas
      upload-bucket: bioclient_load_bucket
      upload-key:
        source: [ job_uuid, transform/lvl3betas ]
        valueFrom: $(self[0])/$(self[1].basename)
      job_uuid: job_uuid
    out: [ output ]

  load_metadata:
    run: ../tools/bio_client_upload_pull_uuid.cwl
    in:
      config-file: bioclient_config
      input: transform/metadata
      upload-bucket: bioclient_load_bucket
      upload-key:
        source: [ job_uuid, transform/metadata ]
        valueFrom: $(self[0])/$(self[1].basename)
    out: [ output ]

  emit_lvl3betas_uuid:
    run: ../tools/emit_json_value.cwl
    in:
      input: load_lvl3betas/output
      key:
        default: did
    out: [ output ]

  emit_metadata_uuid:
    run: ../tools/emit_json_value.cwl
    in:
      input: load_metadata/output
      key:
        default: did
    out: [ output ]