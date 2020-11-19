cwlVersion: v1.0
class: CommandLineTool
id: sesame_beta_levels
requirements:
  - class: DockerRequirement
    dockerPull: quay.io/ncigdc/sesame-tool:e003165fe9d482f138a39579eb2d77cb616e0f6c
  - class: InitialWorkDirRequirement
    listing:
      - $(inputs.green_idat)
      - $(inputs.red_idat)
  - class: InlineJavascriptRequirement


  inputs:
    green_idat:
      type: File

    red_idat:
      type: File

  outputs:
    green_idat_noid:
      type: File

    red_idat_noid:
      type: File

  baseCommand:
    - Rscript
    - /home/sesame-scripts/sesame-deidentify.R
    - ./
