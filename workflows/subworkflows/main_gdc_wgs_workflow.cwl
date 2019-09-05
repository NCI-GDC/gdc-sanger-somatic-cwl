cwlVersion: v1.0
class: Workflow

requirements:
  - class: InlineJavascriptRequirement
  - class: StepInputExpressionRequirement
  - class: MultipleInputFeatureRequirement
  - class: SubworkflowFeatureRequirement

inputs:
  sanger_threads: int?
  other_threads: int?
  job_uuid: string
  tumor_aliquot_uuid: string
  normal_aliquot_uuid: string
  gdc_reference: File
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
  min_tumor_alt_dp: int?
  min_tumor_alt_dp_tag: string?
  usedecoy: boolean?

outputs:
  wf_archive_file:
    type: File
    outputSource: run_archive_data/output_archive
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
    type: File 
    outputSource: run_ascat_postprocessing/ascat_segmentation_file
  ascat_genelevel_file:
    type: File 
    outputSource: run_ascat_postprocessing/ascat_genelevel_file
  pindel_vcf:
    type: File
    outputSource: run_pindel_postprocessing/pindel_vcf
  pindel_vcf_index:
    type: File
    outputSource: run_pindel_postprocessing/pindel_vcf_index

steps:
  reheader_tumor:
    run: ./bam_reheader_workflow.cwl
    in:
      input_bam: tumor_bam
      input_bam_index: tumor_index
      aliquot_uuid: tumor_aliquot_uuid
      threads: other_threads
    out: [ processed_bam, processed_bai ]
 
  get_tumor_bas:
    run: ../../tools/generate_bas.cwl
    in:
      bam: reheader_tumor/processed_bam 
      output_filename:
        source: reheader_tumor/processed_bam
        valueFrom: $(self.basename + '.bas')
      threads: other_threads
      reference_fai: reference_fai
    out: [ bas_file ]

  make_tumor_secondary:
    run: ../../tools/make_secondary.cwl
    in:
      parent_file: reheader_tumor/processed_bam 
      children:
        source: get_tumor_bas/bas_file
        valueFrom: $([self])
    out: [ output ]

  reheader_normal:
    run: ./bam_reheader_workflow.cwl
    in:
      input_bam: normal_bam
      input_bam_index: normal_index
      aliquot_uuid: normal_aliquot_uuid
      threads: other_threads
    out: [ processed_bam, processed_bai ]

  get_normal_bas:
    run: ../../tools/generate_bas.cwl
    in:
      bam: reheader_normal/processed_bam 
      output_filename:
        source: reheader_normal/processed_bam 
        valueFrom: $(self.basename + '.bas')
      threads: other_threads
      reference_fai: reference_fai
    out: [ bas_file ]

  make_normal_secondary:
    run: ../../tools/make_secondary.cwl
    in:
      parent_file: reheader_normal/processed_bam 
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
      max_threads: sanger_threads
      reference: core_reference_tar
      annot: vagrent_cache
      snv_indel: snv_indel_tar
      cnv_sv: cnv_sv_tar
      qcset: qcset_tar
      tumour: make_tumor_secondary/output
      tumourIdx: reheader_tumor/processed_bai 
      normal: make_normal_secondary/output
      normalIdx: reheader_normal/processed_bai
      exclude:
        default:
          $include: "../../tools/excluded_contigs.txt"
        valueFrom: $(self.replace(/(\r\n|\n|\r)/gm, ""))
      species:
        default: "human"
      assembly:
        default: "GRCh38"
      pindelcpu: other_threads
    out: [ run_params, result_archive, timings, global_time ]

  run_brass_postprocessing:
    run: ./brass_postprocess_workflow.cwl
    in:
      threads: other_threads
      job_uuid: job_uuid
      sequence_dict: sequence_dict
      sanger_results_tar: run_sanger_tool/result_archive
    out: [ brass_vcf, brass_vcf_index, brass_bedpe, brass_bedpe_index ]

  run_caveman_postprocessing:
    run: ./caveman_postprocess_workflow.cwl
    in:
      threads: other_threads
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
    out: [ ascat_tumor_ploidy, ascat_tumor_purity, ascat_segmentation_file, ascat_genelevel_file ]

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

  run_archive_data:
    run: ../../tools/archive_list.cwl
    in:
      input_files:
        source:
          - get_tumor_bas/bas_file 
          - get_normal_bas/bas_file
          - run_sanger_tool/run_params 
          - run_sanger_tool/result_archive
          - run_sanger_tool/timings
          - run_sanger_tool/global_time
        valueFrom: $(self)
      output_archive_name:
        source: job_uuid
        valueFrom: $(self + '.wgs_sanger_archive.tar.gz')
    out: [ output_archive ]
