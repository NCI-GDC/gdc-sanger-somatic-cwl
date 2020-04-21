cwlVersion: v1.0
class: CommandLineTool
id: sambamba_filter
doc: |
    Filter BAM files for Pindel.

requirements:
  - class: DockerRequirement
    dockerPull: quay.io/ncigdc/sambamba:latest
  - class: InlineJavascriptRequirement

inputs:
  - id: input
    type: File
    inputBinding:
      position: 0

  - id: filter
    type: string
    default: not (unmapped or duplicate or secondary_alignment or failed_quality_control or supplementary)
    inputBinding:
      prefix: --filter

  - id: format
    type: string
    default: bam
    inputBinding:
      prefix: --format

  - id: threads
    type: int
    default: 1
    inputBinding:
      prefix: --nthreads

outputs:
  - id: output
    type: File
    outputBinding:
      glob: $(inputs.input.basename)
    secondaryFiles:
      - .bai

arguments:
  - valueFrom: $(inputs.input.basename)
    prefix: --output-filename

baseCommand: [/bin/sambamba, view]
