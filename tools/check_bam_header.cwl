cwlVersion: v1.0
class: CommandLineTool
id: check_bam_header
requirements:
  - class: InlineJavascriptRequirement
  - class: DockerRequirement
    dockerPull: quay.io/ncigdc/gdc-sanger-somatic-tool:a89360b5734091928943ebce7044d4ee75c64e91
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

baseCommand: [python, /opt/check_bam_header_samples.py]
