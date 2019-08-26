cwlVersion: v1.0
class: CommandLineTool

requirements:
  - class: InlineJavascriptRequirement
  - class: DockerRequirement
    dockerPull: quay.io/ncigdc/gdc-sanger-somatic-tool:3630ab95a0f2856754227667fe1a8d3652daeb55
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
  brass_bedpe:
    type: File
    outputBinding:
      glob: $(inputs.output_prefix + '.bedpe.gz')

  brass_bedpe_index:
    type: File
    outputBinding:
      glob: $(inputs.output_prefix + '.bedpe.gz.tbi')

baseCommand: [python, /opt/extract_brass_bedpe.py]
