cwlVersion: v1.0
class: CommandLineTool
id: make_secondary
requirements:
  - class: DockerRequirement
    dockerPull: quay.io/ncigdc/bio-alpine:base
  - class: InlineJavascriptRequirement
  - class: InitialWorkDirRequirement
    listing: |
      ${
           var ret = [{"entryname": inputs.parent_file.basename, "entry": inputs.parent_file}];
           for( var i = 0; i < inputs.children.length; i++ ) {
               ret.push({"entryname": inputs.children[i].basename, "entry": inputs.children[i]});
           };
           return ret
       }

inputs:
  parent_file:
    type: File

  children:
    type: File[]

outputs:
  output:
    type: File
    outputBinding:
      glob: $(inputs.parent_file.basename)
    secondaryFiles: |
      ${
         var ret = [];
         var locbase = self.location.substr(0, self.location.lastIndexOf('/'))
         for( var i = 0; i < inputs.children.length; i++ ) {
           ret.push({"class": "File", "location": locbase + '/' + inputs.children[i].basename});
         }
         return ret
       }

baseCommand: "true"

