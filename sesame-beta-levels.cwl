class: CommandLineTool
cwlVersion: v1.0
$namespaces:
  sbg: 'https://www.sevenbridges.com'
id: sesame_beta_levels
baseCommand:
  - Rscript
  - /home/sesame-scripts/sesame-lvl3betas.R
  - ./
inputs:
  - id: green_idat
    type: File
    inputBinding:
      position: 0
      valueFrom: '$(self.nameroot.replace("_Grn",""))'
  - id: red_idat
    type: File
outputs:
  - id: lvl3betas
    type: File
    outputBinding:
      glob: '*-level3betas-gdcrerun.txt'
  - id: metadata
    type: File
    outputBinding:
      glob: '*.json'
label: sesame-beta-levels
requirements:
  - class: DockerRequirement
    dockerPull: 'quay.io/dmiller15/sesame-docker:feat_sesameData1.1.1'
  - class: InitialWorkDirRequirement
    listing:
      - $(inputs.green_idat)
      - $(inputs.red_idat)
  - class: InlineJavascriptRequirement
