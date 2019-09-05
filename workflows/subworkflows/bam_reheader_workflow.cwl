cwlVersion: v1.0
class: Workflow

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
    run:
      class: ExpressionTool
      inputs:
        input_bam: File
        input_bai: File
        rehead_bam: File[] 
        rehead_bai: File[] 
      outputs:
        final_bam: File
        final_bai: File
      expression: |
        ${
           var sel_bam;
           var sel_bai;
           if( inputs.rehead_bam.length > 0 ) {
             sel_bam = inputs.rehead_bam[0]; 
             sel_bai = inputs.rehead_bai[0]; 
           } else {
             sel_bam = inputs.input_bam;
             sel_bai = inputs.input_bai;
           }

           return {'final_bam': sel_bam, 'final_bai': sel_bai}
         }
    in:
      input_bam: input_bam 
      input_bai: input_bam_index
      rehead_bam: run_reheader/bam_file
      rehead_bai: run_reheader/bam_index
    out: [ final_bam, final_bai ] 
