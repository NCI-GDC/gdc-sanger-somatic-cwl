# GDC Sanger Somatic Variant Calling Workflow

This workflow takes a pair of harmnonized WGS BAM files and processes them through the
[CGP core WGS analysis](https://github.com/cancerit/dockstore-cgpwgs).

The docker images used in this workflow can be found in `current_docker_list.txt`.

## External Users

The entrypoint CWL workflow for external users in `workflows/subworkflows/main_gdc_wgs_workflow.cwl`.


The example of input json in `example/main_gdc_wgs_workflow.example.input.json`.

### Inputs

| Name | Type | Description |
| ---- | ---- | ----------- |
| `sanger_threads` | `int?` | Max threads to use for parallel processes. |
| `other_threads` | `int?` | Number of threads to use for pindel, samtools, etc. |
| `job_uuid` | `string` | string use as a prefix for all the output filenames |
| `tumor_aliquot_uuid` | `string` | tumor sample uuid |
| `normal_aliquot_uuid` | `string` | normal sample uuid |
| `gdc_reference` | `File` | GDC reference fasta |
| `sequence_dict` | `File` | GDC reference sequence dictionary |
| `reference_fai` | `File` | GDC reference faidx index |
| `core_reference_tar` | `File` | Archive containing sanger reference files |
| `vagrent_cache` | `File` | Archive containing vagrent cache files |
| `snv_indel_tar` | `File` | Archive containing SNV/InDel data files for sanger workflow |
| `cnv_sv_tar` | `File` | Archive containing CNV/SV data files for sanger workflow |
| `qcset_tar` | `File` | Archive containing QC data files for sanger workflow |
| `tumor_bam` | `File` | Tumor bam file |
| `tumor_index` | `File` | Tumor bam index file |
| `normal_bam` | `File` | Normal bam file |
| `normal_index` | `File` | Normal bam index file |

The `core_reference_tar`, `vagrent_cache`, `snv_indel_tar`, `cnv_sv_tar`, and `qcset_tar` were sourced
from [here](https://github.com/cancerit/dockstore-cgpwgs/wiki/Reference-archives).

### Outputs

| Name | Type | Description |
| ---- | ---- | ----------- |
| `wf_archive_file` | `File` | Archive of raw outputs |
| `brass_vcf_file` | `File` | Formatted brass VCF |
| `brass_vcf_index_file` | `File` | Formatted brass VCF index |
| `brass_bedpe_file` | `File` | Formatted brass bedpe |
| `brass_bedpe_index_file` | `File` | Formatted brass bedpe index |
| `caveman_vcf_file` | `File` | Formatted CaVEMan VCF |
| `caveman_vcf_index_file` | `File` | Formatted CaVEMand VCF index |
| `ascat_tumor_ploidy` | `float` | Estimated tumor ploidy |
| `ascat_tumor_purity` | `float` | Estimated tumor purity |
| `ascat_segmentation_file` | `File` | Formatted ASCAT CNV segmentation file |
| `ascat_genelevel_file` | `File` | Formatted ASCAT gene-level CNV file |
| `pindel_vcf` | `File` | Formatted Pindel VCF |
| `pindel_vcf_index` | `File` | Formatted Pindel VCF index |

## GDC Users

The entrypoint CWL workflow for GDC internal users is `workflows/gdc_sanger_wgs_somatic_workflow.cwl`.
