cwlVersion: v1.0
class: Workflow
id: brass_postprocess_wf
requirements:
  - class: InlineJavascriptRequirement
  - class: StepInputExpressionRequirement
  - class: MultipleInputFeatureRequirement

inputs:
  threads: int?
  job_uuid: string
  sequence_dict: File
  sanger_results_tar: File 

outputs:
  brass_vcf: 
    type: File
    outputSource: sort_vcf/sorted_vcf 
  brass_vcf_index:
    type: File
    outputSource: index_vcf/vcf_index
  brass_bedpe:
    type: File
    outputSource: extract_brass_bedpe/brass_bedpe
  brass_bedpe_index:
    type: File
    outputSource: extract_brass_bedpe/brass_bedpe_index

steps:
  extract_brass_bedpe:
    run: ../../tools/extract_brass_bedpe.cwl
    in:
      archive: sanger_results_tar
      output_prefix:
        source: job_uuid
        valueFrom: $(self + '.wgs.BRASS.raw_structural_variation')
    out: [ brass_bedpe, brass_bedpe_index ]

  extract_brass_vcf:
    run: ../../tools/extract_brass_vcf.cwl
    in:
      archive: sanger_results_tar
      output_prefix:
        source: job_uuid
        valueFrom: $(self + '.BRASS')
    out: [ brass_vcf ]

  update_dict:
    run: ../../tools/picard_update_sequence_dictionary.cwl
    in:
      input_vcf: extract_brass_vcf/brass_vcf
      sequence_dictionary: sequence_dict
      output_filename:
        source: job_uuid
        valueFrom: $(self + '.BRASS.seqdict.vcf')
    out: [ output_file ]

  sort_vcf:
    run: ../../tools/bcftools_sort_vcf.cwl
    in:
      output_filename:
        source: job_uuid
        valueFrom: $(self + '.wgs.BRASS.raw_structural_variation.vcf.gz')
      input_vcf: update_dict/output_file
    out: [ sorted_vcf ]

  index_vcf:
    run: ../../tools/bcftools_index_vcf.cwl
    in:
      threads: threads
      input_vcf: sort_vcf/sorted_vcf
      output_filename:
        source: job_uuid
        valueFrom: $(self + '.wgs.BRASS.raw_structural_variation.vcf.gz.tbi')
    out: [ vcf_index ]
