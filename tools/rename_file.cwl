cwlVersion: v1.0
class: CommandLineTool
id: rename_file
doc: |
    Renames the file
requirements:
  - class: InlineJavascriptRequirement
  - class: DockerRequirement
    dockerPull: quay.io/ncigdc/bio-alpine:base
  - class: ResourceRequirement
    coresMin: 1
    ramMin: 1000
    tmpdirMin: $(Math.ceil (inputs.input_file.size / 1048576))
    outdirMin: $(Math.ceil (inputs.input_file.size / 1048576))
  - class: InitialWorkDirRequirement
    listing: |
      ${
        var ret_list = [
          {"entry": inputs.input_file, "writable": false, "entryname": inputs.output_filename},
        ];
        return ret_list
      }

inputs:
  input_file:
    type: File
    doc: The file to rename

  output_filename:
    type: string
    doc: the updated name of the output file

outputs:
  out_file:
    type: File
    outputBinding:
      glob: $(inputs.output_filename)

baseCommand: 'true'
