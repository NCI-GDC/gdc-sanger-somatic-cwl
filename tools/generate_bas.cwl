cwlVersion: v1.0
class: CommandLineTool
id: generate_bas
requirements:
  - class: InlineJavascriptRequirement
  - class: DockerRequirement
    dockerPull: quay.io/wtsicgp/dockstore-cgpwgs:2.1.0
  - class: ResourceRequirement
    coresMin: $(inputs.threads)
    ramMin: 1000

inputs:
  bam:
    type: File
    inputBinding:
      prefix: -i

  output_filename:
    type: string
    inputBinding:
      prefix: -o

  reference_fai:
    type: File?
    inputBinding:
      prefix: -r

  threads:
    type: int?
    inputBinding:
      prefix: -@

outputs:
  bas_file:
    type: File
    outputBinding:
      glob: $(inputs.output_filename)

baseCommand: ["/opt/wtsi-cgp/bin/bam_stats"]
