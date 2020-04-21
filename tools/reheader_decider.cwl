cwlVersion: v1.0
class: ExpressionTool
id: reheader_decider

inputs:
  input_bam_file: File
  input_bai_file: File
  rehead_bam_file: File[]
  rehead_bai_file: File[]

outputs:
  final_bam: File
  final_bai: File

expression: |
  ${
     var sel_bam;
     var sel_bai;
     if( inputs.rehead_bam_file.length > 0 ) {
       sel_bam = inputs.rehead_bam_file[0];
       sel_bai = inputs.rehead_bai_file[0];
     } else {
       sel_bam = inputs.input_bam_file;
       sel_bai = inputs.input_bai_file;
     }

     return {'final_bam': sel_bam, 'final_bai': sel_bai}
   }
