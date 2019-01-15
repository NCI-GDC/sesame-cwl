#!/usr/bin/env cwl-runner

cwlVersion: v1.0

class: Workflow

inputs:
  - id: green_idat
    type: File
  - id: red_idat
    type: File

outputs:
  - id: sanitized_green
    type: File
    source: basename_rename_green/OUTPUT
  - id: sanitized_red
    type: File
    source: basename_rename_red/OUTPUT

steps:
  - id: decide_suffix
    run: ../tools/decide_suffix.cwl
    in:
      - id: green_idat
        source: green_idat
      - id: red_idat
        source: red_idat
    out:
      - id: newGrnName
      - id: newRedName

  - id: suffix_rename_green
    run: ../tools/rename.cwl
    in:
      - id: INPUT
        source: green_idat
      - id: OUTNAME
        source: decide_suffix/newGrnName
    out:
      - id: OUTPUT

  - id: suffix_rename_red
    run: ../tools/rename.cwl
    in:
      - id: INPUT
        source: red_idat
      - id: OUTNAME
        source: decide_suffix/newRedName
    out:
      - id: OUTPUT

  - id: decide_basename
    run: ../tools/decide_basename.cwl
    in:
      - id: green_idat
        source: suffix_rename_green/OUTPUT
      - id: red_idat
        source: suffix_rename_red/OUTPUT
    out:
      - id: newGrnName
      - id: newRedName

  - id: basename_rename_green
    run: ../tools/rename.cwl
    in:
      - id: INPUT
        source: suffix_rename_green/OUTPUT
      - id: OUTNAME
        source: decide_basename/newGrnName
    out:
      - id: OUTPUT

  - id: basename_rename_red
    run: ../tools/rename.cwl
    in:
      - id: INPUT
        source: suffix_rename_green/OUTPUT
      - id: OUTNAME
        source: decide_basename/newRedName
    out:
      - id: OUTPUT
