cwlVersion: v1.0
class: CommandLineTool

requirements:
  - class: InlineJavascriptRequirement
  - class: DockerRequirement
    dockerPull: quay.io/ncigdc/gdc-sanger-somatic-tool:92e1ea88d4e2e8b97765d113caa93ca33cf01f95 
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
