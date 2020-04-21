cwlVersion: v1.0
class: CommandLineTool
id: gatk3-variant-filtration
requirements:
  - class: ShellCommandRequirement
  - class: InlineJavascriptRequirement
  - class: DockerRequirement
    dockerPull: quay.io/ncigdc/gatk3:3.6

inputs:
  input_vcf:
    type: File
    doc: Input PINDEL somatic VCF
    inputBinding:
      prefix: --variant
      position: 0

  reference:
    type: File
    doc: Reference fasta and incides
    inputBinding:
      prefix: -R
      position: 1
    secondaryFiles: [.fai, ^.dict]

  min_tumor_alt_dp:
    type: int?
    default: 3
    doc: If the tumor alt depth is less than this value filter it
    inputBinding:
      prefix: --filterExpression
      valueFrom: $("'vc.isBiallelic() && vc.getGenotype(\"TUMOR\").getAD().1 < " + self + "'")
      position: 2
      shellQuote: false

  min_tumor_alt_dp_tag:
    type: string?
    default: TALTDP
    doc: The filter tag to use for the min_tumor_alt_dp filter
    inputBinding:
      prefix: --filterName
      position: 3

  output_filename:
    type: string
    doc: The name of out the output filtered VCF (automatically tabix-index if ends with gz)
    inputBinding:
      prefix: -o
      position: 4

outputs:
  output_vcf:
    type: File
    doc: The filtered VCF file
    outputBinding:
      glob: $(inputs.output_filename)

  output_vcf_index:
    type: File
    doc: The index of filtered VCF file
    outputBinding:
      glob: $(inputs.output_filename + '.tbi')

baseCommand: [java, -Xmx8G, -jar, /bin/GenomeAnalysisTK.jar, -T, VariantFiltration, --disable_auto_index_creation_and_locking_when_reading_rods]
