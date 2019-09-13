#!/usr/bin/env cwl-runner

cwlVersion: v1.0
doc: |
  Normalize and filter Pindel vcf.

class: Workflow

requirements:
  - class: InlineJavascriptRequirement
  - class: StepInputExpressionRequirement
  - class: SubworkflowFeatureRequirement
  - class: MultipleInputFeatureRequirement

inputs:
  threads: int
  sanger_results_tar: File
  job_uuid: string
  reference:
    type: File
    secondaryFiles: [.fai, ^.dict]

outputs:
    pindel_vcf:
      type: File
      outputSource: sort_vcf/sorted_vcf
    pindel_vcf_index:
      type: File
      outputSource: index_vcf/vcf_index

steps:
    extract_pindel_vcf:
      run: ../../tools/extract_pindel_vcf.cwl
      in:
        archive: sanger_results_tar
        output_prefix:
          source: job_uuid
          valueFrom: $(self + '.wgs.sanger_raw_pindel')
      out: [ pindel_vcf ]

    remove_nonstandard:
      run: ../../tools/remove_nonstandard_variants.cwl
      in:
        input_vcf: extract_pindel_vcf/pindel_vcf
        output_filename:
          source: job_uuid
          valueFrom: $(self + '.wgs.sanger_raw_pindel.standard.raw_somatic_mutation.vcf.gz')
      out: [output_vcf]

    vt_normalization:
      run: ../../tools/vt_norm.cwl
      in:
        input_vcf: remove_nonstandard/output_vcf
        reference_fasta: reference
        output_vcf:
          source: job_uuid
          valueFrom: $(self + '.wgs.sanger_raw_pindel.norm.raw_somatic_mutation.vcf')
      out: [output_vcf_file]

    update_seqdict:
      run: ../../tools/picard_update_sequence_dictionary.cwl
      in:
        input_vcf: vt_normalization/output_vcf_file
        sequence_dictionary:
          source: reference
          valueFrom: $(self.secondaryFiles[1])
        output_filename:
          source: job_uuid
          valueFrom: $(self + '.wgs.sanger_raw_pindel.seqdict.raw_somatic_mutation.vcf')
      out: [output_file]

    sort_vcf:
      run: ../../tools/bcftools_sort_vcf.cwl
      in:
        input_vcf: update_seqdict/output_file
        output_filename:
          source: job_uuid
          valueFrom: $(self + '.wgs.sanger_raw_pindel.raw_somatic_mutation.vcf.gz')
      out: [sorted_vcf]

    index_vcf:
      run: ../../tools/bcftools_index_vcf.cwl
      in:
        threads: threads
        input_vcf: sort_vcf/sorted_vcf
        output_filename:
          source: job_uuid
          valueFrom: $(self + '.wgs.sanger_raw_pindel.raw_somatic_mutation.vcf.gz.tbi')
      out: [vcf_index]
