cwlVersion: v1.0
class: Workflow
id: gdc_sanger_wgs_somatic_gpas_wf
requirements:
  - class: InlineJavascriptRequirement
  - class: SubworkflowFeatureRequirement

inputs:
  bioclient_config: File
  upload_bucket: string
  sanger_threads:
    type: int?
    default: 24
  other_threads:
    type: int?
    default: 8 
  job_uuid: string
  tumor_aliquot_uuid: string
  normal_aliquot_uuid: string
  gdc_reference_fasta_uuid: string
  gdc_reference_fai_uuid: string
  gdc_sequence_dict_uuid: string
  gdc_core_reference_tar_uuid: string
  vagrent_cache_tar_uuid: string
  snv_indel_tar_uuid: string
  cnv_sv_tar_uuid: string
  qcset_tar_uuid: string
  tumor_bam_uuid: string
  tumor_index_uuid: string
  normal_bam_uuid: string
  normal_index_uuid: string

outputs:
  sanger_output_archive_uuid:
    type: string
    outputSource: upload_results/wf_archive_uuid
  pindel_vcf_uuid:
    type: string
    outputSource: upload_results/pindel_vcf_uuid
  pindel_vcf_index_uuid:
    type: string
    outputSource: upload_results/pindel_vcf_index_uuid
  caveman_vcf_uuid:
    type: string
    outputSource: upload_results/caveman_vcf_uuid
  caveman_vcf_index_uuid:
    type: string
    outputSource: upload_results/caveman_vcf_index_uuid
  brass_vcf_uuid:
    type: string
    outputSource: upload_results/brass_vcf_uuid
  brass_vcf_index_uuid:
    type: string
    outputSource: upload_results/brass_vcf_index_uuid
  brass_bedpe_uuid:
    type: string
    outputSource: upload_results/brass_bedpe_uuid
  ascat_segmentation_uuid: 
    type: string
    outputSource: upload_results/ascat_segmentation_uuid
  ascat_gene_level_cnv_uuid: 
    type: string
    outputSource: upload_results/ascat_genelevel_uuid
  ascat_purity_estimation:
    type: float
    outputSource: run_main_workflow/ascat_tumor_purity
  ascat_ploidy_estimation:
    type: float
    outputSource: run_main_workflow/ascat_tumor_ploidy

steps:
  stage_inputs:
    run: ./subworkflows/stage_inputs_workflow.cwl
    in:
      bioclient_config: bioclient_config
      gdc_reference_fasta_uuid: gdc_reference_fasta_uuid
      gdc_reference_fai_uuid: gdc_reference_fai_uuid
      gdc_sequence_dict_uuid: gdc_sequence_dict_uuid
      gdc_core_reference_tar_uuid: gdc_core_reference_tar_uuid
      vagrent_cache_tar_uuid: vagrent_cache_tar_uuid
      snv_indel_tar_uuid: snv_indel_tar_uuid
      cnv_sv_tar_uuid: cnv_sv_tar_uuid
      qcset_tar_uuid: qcset_tar_uuid 
      tumor_bam_uuid: tumor_bam_uuid
      tumor_index_uuid: tumor_index_uuid
      normal_bam_uuid: normal_bam_uuid
      normal_index_uuid: normal_index_uuid
    out: [ gdc_sequence_dict, gdc_reference_fasta, gdc_reference_fai, core_reference_tar, vagrent_cache,
           snv_indel_tar, cnv_sv_tar, qcset_tar, tumor_bam, tumor_index, normal_bam,
           normal_index ]

  run_main_workflow:
    run: ./subworkflows/main_gdc_wgs_workflow.cwl
    in:
      sanger_threads: sanger_threads
      other_threads: other_threads
      job_uuid: job_uuid
      tumor_aliquot_uuid: tumor_aliquot_uuid
      normal_aliquot_uuid: normal_aliquot_uuid
      gdc_reference: stage_inputs/gdc_reference_fasta
      reference_fai: stage_inputs/gdc_reference_fai 
      sequence_dict: stage_inputs/gdc_sequence_dict
      core_reference_tar: stage_inputs/core_reference_tar
      vagrent_cache: stage_inputs/vagrent_cache
      snv_indel_tar: stage_inputs/snv_indel_tar
      cnv_sv_tar: stage_inputs/cnv_sv_tar
      qcset_tar: stage_inputs/qcset_tar
      tumor_bam: stage_inputs/tumor_bam
      tumor_index: stage_inputs/tumor_index
      normal_bam: stage_inputs/normal_bam
      normal_index: stage_inputs/normal_index
    out: [ wf_archive_file, brass_vcf_file, brass_vcf_index_file, brass_bedpe_file, brass_bedpe_index_file, 
           caveman_vcf_file, caveman_vcf_index_file, ascat_tumor_ploidy, ascat_tumor_purity, 
           ascat_segmentation_file, ascat_genelevel_file, pindel_vcf, pindel_vcf_index ]

  upload_results:
    run: ./subworkflows/upload_results_workflow.cwl
    in:
      bioclient_config: bioclient_config
      upload_bucket: upload_bucket
      job_uuid: job_uuid
      wf_archive_file: run_main_workflow/wf_archive_file
      brass_vcf_file: run_main_workflow/brass_vcf_file 
      brass_vcf_index_file: run_main_workflow/brass_vcf_index_file 
      brass_bedpe_file: run_main_workflow/brass_bedpe_file 
      caveman_vcf_file: run_main_workflow/caveman_vcf_file 
      caveman_vcf_index_file: run_main_workflow/caveman_vcf_index_file 
      ascat_segmentation_file: run_main_workflow/ascat_segmentation_file
      ascat_genelevel_file: run_main_workflow/ascat_genelevel_file
      pindel_vcf_file: run_main_workflow/pindel_vcf
      pindel_vcf_index_file: run_main_workflow/pindel_vcf_index
    out: [ wf_archive_uuid, brass_vcf_uuid, brass_vcf_index_uuid, brass_bedpe_uuid,
           caveman_vcf_uuid, caveman_vcf_index_uuid,
           ascat_segmentation_uuid, ascat_genelevel_uuid, pindel_vcf_uuid,
           pindel_vcf_index_uuid ]
