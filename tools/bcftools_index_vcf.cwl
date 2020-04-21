cwlVersion: v1.0
class: CommandLineTool
id: bcftools_index_vcf
requirements:
  - class: InlineJavascriptRequirement
  - class: DockerRequirement
    dockerPull: quay.io/ncigdc/bcftools:1.9
  - class: ResourceRequirement
    coresMin: 1
    ramMin: 1000
    coresMax: $(inputs.threads)

inputs:
  threads:
    type: int
    default: 1
    inputBinding:
      prefix: --threads
      position: 0

  output_filename:
    type: string
    inputBinding:
      prefix: -o
      position: 1

  input_vcf:
    type: File
    inputBinding:
      position: 2

outputs:
  vcf_index:
    type: File
    outputBinding:
      glob: $(inputs.output_filename)

baseCommand: [bcftools, index, -t]
