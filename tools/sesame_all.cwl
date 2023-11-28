cwlVersion: v1.0
class: CommandLineTool
id: sesame_deidentify
requirements:
  - class: DockerRequirement
    dockerPull: quay.io/ncigdc/sesame-tool:aab45598f4238696d5ba2cc914b3993c6dc670aa
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
      
  age_clock353:
    type: File
    inputBinding:
      position: 3

  age_sb:
    type: File
    inputBinding:
      position: 4

  age_pheno:
    type: File
    inputBinding:
      position: 5
      
  probe_coords:
    type: File
    inputBinding:
        position: 6

  ev2_probe_coords:
    type: File
    inputBinding:
        position: 7

outputs:
  green_idat_noid:
    type: File
    outputBinding:
      glob: 'test_noid_Grn.idat'

  red_idat_noid:
    type: File
    outputBinding:
      glob: 'test_noid_Red.idat'
      
  lvl3betas:
    type: File
    outputBinding:
      glob: '*-level3betas-gdc.txt'

  metadata:
    type: File
    outputBinding:
      glob: '*.json'

  copynumber_segment:
    type: File
    outputBinding:
      glob: '*.methylation_array.sesame_seg.tsv'
      
baseCommand:
  - Rscript
  - /opt/sesame-all.R
