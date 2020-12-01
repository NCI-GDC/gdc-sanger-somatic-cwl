cwlVersion: v1.0
class: CommandLineTool
id: check_bam_header
requirements:
  - class: InlineJavascriptRequirement
  - class: DockerRequirement
    dockerPull: quay.io/ncigdc/gdc-sanger-somatic-tool:d22a66e892219d235d2d5269aa1274c81be9c569
  - class: ResourceRequirement
    coresMin: 1
    ramMin: 1000

inputs:
  bam:
    type: File
    inputBinding:
      prefix: --input_bam

  aliquot_id:
    type: string 
    inputBinding:
      prefix: --aliquot_id

  output_filename:
    type: string
    inputBinding:
      prefix: --output_header

outputs:
  new_header: 
    type: File[]
    outputBinding:
      glob: $(inputs.output_filename + '*')
      outputEval: |
        ${
           return self 
         }

baseCommand: [python, /opt/check_bam_header.py]
