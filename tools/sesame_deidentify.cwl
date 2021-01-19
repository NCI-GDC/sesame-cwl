cwlVersion: v1.0
class: CommandLineTool
id: sesame_deidentify
requirements:
  - class: DockerRequirement
    dockerPull: quay.io/ncigdc/sesame-tool:bc7e00931b6db78ba5596952fab7012db5d08d47
  - class: InitialWorkDirRequirement
    listing:
      - $(inputs.green_idat)
      - $(inputs.red_idat)
  - class: InlineJavascriptRequirement


inputs:
  green_idat:
    type: File
    inputBinding:
      position: 0


  red_idat:
    type: File
    inputBinding:
      position: 2

outputs:
  green_idat_noid:
    type: File
    outputBinding:
      glob: 'test_noid_Grn.idat'

  red_idat_noid:
    type: File
    outputBinding:
      glob: 'test_noid_Red.idat'

baseCommand:
  - Rscript
  - /home/sesame-scripts/sesame-deidentify.R
