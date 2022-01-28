class: CommandLineTool
cwlVersion: v1.0
id: remove_nonstandard_variants
doc: |
    Filters (REMOVES!) rows from VCF with non-standard alleles
requirements:
  - class: DockerRequirement
    dockerPull: quay.io/ncigdc/gdc-sanger-somatic-tool:d22a66e892219d235d2d5269aa1274c81be9c569
  - class: InlineJavascriptRequirement

inputs:
  input_vcf:
    type: File
    doc: input vcf file
    inputBinding:
      prefix: --input_vcf
      position: 0

  output_filename:
    type: string
    doc: output basename of output file
    inputBinding:
        prefix: --output_filename
        position: 1

outputs:
  output_vcf:
    type: File
    outputBinding:
      glob: $(inputs.output_filename)
    doc: Filtered VCF file
    secondaryFiles: [.tbi]

baseCommand: [python, /opt/remove_nonstandard_variants.py]
