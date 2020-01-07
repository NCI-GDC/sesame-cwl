# GDC Methylation Array Sesame Workflow

This workflow takes a pair of Illumina methylation array idat files and generates
beta values and various statistics using the [SeSAMe](https://www.bioconductor.org/packages/release/bioc/html/sesame.html)
R package.

## External Users

The entrypoint CWL workflow for external users is `workflows/subworkflows/gdc_sesame_main_workflow.cwl`.

### Inputs

| Name | Type | Description |
| ---- | ---- | ----------- |
| `green_input` | `File` | The green channel idat file. |
| `red_input` | `File` | The red channel idat file. |
| `job_uuid` | `string` | Unique ID for the job and used to generate output file names. |

### Outputs

| Name | Type | Description |
| ---- | ---- | ----------- |
| `lvl3betas` | `File` | The methylation beta values TSV. | 
| `metadata` | `File` | Metadata and statistics JSON file. |

## Internal GDC Users

The entrypoint CWL workflow for GDC users is `workflows/gdc_sesame_workflow.cwl`.

### Inputs

| Name | Type | Description |
| ---- | ---- | ----------- |
| `bioclient_config` | `File` | Bioclient config/creds json file. |
| `bioclient_load_bucket` | `string` | Bucket to upload results. |
| `green_input_gdc_id` | `string` | The green channel idat file UUID. |
| `green_input_file_size` | `long` | The green channel idat file size in bytes. |
| `red_input_gdc_id` | `string` | The red channel idat file UUID. |
| `red_input_file_size` | `Long` | The red channel idat file size in bytes. |
| `job_uuid` | `string` | Unique ID for the job and used to generate output file names. |

### Outputs

| Name | Type | Description |
| ---- | ---- | ----------- |
| `indexd_sesame_methylation_lvl3betas_uuid` | `string` | UUID of the methylation beta values TSV. | 
| `indexd_sesame_methylation_metadata_uuid` | `string` | UUID of the metadata and statistics JSON file. |
