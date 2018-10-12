#!/usr/bin/env cwl-runner
doc: |
    A workflow to verify the proper execution of [TOPMed RNA-seq Workflow](https://github.com/heliumdatacommons/cwl_workflows/blob/master/topmed-workflows/TOPMed_RNAseq_pipeline/rnaseq_pipeline_fastq.cwl)

cwlVersion: v1.0
class: Workflow
id: "RNAseq-checker"
label: "RNAseq-checker"

requirements:
  - class: StepInputExpressionRequirement
  - class: InlineJavascriptRequirement
  - class: SubworkflowFeatureRequirement

inputs:
  star_index:
    type: Directory
  fastqs:
    type: File[]
  prefix_str:
    type: string
  rsem_ref_dir:
    type: Directory
  max_frag_len:
    type: int
  estimate_rspd:
    type: boolean
  is_stranded:
    type: boolean
  paired_end:
    type: boolean
  genes_gtf:
    type: File
  genome_fasta:
    type: File
    secondaryFiles:
      - .fai
      - ^.dict
  rnaseqc_flags:
    type: string[]
  # gatk_flags:
  #   type:
  #     type: "null"
  #     type: array
  #     items: string
  hash_count_metrics:
    type: string
  hash_chimeric_junctions:
    type: string
  hash_read_counts:
    type: string
  hash_junctions:
    type: string
  hash_junctions_pass1:
    type: string
  # hash_markduplicates_metrics:
  #   type: string
  hash_gene_results:
    type: string
  hash_isoforms_results:
    type: string
  # hash_gene_rpkm:
  #   type: string
  # hash_gene_counts:
  #   type: string
  # hash_exon_counts:
  #   type: string
  # hash_count_outputs:
  #   type: string
  checker_star_output_bam:
    type: File
  checker_transcriptome_bam:
    type: File
  checker_chimeric_bam_file:
    type: File
  checker_markduplicates_bam:
    type: File
  known_str:
    type: string


outputs:
  check_star_output_bam_str:
    type: string
    outputSource: check_star_output_bam/out_string
  check_transcriptome_bam_str:
    type: string
    outputSource: check_transcriptome_bam/out_string
  check_chimeric_bam_str:
    type: string
    outputSource: check_chimeric_bam/out_string
  check_markduplicates_bam_str:
    type: string
    outputSource: check_markduplicates_bam/out_string
  check_chimeric_junctions_hash:
    type: string
    outputSource: check_chimeric_junctions/out_hash_string
  check_read_counts_hash:
    type: string
    outputSource: check_read_counts/out_hash_string
  check_junctions_hash:
    type: string
    outputSource: check_junctions/out_hash_string
  check_junctions_pass1_hash:
    type: string
    outputSource: check_junctions_pass1/out_hash_string
  # check_markduplicates_metrics_hash:
  #   type: string
  #   outputSource: check_markduplicates_metrics/out_hash_string
  check_gene_results_hash:
    type: string
    outputSource: check_gene_results/out_hash_string
  check_isoforms_results_hash:
    type: string
    outputSource: check_isoforms_results/out_hash_string
  # check_gene_rpkm_hash:
  #   type: string
  #   outputSource: check_gene_rpkm/out_hash_string
  # check_gene_counts_hash:
  #   type: string
  #   outputSource: check_gene_counts/out_hash_string
  # check_exon_counts_hash:
  #   type: string
  #   outputSource: check_exon_counts/out_hash_string
  check_count_metrics_hash:
    type: string
    outputSource: check_count_metrics/out_hash_string
  # check_count_outputs_hash:
  #   type: string
  #   outputSource: check_count_outputs/out_hash_string

steps:
  run_rnaseq_pipeline:
    run: ../rnaseq_pipeline_fastq.cwl
    in:
      star_index: star_index
      fastqs: fastqs
      prefix_str: prefix_str
      rsem_ref_dir: rsem_ref_dir
      max_frag_len: max_frag_len
      estimate_rspd: estimate_rspd
      is_stranded: is_stranded
      paired_end: paired_end
      genes_gtf: genes_gtf
      genome_fasta: genome_fasta
      rnaseqc_flags: rnaseqc_flags
      # gatk_flags: gatk_flags
    out:
      [
        star_output_bam,
        star_output_bam_index,
        star_output_transcriptome_bam,
        star_output_chimeric_junctions,
        star_output_chimeric_bam_file,
        star_output_chimeric_bam_index,
        star_output_read_counts,
        star_output_junctions,
        star_output_junctions_pass1,
        star_output_logs,
        markduplicates_output_bam,
        markduplicates_output_metrics,
        markduplicates_bam_index,
        rsem_output_gene_results,
        rsem_output_isoforms_results,
        rna-seqc_output_gene_rpkm,
        rna-seqc_output_gene_counts,
        rna-seqc_output_exon_counts,
        rna-seqc_output_count_metrics,
        rna-seqc_output_count_outputs
      ]

  check_star_output_bam:
    run: check_bams_wf.cwl
    in:
      bam_one: run_rnaseq_pipeline/star_output_bam
      bam_two: checker_star_output_bam
      known_str: known_str
    out: [out_string]

  check_transcriptome_bam:
    run: check_bams_wf.cwl
    in:
      bam_one: run_rnaseq_pipeline/star_output_transcriptome_bam
      bam_two: checker_transcriptome_bam
      known_str: known_str
    out: [out_string]

  check_chimeric_bam:
    run: check_bams_wf.cwl
    in:
      bam_one: run_rnaseq_pipeline/star_output_chimeric_bam_file
      bam_two: checker_chimeric_bam_file
      known_str: known_str
    out: [out_string]

  check_markduplicates_bam:
    run: check_bams_wf.cwl
    in:
      bam_one: run_rnaseq_pipeline/markduplicates_output_bam
      bam_two: checker_markduplicates_bam
      known_str: known_str
    out: [out_string]

  check_chimeric_junctions:
    run: check_md5_wf.cwl
    in:
      file_to_check: run_rnaseq_pipeline/star_output_chimeric_junctions
      input_hash: hash_chimeric_junctions
    out: [out_hash_string]

  check_read_counts:
    run: check_md5_wf.cwl
    in:
      file_to_check: run_rnaseq_pipeline/star_output_read_counts
      input_hash: hash_read_counts
    out: [out_hash_string]

  check_junctions:
    run: check_md5_wf.cwl
    in:
      file_to_check: run_rnaseq_pipeline/star_output_junctions
      input_hash: hash_junctions
    out: [out_hash_string]

  check_junctions_pass1:
    run: check_md5_wf.cwl
    in:
      file_to_check: run_rnaseq_pipeline/star_output_junctions_pass1
      input_hash: hash_junctions_pass1
    out: [out_hash_string]

  # check_markduplicates_metrics:
  #   run: check_md5_wf.cwl
  #   in:
  #     file_to_check: run_rnaseq_pipeline/markduplicates_output_metrics
  #     input_hash: hash_markduplicates_metrics
  #   out: [out_hash_string]

  check_gene_results:
    run: check_md5_wf.cwl
    in:
      file_to_check: run_rnaseq_pipeline/rsem_output_gene_results
      input_hash: hash_gene_results
    out: [out_hash_string]

  check_isoforms_results:
    run: check_md5_wf.cwl
    in:
      file_to_check: run_rnaseq_pipeline/rsem_output_isoforms_results
      input_hash: hash_isoforms_results
    out: [out_hash_string]

  # check_gene_rpkm:
  #   run: check_md5_wf.cwl
  #   in:
  #     file_to_check: run_rnaseq_pipeline/rna-seqc_output_gene_rpkm
  #     input_hash: hash_gene_rpkm
  #   out: [out_hash_string]

  # check_gene_counts:
  #   run: check_md5_wf.cwl
  #   in:
  #     file_to_check: run_rnaseq_pipeline/rna-seqc_output_gene_counts
  #     input_hash: hash_gene_counts
  #   out: [out_hash_string]

  # check_exon_counts:
  #   run: check_md5_wf.cwl
  #   in:
  #     file_to_check: run_rnaseq_pipeline/rna-seqc_output_exon_counts
  #     input_hash: hash_exon_counts
  #   out: [out_hash_string]

  check_count_metrics:
    run: check_md5_wf.cwl
    in:
      file_to_check: run_rnaseq_pipeline/rna-seqc_output_count_metrics
      input_hash: hash_count_metrics
    out: [out_hash_string]

  # check_count_outputs:
  #   run: check_md5_wf.cwl
  #   in:
  #     file_to_check: run_rnaseq_pipeline/rna-seqc_output_count_outputs
  #     input_hash: hash_count_outputs
  #   out: [out_hash_string]

$namespaces:
  s: http://schema.org/

$schemas:
- http://dublincore.org/2012/06/14/dcterms.rdf
- http://xmlns.com/foaf/spec/20140114.rdf
- https://schema.org/docs/schema_org_rdfa.html

s:author:
  - class: s:Person
    s:id: https://orcid.org/0000-0003-3523-5312
    s:email: christopherball@rti.org
    s:name: Christopher Ball

s:codeRepository: https://github.com/heliumdatacommons/cwl_workflows
