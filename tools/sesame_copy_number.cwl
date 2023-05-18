cwlVersion: v1.0
class: CommandLineTool
id: sesame_copy_number
requirements:
  - class: DockerRequirement
    dockerPull: quay.io/ncigdc/sesame-tool:3.0.0-172.36646f3
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
  copynumber_segment:
    type: File
    outputBinding:
      glob: '*methylation_array.sesame.seg.tsv'

baseCommand:
  - Rscript
  - /opt/sesame-cnv.R
  - ./
