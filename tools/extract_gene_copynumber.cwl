cwlVersion: v1.0
class: CommandLineTool

requirements:
  - class: InlineJavascriptRequirement
  - class: DockerRequirement
    dockerPull: quay.io/ncigdc/seg2gene-tool:63dd5143fb8850ec710ba4fe4cf31854240edbe7 
  - class: ResourceRequirement
    coresMin: 1
    ramMin: 1000

inputs:
  input:
    type: File
    inputBinding:
      prefix: -f

  output_filename:
    type: string
    inputBinding:
      prefix: -o 

outputs:
  gene_cnv:
    type: File
    outputBinding:
      glob: $(inputs.output_filename)

baseCommand: [Rscript, /home/scripts/seg2gene/tool/seg2gene.R, -g, /home/scripts/seg2gene/resource/gencode.v22.gene.tsv]
