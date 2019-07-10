cwlVersion: v1.0
class: Workflow

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
  caveman_vcf: 
    type: File
    outputSource: sort_vcf/sorted_vcf 
  caveman_vcf_index:
    type: File
    outputSource: index_vcf/vcf_index

steps:
  extract_caveman_vcf:
    run: ../../tools/extract_caveman_vcf.cwl
    in:
      archive: sanger_results_tar
      output_prefix:
        source: job_uuid
        valueFrom: $(self + '.CaVEMan')
    out: [ caveman_vcf ]

  update_dict:
    run: ../../tools/picard_update_sequence_dictionary.cwl
    in:
      input_vcf: extract_caveman_vcf/caveman_vcf
      sequence_dictionary: sequence_dict
      output_filename:
        source: job_uuid
        valueFrom: $(self + '.CaVEMan.seqdict.vcf')
    out: [ output_file ]

  sort_vcf:
    run: ../../tools/bcftools_sort_vcf.cwl
    in:
      output_filename:
        source: job_uuid
        valueFrom: $(self + '.wgs.CaVEMan.raw_somatic_mutation.vcf.gz')
      input_vcf: update_dict/output_file
    out: [ sorted_vcf ]

  index_vcf:
    run: ../../tools/bcftools_index_vcf.cwl
    in:
      threads: threads
      input_vcf: sort_vcf/sorted_vcf
      output_filename:
        source: job_uuid
        valueFrom: $(self + '.wgs.CaVEMan.raw_somatic_mutation.vcf.gz.tbi')
    out: [ vcf_index ]
