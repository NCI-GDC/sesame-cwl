cwlVersion: v1.0
class: Workflow
id: sanitize_idats_workflow
requirements:
  - class: MultipleInputFeatureRequirement

inputs:
  green_idat: File
  red_idat: File

outputs:
  sanitized_green:
    type: File
    outputSource: basename_rename_green/OUTPUT
  sanitized_red:
    type: File
    outputSource: basename_rename_red/OUTPUT

steps:
  decide_suffix:
    run: ../../tools/decide_suffix.cwl
    in:
      green_idat: green_idat
      red_idat: red_idat
    out: [ newGrnName, newRedName ]

  suffix_rename_green:
    run: ../../tools/rename.cwl
    in:
      INPUT: green_idat
      OUTNAME: decide_suffix/newGrnName
    out: [ OUTPUT ]

  suffix_rename_red:
    run: ../../tools/rename.cwl
    in:
      INPUT: red_idat
      OUTNAME: decide_suffix/newRedName
    out: [ OUTPUT ]

  decide_basename:
    run: ../../tools/decide_basename.cwl
    in:
      green_idat: suffix_rename_green/OUTPUT
      red_idat: suffix_rename_red/OUTPUT
    out: [ newGrnName, newRedName ]

  basename_rename_green:
    run: ../../tools/rename.cwl
    in:
      INPUT: suffix_rename_green/OUTPUT
      OUTNAME: decide_basename/newGrnName
    out: [ OUTPUT ]

  basename_rename_red:
    run: ../../tools/rename.cwl
    in:
      INPUT: suffix_rename_red/OUTPUT
      OUTNAME: decide_basename/newRedName
    out: [ OUTPUT ]
