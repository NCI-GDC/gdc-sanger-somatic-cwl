cwlVersion: v1.0
class: Workflow

requirements:
  - class: InlineJavascriptRequirement
  - class: StepInputExpressionRequirement
  - class: MultipleInputFeatureRequirement

inputs:
  job_uuid: string
  tumor_aliquot_uuid: string
  sanger_results_tar: File 

outputs:
  ascat_tumor_ploidy: 
    type: float 
    outputSource: extract_stats/ploidy 
  ascat_tumor_purity: 
    type: float 
    outputSource: extract_stats/tumor_purity 
  ascat_segmentation_file:
    type: File
    outputSource: extract_segments/ascat_cnv 
  ascat_genelevel_file:
    type: File
    outputSource: extract_genelevel/gene_cnv

steps:
  extract_stats:
    run: ../../tools/extract_ascat_stats.cwl
    in:
      archive: sanger_results_tar
    out: [ tumor_purity, ploidy ] 

  extract_segments: 
    run: ../../tools/extract_ascat_copynumber.cwl
    in:
      archive: sanger_results_tar 
      output_filename:
        source: job_uuid
        valueFrom: $(self + '.wgs.ASCAT.copy_number_variation.seg.txt')
      gdcaliquot: tumor_aliquot_uuid
    out: [ ascat_cnv ] 

  extract_genelevel:
    run: ../../tools/extract_gene_copynumber.cwl
    in:
      input: extract_segments/ascat_cnv
      output_filename:
        source: job_uuid
        valueFrom: $(self + '.wgs.ASCAT.gene_level.copy_number_variation.tsv')
    out: [ gene_cnv ] 
