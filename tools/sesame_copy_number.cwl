#!/usr/bin/env cwl-runner

cwlVersion: v1.0

class: CommandLineTool

requirements:
  - class: DockerRequirement
    dockerPull: 'quay.io/ncigdc/sesame-tool:17d651dacad038396b9b4b54d606a2e1e0e2e908'
  - class: InitialWorkDirRequirement
    listing:
      - $(inputs.target_green_idat)
      - $(inputs.target_red_idat)
      - $(inputs.normal_green_idat)
      - $(inputs.normal_red_idat)
  - class: InlineJavascriptRequirement

inputs:
  - id: target_green_idat
    type: File
    inputBinding:
      position: 0
      valueFrom: '$(self.nameroot.replace("_Grn",""))'

  - id: target_red_idat
    type: File

  - id: normal_green_idat
    type: File
    inputBinding:
      position: 1
      valueFrom: '$(self.nameroot.replace("_Grn",""))'

  - id: normal_red_idat
    type: File

  - id: gdc_aliquot
    type: string
    inputBinding:
      position: 2

  - id: workflow_uuid
    inputBinding:
      position: 3 

outputs:
  - id: copy_number 
    type: File
    outputBinding:
      glob: '*methylation_array.sesame.seg.tsv'

baseCommand:
  - Rscript
  - /home/sesame-scripts/sesame-cnv.R
  - ./
