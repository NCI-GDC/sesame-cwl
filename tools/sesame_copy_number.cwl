cwlVersion: v1.0
class: CommandLineTool
id: sesame_copy_number
requirements:
  - class: DockerRequirement
    dockerPull: quay.io/ncigdc/sesame-tool:5e9819261ab78255079356cbff28ce80c9f8b4ec
  - class: InitialWorkDirRequirement
    listing:
      - $(inputs.target_green_idat)
      - $(inputs.target_red_idat)
      - $(inputs.normal_green_idat)
      - $(inputs.normal_red_idat)
  - class: InlineJavascriptRequirement

inputs:
  target_green_idat:
    type: File
    inputBinding:
      position: 0
      valueFrom: '$(self.nameroot.replace("_Grn",""))'

  target_red_idat: File

  normal_green_idat:
    type: File
    inputBinding:
      position: 1
      valueFrom: '$(self.nameroot.replace("_Grn",""))'

  normal_red_idat: File

  gdc_aliquot:
    type: string
    inputBinding:
      position: 2

  job_uuid:
    inputBinding:
      position: 3

outputs:
  copy_number:
    type: File
    outputBinding:
      glob: '*methylation_array.sesame.seg.tsv'

baseCommand:
  - Rscript
  - /home/sesame-scripts/sesame-cnv.R
  - ./
