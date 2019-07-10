cwlVersion: v1.0
class: CommandLineTool

requirements:
  - class: InlineJavascriptRequirement
  - class: DockerRequirement
    dockerPull: quay.io/ncigdc/gdc-sanger-somatic-tool:cee0fad3676727b1bd3e1a7285b20acf29dfcfa8
  - class: ResourceRequirement
    coresMin: 1 
    ramMin: 1000

inputs:
  archive:
    type: File
    inputBinding:
      prefix: --results_archive 

  output_prefix:
    type: string
    inputBinding:
      prefix: --output_prefix 

outputs:
  brass_vcf:
    type: File
    outputBinding:
      glob: $(inputs.output_prefix + '.vcf.gz')
    secondaryFiles:
      - .tbi

baseCommand: [python, /opt/extract_brass_vcf.py]
