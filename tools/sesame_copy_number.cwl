cwlVersion: v1.0
class: CommandLineTool
id: sesame_copy_number
requirements:
  - class: DockerRequirement
    dockerPull: quay.io/ncigdc/sesame-tool:3.0.0-214.61fcd28
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

  probe_coords:
    type: File
    inputBinding:
        position: 1

outputs:
  copynumber_segment:
    type: File
    outputBinding:
      glob: '*.methylation_array.sesame_seg.tsv'

baseCommand:
  - Rscript
  - /opt/sesame-cnv.R
  - ./
