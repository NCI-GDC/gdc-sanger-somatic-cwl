cwlVersion: v1.0
class: CommandLineTool
id: extract_brass_bedpe
requirements:
  - class: InlineJavascriptRequirement
  - class: DockerRequirement
    dockerPull: quay.io/ncigdc/gdc-sanger-somatic-tool:d22a66e892219d235d2d5269aa1274c81be9c569
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
