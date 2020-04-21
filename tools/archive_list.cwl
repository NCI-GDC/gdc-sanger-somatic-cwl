class: CommandLineTool
cwlVersion: v1.0
id: archive_list
requirements:
  - class: DockerRequirement
    dockerPull: alpine:latest
  - class: InlineJavascriptRequirement
  - class: InitialWorkDirRequirement
    listing: $(inputs.input_files)
  - class: ResourceRequirement
    coresMin: 1
    ramMin: 1000

inputs:
  input_files:
    type:
      type: array
      items: File
      inputBinding:
        valueFrom: $(self.basename)
    doc: files you want to archive
    inputBinding:
      position: 1

  output_archive_name:
    type: string
    inputBinding:
      prefix: -hczf
      position: 0

outputs:
  output_archive:
    type: File
    outputBinding:
      glob: $(inputs.output_archive_name)
    doc: The archived directory

baseCommand: [tar]
