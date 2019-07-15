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
  sanger_results_tar: File
  job_uuid: string
  reference:
    type: File
    secondaryFiles: [.fai, ^.dict]
  min_tumor_alt_dp:
    type: int?
    default: 3
    doc: If the tumor alt depth is less than this value filter it
  min_tumor_alt_dp_tag:
    type: string?
    default: TALTDP
    doc: The filter tag to use for the min_tumor_alt_dp filter
  usedecoy:
    type: boolean?
    default: false
    doc: If specified, it will include all the decoy sequences in the faidx.

outputs:
    pindel_vcf:
      type: File
      outputSource: gatk_filter/output_vcf
    pindel_vcf_index:
      type: File
      outputSource: gatk_filter/output_vcf_index

steps:
    prepare_intervals:
      run: ../../tools/faidx_to_bed.cwl
      in:
        ref_fai:
          source: reference
          valueFrom: $(self.secondaryFiles[0])
        usedecoy: usedecoy
      out: [output_bed]

    extract_pindel_vcf:
      run: ../../tools/extract_pindel_vcf.cwl
      in:
        archive: sanger_results_tar
        output_prefix:
          source: job_uuid
          valueFrom: $(self + '.wgs.sanger_raw_pindel')
      out: [ pindel_vcf ]

    select_variants:
      run: ../../tools/gatk3-selectvariants.cwl
      in:
        input_vcf: extract_pindel_vcf/pindel_vcf
        reference: reference
        intervals: prepare_intervals/output_bed
        output_filename:
          source: job_uuid
          valueFrom: $(self + '.wgs.sanger_raw_pindel.selected.raw_somatic_mutation.vcf.gz')
      out: [output_vcf]

    vt_normalization:
      run: ../../tools/vt_norm.cwl
      in:
        input_vcf: select_variants/output_vcf
        reference_fasta: reference
        output_vcf:
          source: job_uuid
          valueFrom: $(self + '.wgs.sanger_raw_pindel.norm.raw_somatic_mutation.vcf')
      out: [output_vcf_file]

    gatk_filter:
      run: ../../tools/gatk3-variant-filtration.cwl
      in:
        input_vcf: vt_normalization/output_vcf_file
        reference: reference
        min_tumor_alt_dp: min_tumor_alt_dp
        min_tumor_alt_dp_tag: min_tumor_alt_dp_tag
        output_filename:
          source: job_uuid
          valueFrom: $(self + '.wgs.sanger_raw_pindel.raw_somatic_mutation.vcf.gz')
      out: [output_vcf, output_vcf_index]
