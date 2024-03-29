class: CommandLineTool
cwlVersion: v1.0
id: picard_update_sequence_dictionary
requirements:
  - class: DockerRequirement
    dockerPull: quay.io/ncigdc/picard:2.26.10 
  - class: InlineJavascriptRequirement

inputs:
  input_vcf:
    type: File
    doc: "input vcf file"
    inputBinding:
      prefix: INPUT=
      separate: false

  sequence_dictionary:
    type: File
    doc: sequence dictionary you want to update header with 
    inputBinding:
      prefix: SD= 
      separate: false

  output_filename:
    type: string
    doc: output basename of output file
    inputBinding:
      prefix: OUTPUT=
      separate: false

outputs:
  output_file:
    type: File
    outputBinding:
      glob: $(inputs.output_filename)
    doc: Updated VCF file 

baseCommand: [java, -Xmx4G, -jar, /usr/local/bin/picard.jar, UpdateVcfSequenceDictionary]
