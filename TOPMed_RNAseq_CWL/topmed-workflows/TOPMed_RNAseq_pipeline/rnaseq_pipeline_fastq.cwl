#!/usr/bin/env cwl-runner
doc: |
    TOPMed RNA-seq CWL workflow. Documentation on the workflow can be found [here](https://github.com/heliumdatacommons/cwl_workflows/blob/master/topmed-workflows/TOPMed_RNAseq_pipeline/README.md).
    Example input files: [Dockstore.json](https://github.com/heliumdatacommons/cwl_workflows/blob/master/topmed-workflows/TOPMed_RNAseq_pipeline/input-examples/Dockstore.json) and [rnaseq_pipeline_fastq-example.yml](https://github.com/heliumdatacommons/cwl_workflows/blob/master/topmed-workflows/TOPMed_RNAseq_pipeline/input-examples/rnaseq_pipeline_fastq-example.yml).

    Quickstart instructions are [here](https://github.com/heliumdatacommons/cwl_workflows/blob/master/topmed-workflows/TOPMed_RNAseq_pipeline/README.md#Quick Start).

    [GitHub Repo](https://github.com/heliumdatacommons/cwl_workflows)

    Pipeline steps:
    1. Align RNA-seq reads with [STAR v2.5.3a](https://github.com/alexdobin/STAR).
    2. Run [Picard](https://github.com/broadinstitute/picard) [MarkDuplicates](https://broadinstitute.github.io/picard/command-line-overview.html#MarkDuplicates).
    2a. Create BAM index for MarkDuplicates BAM with [Samtools 1.6](https://github.com/samtools/samtools/releases) index.
    3. Transcript quantification with [RSEM 1.3.0](https://deweylab.github.io/RSEM/)
    4. Gene quantification and quality control with [RNA-SeQC 1.1.9](https://github.com/francois-a/rnaseqc)

cwlVersion: v1.0
class: Workflow
label: "TOPMed_RNA-seq"

requirements:
  SubworkflowFeatureRequirement: {}
  StepInputExpressionRequirement: {}
# hints:
#   ResourceRequirement:
#     coresMin: 4
#     ramMin: 16
#     #tmpdirMin: 51200

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

outputs:
  star_output_bam:
    outputSource: sort_bam/output_file
    type: File
  star_output_bam_index:
    outputSource: index_bam/bam_index
    type: File
  star_output_transcriptome_bam:
    outputSource: run_star/transcriptome_bam
    type: File
  star_output_chimeric_junctions:
    outputSource: run_star/chimeric_junctions
    type: File
  star_output_chimeric_bam_file:
    outputSource: sort_chimeras/output_file
    type: File
  star_output_chimeric_bam_index:
    outputSource: index_chimeras/bam_index
    type: File
  star_output_read_counts:
    outputSource: run_star/read_counts
    type: File
  star_output_junctions:
    outputSource: run_star/junctions
    type: File
  star_output_junctions_pass1:
    outputSource: run_star/junctions_pass1
    type: File
  star_output_logs:
    outputSource: run_star/logs
    type: File[]
  markduplicates_output_bam:
    outputSource: run_markduplicates/bam_file
    type: File
  markduplicates_output_metrics:
    outputSource: run_markduplicates/metrics
    type: File
  markduplicates_bam_index:
    outputSource: run_index_markduplicates_bam/bam_index
    type: File
  rsem_output_gene_results:
    outputSource: run_rsem/gene_results
    type: File
  rsem_output_isoforms_results:
    outputSource: run_rsem/isoforms_results
    type: File
  rna-seqc_output_gene_rpkm:
    outputSource: run_rna-seqc/gene_rpkm
    type: File
  rna-seqc_output_gene_counts:
    outputSource: run_rna-seqc/gene_counts
    type: File
  rna-seqc_output_exon_counts:
    outputSource: run_rna-seqc/exon_counts
    type: File
  rna-seqc_output_count_metrics:
    outputSource: run_rna-seqc/count_metrics
    type: File
  rna-seqc_output_count_outputs:
    outputSource: run_rna-seqc/count_outputs
    type: File

steps:
  run_star:
    run: star.cwl
    in:
      star_index: star_index
      fastqs: fastqs
      prefix: prefix_str
    out:
      [
        bam,
        transcriptome_bam,
        chimeric_junctions,
        chimeric_bam,
        read_counts,
        junctions,
        junctions_pass1,
        logs
      ]

  sort_bam:
    run: samtools-sort.cwl
    in:
      input:
        source: run_star/bam
      output_name:
        source: prefix_str
        valueFrom: $(self).Aligned.sortedByCoord.out.bam
    out: [ output_file ]

  sort_chimeras:
    run: samtools-sort.cwl
    in:
      input:
        source: run_star/chimeric_bam
      output_name:
        source: prefix_str
        valueFrom: $(self).Chimeric.out.sorted.bam
    out: [ output_file ]

  index_bam:
    run: indexbam.cwl
    in:
      input_bam: sort_bam/output_file
    out: [bam_index]

  index_chimeras:
    run: indexbam.cwl
    in:
      input_bam: sort_chimeras/output_file
    out: [bam_index]

  run_markduplicates:
    run: markduplicates.cwl
    in:
      input_bam: sort_bam/output_file
      prefix_str: prefix_str
    out:
      [
        bam_file,
        metrics
      ]

  run_index_markduplicates_bam:
    run: indexbam.cwl
    in:
      input_bam: run_markduplicates/bam_file
    out: [bam_index]

  run_rsem:
    run: rsem.cwl
    in:
      rsem_ref_dir: rsem_ref_dir
      transcriptome_bam: run_star/transcriptome_bam
      prefix_str: prefix_str
      max_frag_len: max_frag_len
      estimate_rspd: estimate_rspd
      is_stranded: is_stranded
      paired_end: paired_end
    out:
      [
        gene_results,
        isoforms_results
      ]

  run_rna-seqc:
    run: rna_seqc.cwl
    in:
      bam_file: run_index_markduplicates_bam/bam_index
      genes_gtf: genes_gtf
      genome_fasta: genome_fasta
      prefix_str: prefix_str
      rnaseqc_flags: rnaseqc_flags
      # gatk_flags: gatk_flags
    out:
      [
        gene_rpkm,
        gene_counts,
        exon_counts,
        count_metrics,
        count_outputs
      ]

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
