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

steps:
  sanitize_idats:
    run: sanitize_idats_workflow.cwl
    in:
      green_idat: green_input
      red_idat: red_input
    out: [ sanitized_green, sanitized_red ]

  sesame_beta_levels:
    run: ../../tools/sesame_beta_levels.cwl
    in:
      green_idat: sanitize_idats/sanitized_green
      red_idat: sanitize_idats/sanitized_red
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
        valueFrom: $(self).methylation_array.sesame.metadata.txt
    out: [ OUTPUT ]
