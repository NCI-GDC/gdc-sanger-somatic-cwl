cwlVersion: v1.0
class: Workflow

requirements:
  - class: InlineJavascriptRequirement
  - class: StepInputExpressionRequirement
  - class: MultipleInputFeatureRequirement
  - class: SubworkflowFeatureRequirement

inputs:
  threads: int?
  job_uuid: string
  tumor_aliquot_uuid: string
  sequence_dict: File
  reference_fai: File
  core_reference_tar: File
  vagrent_cache: File
  snv_indel_tar: File
  cnv_sv_tar: File
  qcset_tar: File
  tumor_bam: File
  tumor_index: File
  normal_bam: File
  normal_index: File
  gdc_reference: File
  min_tumor_alt_dp: int?
  min_tumor_alt_dp_tag: string?
  usedecoy: boolean?

outputs:
  tumor_bas:
    type: File
    outputSource: get_tumor_bas/bas_file
  normal_bas:
    type: File
    outputSource: get_normal_bas/bas_file
  out_run_params:
    type: File
    outputSource: run_sanger_tool/run_params
  out_result_archive:
    type: File
    outputSource: run_sanger_tool/result_archive
  out_timings:
    type: File
    outputSource: run_sanger_tool/timings
  out_global_time:
    type: File
    outputSource: run_sanger_tool/global_time
  brass_vcf_file:
    type: File
    outputSource: run_brass_postprocessing/brass_vcf
  brass_vcf_index_file:
    type: File
    outputSource: run_brass_postprocessing/brass_vcf_index
  brass_bedpe_file:
    type: File
    outputSource: run_brass_postprocessing/brass_bedpe
  brass_bedpe_index_file:
    type: File
    outputSource: run_brass_postprocessing/brass_bedpe_index
  caveman_vcf_file:
    type: File
    outputSource: run_caveman_postprocessing/caveman_vcf
  caveman_vcf_index_file:
    type: File
    outputSource: run_caveman_postprocessing/caveman_vcf_index
  ascat_tumor_ploidy:
    type: float
    outputSource: run_ascat_postprocessing/ascat_tumor_ploidy
  ascat_tumor_purity:
    type: float
    outputSource: run_ascat_postprocessing/ascat_tumor_purity
  ascat_segmentation_file:
    type: float
    outputSource: run_ascat_postprocessing/ascat_segmentation_file
  pindel_vcf:
    type: File
    outputSource: run_pindel_postprocessing/pindel_vcf
  pindel_vcf_index:
    type: File
    outputSource: run_pindel_postprocessing/pindel_vcf_index

steps:
  get_tumor_bas:
    run: ../../tools/generate_bas.cwl
    in:
      bam: tumor_bam
      output_filename:
        source: tumor_bam
        valueFrom: $(self.basename + '.bas')
      threads: threads
      reference_fai: reference_fai
    out: [ bas_file ]

  make_tumor_secondary:
    run: ../../tools/make_secondary.cwl
    in:
      parent_file: tumor_bam
      children:
        source: get_tumor_bas/bas_file
        valueFrom: $([self])
    out: [ output ]

  get_normal_bas:
    run: ../../tools/generate_bas.cwl
    in:
      bam: normal_bam
      output_filename:
        source: normal_bam
        valueFrom: $(self.basename + '.bas')
      threads: threads
      reference_fai: reference_fai
    out: [ bas_file ]

  make_normal_secondary:
    run: ../../tools/make_secondary.cwl
    in:
      parent_file: normal_bam
      children:
        source: get_normal_bas/bas_file
        valueFrom: $([self])
    out: [ output ]

  make_gdc_reference:
    run: ../../tools/make_secondary.cwl
    in:
      parent_file: gdc_reference
      children:
        source: [reference_fai, sequence_dict]
        valueFrom: $(self)
    out: [ output ]

  run_sanger_tool:
    run: ../../tools/cgpwgs.cwl
    in:
      reference: core_reference_tar
      annot: vagrent_cache
      snv_indel: snv_indel_tar
      cnv_sv: cnv_sv_tar
      qcset: qcset_tar
      tumour: make_tumor_secondary/output
      tumourIdx: tumor_index
      normal: make_normal_secondary/output
      normalIdx: normal_index
      exclude:
        default:
          $include: "../../tools/excluded_contigs.txt"
      species:
        default: "human"
      assembly:
        default: "GRCh38"
      pindelcpu: threads
    out: [ run_params, result_archive, timings, global_time ]

  run_brass_postprocessing:
    run: ./brass_postprocess_workflow.cwl
    in:
      threads: threads
      job_uuid: job_uuid
      sequence_dict: sequence_dict
      sanger_results_tar: run_sanger_tool/result_archive
    out: [ brass_vcf, brass_vcf_index, brass_bedpe, brass_bedpe_index ]

  run_caveman_postprocessing:
    run: ./caveman_postprocess_workflow.cwl
    in:
      threads: threads
      job_uuid: job_uuid
      sequence_dict: sequence_dict
      sanger_results_tar: run_sanger_tool/result_archive
    out: [ caveman_vcf, caveman_vcf_index ]

  run_ascat_postprocessing:
    run: ./ascat_postprocess_workflow.cwl
    in:
      job_uuid: job_uuid
      tumor_aliquot_uuid: tumor_aliquot_uuid
      sanger_results_tar: run_sanger_tool/result_archive
    out: [ ascat_tumor_ploidy, ascat_tumor_purity, ascat_segmentation_file ]

  run_pindel_postprocessing:
    run: ./pindel_postprocess_workflow.cwl
    in:
      job_uuid: job_uuid
      sanger_results_tar: run_sanger_tool/result_archive
      reference: make_gdc_reference/output
      min_tumor_alt_dp_tag: min_tumor_alt_dp_tag
      min_tumor_alt_dp: min_tumor_alt_dp
      usedecoy: usedecoy
    out: [ pindel_vcf, pindel_vcf_index ]