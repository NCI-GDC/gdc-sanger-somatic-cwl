cwlVersion: v1.0
class: CommandLineTool

requirements:
  - class: InlineJavascriptRequirement
  - class: DockerRequirement
    dockerPull: quay.io/ncigdc/gdc-sanger-somatic-tool:77c5c39604cf01ea445c3deb83d4b9d91e3cd43e
  - class: ResourceRequirement
    coresMin: 1
    ramMin: 1000

inputs:
  archive:
    type: File
    inputBinding:
      prefix: --input

outputs:
  tumor_purity:
    type: float
    outputBinding:
      glob: ascat_stats.json
      loadContents: true
      outputEval: |
        ${
           var data = JSON.parse(self[0].contents)["tumor_purity"];
           return data;
         }

  ploidy:
    type: float
    outputBinding:
      glob: ascat_stats.json
      loadContents: true
      outputEval: |
        ${
           var data = JSON.parse(self[0].contents)["ploidy"];
           return data;
         }

stdout: ascat_stats.json

baseCommand: [python, /opt/extract_ascat.py, extract_stats]
