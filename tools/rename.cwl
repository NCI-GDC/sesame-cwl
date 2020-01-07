cwlVersion: v1.0
class: CommandLineTool
id: rename_file
requirements:
  - class: DockerRequirement
    dockerPull: ubuntu:bionic-20180426
  - class: InitialWorkDirRequirement
    listing:
      - entryname: $(inputs.OUTNAME)
        entry: $(inputs.INPUT)
  - class: InlineJavascriptRequirement

inputs:
  INPUT: File

  OUTNAME: string

outputs:
  OUTPUT:
    type: File
    outputBinding:
      glob: $(inputs.OUTNAME)

baseCommand: [/bin/true]
