cwlVersion: v1.0
class: CommandLineTool
id: sesame_beta_levels
requirements:
  - class: DockerRequirement
    dockerPull: quay.io/ncigdc/sesame-tool:3.0.0-173.1b97d25
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

  age_clock353:
    type: File
    default:
      class: File
      location: ./2add48183921_Clock_Horvath353.rds
    inputBinding:
      position: 5

  age_sb:
    type: File
    default:
      class: File
      location: ./2add2e4eca81_Clock_SkinBlood.rds
    inputBinding:
      position: 7

  age_pheno:
    type: File
    default:
      class: File
      location: ./2add36d0f2e7_Clock_PhenoAge.rds
    inputBinding:
      position: 9

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
