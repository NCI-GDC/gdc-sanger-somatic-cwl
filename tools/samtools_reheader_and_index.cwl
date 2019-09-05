cwlVersion: v1.0
class: CommandLineTool

requirements:
  - class: InlineJavascriptRequirement
  - class: DockerRequirement
    dockerPull: quay.io/ncigdc/samtools:147bd4cc606a63c7435907d97fea6e94e9ea9ed58c18f390cab8bc40b1992df7 
  - class: ShellCommandRequirement
  - class: ResourceRequirement
    coresMin: 1
    ramMin: 1000
    coresMax: $(inputs.threads)

inputs:
  threads:
    type: int?
    default: 1
  
  output_filename:
    type: string

  input_bam:
    type: File

  input_header:
    type: File

outputs:
  bam_file: 
    type: File
    outputBinding:
      glob: $(inputs.output_filename)
  bam_index: 
    type: File
    outputBinding:
      glob: $(inputs.output_filename + '.bai')

baseCommand: []

arguments:
  - position: 0
    shellQuote: false
    valueFrom: >-
      samtools reheader $(inputs.input_header.path) 
      $(inputs.input_bam.path) > $(inputs.output_filename) &&
      samtools index -@ $(inputs.threads) $(inputs.output_filename) 
