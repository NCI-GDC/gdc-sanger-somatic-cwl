cwlVersion: v1.0
class: CommandLineTool

requirements:
  - class: InlineJavascriptRequirement
  - class: DockerRequirement
    dockerPull: quay.io/ncigdc/bcftools:1.9 
  - class: ResourceRequirement
    coresMin: 1 
    ramMin: 1000

inputs:
  output_filename:
    type: string
    inputBinding:
      prefix: -o 
      position: 0

  output_type:
    type: string
    default: z
    inputBinding:
      prefix: -O
      position: 1

  input_vcf:
    type: File
    inputBinding:
      position: 2

outputs:
  sorted_vcf:
    type: File
    outputBinding:
      glob: $(inputs.output_filename)

baseCommand: [bcftools, sort]
