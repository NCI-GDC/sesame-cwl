cwlVersion: v1.0
class: Workflow
id: gdc_sesame_main_workflow
requirements:
  - class: SubworkflowFeatureRequirement
  - class: InlineJavascriptRequirement
  - class: StepInputExpressionRequirement

inputs:
  green_input: File
  red_input: File
  job_uuid: string

outputs:
  lvl3betas:
    type: File
    outputSource: rename_lvl3/OUTPUT
  metadata:
    type: File
    outputSource: rename_metadata/OUTPUT
  idat_noid_grn:
    type: File
    outputSource: rename_noid_Grn/OUTPUT
  idat_noid_red:
    type: File
    outputSource: rename_noid_Red/OUTPUT

steps:
  sanitize_idats:
    run: sanitize_idats_workflow.cwl
    in:
      green_idat: green_input
      red_idat: red_input
    out: [ sanitized_green, sanitized_red ]

  sesame_deidentify:
    run: ../../tools/sesame_deidentify.cwl
    in:
      green_idat: sanitize_idats/sanitized_green
      red_idat: sanitize_idats/sanitized_red
    out: [green_idat_noid, red_idat_noid]

  sesame_beta_levels:
    run: ../../tools/sesame_beta_levels.cwl
    in:
      green_idat: sesame_deidentify/green_idat_noid
      red_idat: sesame_deidentify/red_idat_noid
    out: [ lvl3betas, metadata ]

  rename_lvl3:
    run: ../../tools/rename.cwl
    in:
      INPUT: sesame_beta_levels/lvl3betas
      OUTNAME:
        source: job_uuid
        valueFrom: $(self).methylation_array.sesame.level3betas.txt
    out: [ OUTPUT ]

  rename_metadata:
    run: ../../tools/rename.cwl
    in:
      INPUT: sesame_beta_levels/metadata
      OUTNAME:
        source: job_uuid
        valueFrom: $(self).methylation_array.sesame.metadata.json
    out: [ OUTPUT ]

  rename_noid_Grn:
    run: ../../tools/rename.cwl
    in:
      INPUT: sesame_deidentify/green_idat_noid
      OUTNAME:
        source: job_uuid
        valueFrom: $(self)_noid_Grn.idat
    out: [ OUTPUT ]

  rename_noid_Red:
    run: ../../tools/rename.cwl
    in:
      INPUT: sesame_deidentify/red_idat_noid
      OUTNAME:
        source: job_uuid
        valueFrom: $(self)_noid_Red.idat
    out: [ OUTPUT ]