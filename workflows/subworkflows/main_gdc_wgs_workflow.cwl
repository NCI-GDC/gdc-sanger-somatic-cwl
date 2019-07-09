cwlVersion: v1.0
class: Workflow

requirements:
  - class: InlineJavascriptRequirement
  - class: SubworkflowFeatureRequirement

inputs:
  threads: int?
  job_uuid: string
  core_reference_tar: File
  vagrent_cache: File
  snv_indel_tar: File
  cnv_sv_tar: File
  qcset_tar: File
  tumor_bam: File
  tumor_index: File
  normal_bam: File
  normal_index: File

outputs:

steps:
  get_tumor_bas:
    run: ../../tools/generate_bas.cwl
    in:
      bam: tumor_bam 
      output_filename:
        source: tumor_bam
        valueFrom: $(self.basename + '.bas') 
      threads: threads
      reference_fai: fai
        
