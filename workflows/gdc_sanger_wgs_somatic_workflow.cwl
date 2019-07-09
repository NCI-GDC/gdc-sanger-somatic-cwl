cwlVersion: v1.0
class: Workflow

requirements:
  - class: InlineJavascriptRequirement
  - class: SubworkflowFeatureRequirement

inputs:
  bioclient_config: File
  upload_bucket: string
  threads: int?
  job_uuid: string
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
    outputSource:
  pindel_vcf_uuid:
    type: string
    outputSource:
  pindel_vcf_index_uuid:
    type: string
    outputSource:
  caveman_vcf_uuid:
    type: string
    outputSource:
  caveman_vcf_index_uuid:
    type: string
    outputSource:
  brass_vcf_uuid:
    type: string
    outputSource:
  brass_vcf_index_uuid:
    type: string
    outputSource:
  brass_bedpe_uuid:
    type: string
    outputSource:
  brass_bedpe_index_uuid:
    type: string
    outputSource:
  ascat_segmentation_uuid: 
    type: string
    outputSource:
  ascat_gene_level_cnv_uuid: 
    type: string
    outputSource:
  ascat_purity_estimation:
    type: float
    outputSource:
  ascat_ploidy_estimation:
    type: float
    outputSource:

steps:
  stage_inputs:
    run: ./subworkflows/stage_inputs_workflow.cwl
    in:
      bioclient_config: bioclient_config
      gdc_core_reference_tar_uuid: gdc_core_reference_tar_uuid
      vagrent_cache_tar_uuid: vagrent_cache_tar_uuid
      snv_indel_tar_uuid: snv_indel_tar_uuid
      cnv_sv_tar_uuid: cnv_sv_tar_uuid
      qcset_tar_uuid: qcset_tar_uuid 
      tumor_bam_uuid: tumor_bam_uuid
      tumor_index_uuid: tumor_index_uuid
      normal_bam_uuid: normal_bam_uuid
      normal_index_uuid: normal_index_uuid
    out: [ core_reference_tar, vagrent_cache, snv_indel_tar, cnv_sv_tar, qcset_tar, tumor_bam, tumor_index, normal_bam, normal_index ]

  run_main_workflow:
    run: ./subworkflows/main_gdc_wgs_workflow.cwl
