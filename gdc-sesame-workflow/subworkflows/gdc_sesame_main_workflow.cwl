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
  age_clock353: File
  age_sb: File
  age_pheno: File
  probe_coords: File

outputs:
  lvl3betas:
    type: File
    outputSource: rename_lvl3/OUTPUT
  metadata:
    type: File
    outputSource: rename_metadata/OUTPUT
  copynumber_segment:
    type: File
    outputSource: rename_copynumber_segment/OUTPUT
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
  
  sesame_all:
    run: ../../tools/sesame_all.cwl
    in:
      green_idat: sanitize_idats/sanitized_green
      red_idat: sanitize_idats/sanitized_red
      age_clock353: age_clock353
      age_sb: age_sb
      age_pheno: age_pheno
      probe_coords: probe_coords
    out: [green_idat_noid, red_idat_noid, lvl3betas, metadata,copynumber_segment ]

  rename_lvl3:
    run: ../../tools/rename.cwl
    in:
      INPUT: sesame_all/lvl3betas
      OUTNAME:
        source: job_uuid
        valueFrom: $(self).methylation_array.sesame.level3betas.txt
    out: [ OUTPUT ]

  rename_metadata:
    run: ../../tools/rename.cwl
    in:
      INPUT: sesame_all/metadata
      OUTNAME:
        source: job_uuid
        valueFrom: $(self).methylation_array.sesame.metadata.json
    out: [ OUTPUT ]

  rename_copynumber_segment:
    run: ../../tools/rename.cwl
    in:
      INPUT: sesame_all/copynumber_segment
      OUTNAME:
        source: job_uuid
        valueFrom: $(self).methylation_array.sesame.copynumber_segment.tsv
    out: [ OUTPUT ]


  rename_noid_Grn:
    run: ../../tools/rename.cwl
    in:
      INPUT: sesame_all/green_idat_noid
      OUTNAME:
        source: job_uuid
        valueFrom: $(self)_noid_Grn.idat
    out: [ OUTPUT ]

  rename_noid_Red:
    run: ../../tools/rename.cwl
    in:
      INPUT: sesame_all/red_idat_noid
      OUTNAME:
        source: job_uuid
        valueFrom: $(self)_noid_Red.idat
    out: [ OUTPUT ]
