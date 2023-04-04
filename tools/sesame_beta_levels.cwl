cwlVersion: v1.0
class: CommandLineTool
id: sesame_beta_levels
requirements:
  - class: DockerRequirement
    dockerPull: quay.io/ncigdc/sesame-tool:3.0.0-145.59a55f7
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
      valueFrom: '$(self.nameroot.replace("_Grn",""))'

  red_idat: File

outputs:
  lvl3betas:
    type: File
    outputBinding:
      glob: '*-level3betas-gdc.txt'

  metadata:
    type: File
    outputBinding:
      glob: '*.json'

baseCommand:
  - Rscript
  - /opt/sesame-lvl3betas.R
  - ./
