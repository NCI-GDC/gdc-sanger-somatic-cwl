cwlVersion: v1.0
class: CommandLineTool

requirements:
  - class: InlineJavascriptRequirement
  - class: DockerRequirement
    dockerPull: quay.io/ncigdc/gdc-sanger-somatic-tool:77c5c39604cf01ea445c3deb83d4b9d91e3cd43e
  - class: ResourceRequirement
    coresMin: 1
    ramMin: 1000

inputs:
  archive:
    type: File
    inputBinding:
      prefix: --input

  output_filename:
    type: string
    inputBinding:
      prefix: --output

  gdcaliquot:
    type: string
    inputBinding:
      prefix: --gdcaliquot

outputs:
  ascat_cnv:
    type: File
    outputBinding:
      glob: $(inputs.output_filename)

baseCommand: [python, /opt/extract_ascat.py, reformat_copynumber]
