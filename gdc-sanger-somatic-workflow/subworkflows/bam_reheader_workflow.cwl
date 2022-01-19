cwlVersion: v1.0
class: Workflow
id: bam_reheader_wf
requirements:
  - class: InlineJavascriptRequirement
  - class: StepInputExpressionRequirement
  - class: MultipleInputFeatureRequirement
  - class: SubworkflowFeatureRequirement
  - class: ScatterFeatureRequirement

inputs:
  input_bam: File
  input_bam_index: File
  aliquot_uuid: string
  threads: int?

outputs:
  processed_bam: 
    type: File
    outputSource: output_decider/final_bam
  processed_bai: 
    type: File
    outputSource: output_decider/final_bai

steps:
  check_bam:
    run: ../../tools/check_bam_header.cwl
    in:
      bam: input_bam 
      aliquot_id: aliquot_uuid
      output_filename:
        source: aliquot_uuid
        valueFrom: $(self + '.reheader.sam')
    out: [ new_header ]

  run_rename:
    run: ../../tools/rename_file.cwl
    in:
      input_file: input_bam_index
      output_filename:
        source: input_bam
        valueFrom: $(self.basename + '.bai')
    out: [ out_file ]

  run_reheader:
    run: ../../tools/samtools_reheader_and_index.cwl
    scatter: input_header
    in:
      threads: threads
      output_filename:
        source: aliquot_uuid
        valueFrom: $(self + '.reheader.bam')
      input_bam: input_bam
      input_header: check_bam/new_header
    out: [ bam_file, bam_index ]

  output_decider: 
    run: ../../tools/reheader_decider.cwl
    in:
      input_bam_file: input_bam 
      input_bai_file: run_rename/out_file 
      rehead_bam_file: run_reheader/bam_file
      rehead_bai_file: run_reheader/bam_index
    out: [ final_bam, final_bai ] 
