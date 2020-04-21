cwlVersion: v1.0
class: CommandLineTool
id: extract_ascat_copynumber
requirements:
  - class: InlineJavascriptRequirement
  - class: DockerRequirement
    dockerPull: quay.io/ncigdc/gdc-sanger-somatic-tool:a89360b5734091928943ebce7044d4ee75c64e91
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
