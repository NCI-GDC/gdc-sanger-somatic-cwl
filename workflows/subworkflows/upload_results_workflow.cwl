cwlVersion: v1.0
class: Workflow

requirements:
  - class: InlineJavascriptRequirement
  - class: StepInputExpressionRequirement
  - class: MultipleInputFeatureRequirement

inputs:
  bioclient_config: File
  upload_bucket: string
  job_uuid: string
  wf_archive_file: File
  brass_vcf_file: File
  brass_vcf_index_file: File
  brass_bedpe_file: File
  brass_bedpe_index_file: File
  caveman_vcf_file: File
  caveman_vcf_index_file: File
  ascat_segmentation_file: File
  ascat_genelevel_file: File
  pindel_vcf_file: File
  pindel_vcf_index_file: File

outputs:
  wf_archive_uuid: 
    type: string 
    outputSource: upload_wf_archive/uuid 
  brass_vcf_uuid: 
    type: string 
    outputSource: upload_brass_vcf/uuid 
  brass_vcf_index_uuid: 
    type: string 
    outputSource: upload_brass_vcf_index/uuid 
  brass_bedpe_uuid: 
    type: string 
    outputSource: upload_brass_bedpe/uuid 
  brass_bedpe_index_uuid: 
    type: string 
    outputSource: upload_brass_bedpe_index/uuid 
  caveman_vcf_uuid: 
    type: string 
    outputSource: upload_caveman_vcf/uuid 
  caveman_vcf_index_uuid: 
    type: string 
    outputSource: upload_caveman_vcf_index/uuid 
  ascat_segmentation_uuid: 
    type: string 
    outputSource: upload_ascat_segmentation/uuid 
  ascat_genelevel_uuid: 
    type: string 
    outputSource: upload_ascat_genelevel/uuid 
  pindel_vcf_uuid: 
    type: string 
    outputSource: upload_pindel_vcf/uuid 
  pindel_vcf_index_uuid: 
    type: string 
    outputSource: upload_pindel_vcf_index/uuid 

steps:
  upload_wf_archive:
    run: ../../tools/bioclient_upload_pull_uuid.cwl
    in:
      config-file: bioclient_config
      upload-bucket: upload_bucket
      upload-key:
        source: [ job_uuid, wf_archive_file ]
        valueFrom: $(self[0] + '/' + self[1].basename)
      input: wf_archive_file
    out: [ output, uuid ]

  upload_brass_vcf:
    run: ../../tools/bioclient_upload_pull_uuid.cwl
    in:
      config-file: bioclient_config
      upload-bucket: upload_bucket
      upload-key:
        source: [ job_uuid, brass_vcf_file ]
        valueFrom: $(self[0] + '/' + self[1].basename)
      input: brass_vcf_file
    out: [ output, uuid ]

  upload_brass_vcf_index:
    run: ../../tools/bioclient_upload_pull_uuid.cwl
    in:
      config-file: bioclient_config
      upload-bucket: upload_bucket
      upload-key:
        source: [ job_uuid, brass_vcf_index_file ]
        valueFrom: $(self[0] + '/' + self[1].basename)
      input: brass_vcf_index_file
    out: [ output, uuid ]

  upload_brass_bedpe:
    run: ../../tools/bioclient_upload_pull_uuid.cwl
    in:
      config-file: bioclient_config
      upload-bucket: upload_bucket
      upload-key:
        source: [ job_uuid, brass_bedpe_file ]
        valueFrom: $(self[0] + '/' + self[1].basename)
      input: brass_bedpe_file 
    out: [ output, uuid ]

  upload_brass_bedpe_index:
    run: ../../tools/bioclient_upload_pull_uuid.cwl
    in:
      config-file: bioclient_config
      upload-bucket: upload_bucket
      upload-key:
        source: [ job_uuid, brass_bedpe_index_file ]
        valueFrom: $(self[0] + '/' + self[1].basename)
      input: brass_bedpe_index_file 
    out: [ output, uuid ]

  upload_caveman_vcf:
    run: ../../tools/bioclient_upload_pull_uuid.cwl
    in:
      config-file: bioclient_config
      upload-bucket: upload_bucket
      upload-key:
        source: [ job_uuid, caveman_vcf_file ]
        valueFrom: $(self[0] + '/' + self[1].basename)
      input: caveman_vcf_file 
    out: [ output, uuid ]

  upload_caveman_vcf_index:
    run: ../../tools/bioclient_upload_pull_uuid.cwl
    in:
      config-file: bioclient_config
      upload-bucket: upload_bucket
      upload-key:
        source: [ job_uuid, caveman_vcf_index_file ]
        valueFrom: $(self[0] + '/' + self[1].basename)
      input: caveman_vcf_index_file 
    out: [ output, uuid ]

  upload_ascat_segmentation:
    run: ../../tools/bioclient_upload_pull_uuid.cwl
    in:
      config-file: bioclient_config
      upload-bucket: upload_bucket
      upload-key:
        source: [ job_uuid, ascat_segmentation_file ]
        valueFrom: $(self[0] + '/' + self[1].basename)
      input: ascat_segmentation_file 
    out: [ output, uuid ]

  upload_ascat_genelevel:
    run: ../../tools/bioclient_upload_pull_uuid.cwl
    in:
      config-file: bioclient_config
      upload-bucket: upload_bucket
      upload-key:
        source: [ job_uuid, ascat_genelevel_file ]
        valueFrom: $(self[0] + '/' + self[1].basename)
      input: ascat_genelevel_file 
    out: [ output, uuid ]

  upload_pindel_vcf:
    run: ../../tools/bioclient_upload_pull_uuid.cwl
    in:
      config-file: bioclient_config
      upload-bucket: upload_bucket
      upload-key:
        source: [ job_uuid, pindel_vcf_file ]
        valueFrom: $(self[0] + '/' + self[1].basename)
      input: pindel_vcf_file 
    out: [ output, uuid ]

  upload_pindel_vcf_index:
    run: ../../tools/bioclient_upload_pull_uuid.cwl
    in:
      config-file: bioclient_config
      upload-bucket: upload_bucket
      upload-key:
        source: [ job_uuid, pindel_vcf_index_file ]
        valueFrom: $(self[0] + '/' + self[1].basename)
      input: pindel_vcf_index_file
    out: [ output, uuid ]
