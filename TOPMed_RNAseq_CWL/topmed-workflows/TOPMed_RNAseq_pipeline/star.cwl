#!/usr/bin/env cwl-runner
doc: |
    A CWL wrapper for [run_STAR.py](https://github.com/broadinstitute/gtex-pipeline/blob/master/rnaseq/src/run_STAR.py)

    Runs [STAR v2.5.3a](https://github.com/alexdobin/STAR)

    This CWL Tool was developed as step 1 of the TOPMed RNA-seq workflow.

    [GitHub Repo](https://github.com/heliumdatacommons/cwl_workflows)

cwlVersion: v1.0
class: CommandLineTool
label: "run-star"
baseCommand: STAR

hints:
  DockerRequirement:
    #dockerPull: quay.io/biocontainers/star:2.5.3a--0
    dockerFile: |
      FROM debian:buster-slim
      MAINTAINER biocontainers <biodocker@gmail.com>
      LABEL    software="rna-star" \
          container="rna-star" \
          about.summary="ultrafast universal RNA-seq aligner" \
          about.home="https://github.com/alexdobin/STAR/" \
          software.version="2.5.3adfsg-1-deb" \
          version="1" \
          about.copyright="2009-2015 Alexander Dobin <dobin@cshl.edu>" \
          about.license="GPL-3+" \
          about.license_file="/usr/share/doc/rna-star/copyright" \
          extra.binaries="/usr/bin/STAR" \
          about.tags="biology::nucleic-acids, field::biology, field::biology:bioinformatics,:c++, role::program, use::analysing,:biological-sequence"
      ENV DEBIAN_FRONTEND noninteractive
      RUN echo \
        'deb http://snapshot.debian.org/archive/debian/20170906/ buster  main' > /etc/apt/sources.list \
        && printf "Package: r-*\nPin: origin snapshot.debian.org\nPin-Priority: 990\n" > /etc/apt/preferences.d/snapshot \
        && apt-get -o Acquire::Check-Valid-Until=false update \
        && apt-get upgrade -y \
        && apt-get install -y --no-install-recommends \
            --allow-unauthenticated rna-star=2.5.3a+dfsg-3 \
        && apt-get clean && apt-get purge && rm -rf /var/lib/apt/lists/* /tmp/*
    dockerImageId: star

inputs:
  star_index:
    type: Directory
    inputBinding:
      prefix: --genomeDir
  fastqs:
    type:
      type: array
      items: File
      inputBinding:
        itemSeparator: ","
    inputBinding:
      prefix: --readFilesIn
  prefix:
    type: string
    inputBinding:
      prefix: --outFileNamePrefix
      valueFrom: $(runtime.outdir)/$(self).

arguments:
  - prefix: --runMode
    valueFrom: alignReads
  - prefix: --runThreadN
    valueFrom: $(runtime.cores)
  - prefix: --twopassMode
    valueFrom: Basic
  - prefix: --outFilterMultimapNmax
    valueFrom: "20"
  - prefix: --alignSJoverhangMin
    valueFrom: "8"
  - prefix: --alignSJDBoverhangMin
    valueFrom: "1"
  - prefix: --outFilterMismatchNmax
    valueFrom: "999"
  - prefix: --outFilterMismatchNoverLmax
    valueFrom: "0.1"
  - prefix: --alignIntronMin
    valueFrom: "20"
  - prefix: --alignIntronMax
    valueFrom: "1000000"
  - prefix: --alignMatesGapMax
    valueFrom: "1000000"
  - prefix: --outFilterType
    valueFrom: BySJout
  - prefix: --outFilterScoreMinOverLread
    valueFrom: "0.33"
  - prefix: --outFilterMatchNminOverLread
    valueFrom: "0.33"
  - prefix: --limitSjdbInsertNsj
    valueFrom: "1200000"
  - prefix: --readFilesCommand
    valueFrom: zcat
  - prefix: --outSAMstrandField
    valueFrom: introMotif
  - prefix: --outFilterIntronMotifs
    valueFrom: None
  - prefix: --alignSoftClipAtReferenceEnds
    valueFrom: Yes
  - --quantMode
  - TranscriptomeSAM
  - GeneCounts
  - --outSAMtype
  - BAM
  - Unsorted
  - prefix: --outSAMunmapped
    valueFrom: Within
  - prefix: --genomeLoad
    valueFrom: NoSharedMemory
  - prefix: --chimSegmentMin
    valueFrom: "15"
  - prefix: --chimJunctionOverhangMin
    valueFrom: "15"
  - --chimOutType
  - WithinBAM
  - SoftClip
  - prefix: --chimMainSegmentMultNmax
    valueFrom: "1"
  - --outSAMattributes
  - NH
  - HI
  - AS
  - nM
  - NM
  - ch
  - --outSAMattrRGline
  - ID:rg1
  - SM:sm1


outputs:
  bam:
    type: File
    outputBinding:
      glob: $(inputs.prefix).Aligned.out.bam
  transcriptome_bam:
    type: File
    outputBinding:
      glob: "*.Aligned.toTranscriptome.out.bam"
  chimeric_junctions:
    type: File
    outputBinding:
      glob: "*.Chimeric.out.junction"
  chimeric_bam:
    type: File
    outputBinding:
      glob: $(inputs.prefix).Chimeric.out.sam
  # chimeric_bam_file:
  #   type: File
  #   outputBinding:
  #     glob: "*.Chimeric.out.sorted.bam"
  # chimeric_bam_index:
  #   type: File
  #   outputBinding:
  #     glob: "*.Chimeric.out.sorted.bam.bai"
  read_counts:
    type: File
    outputBinding:
      glob: "*.ReadsPerGene.out.tab"
  junctions:
    type: File
    outputBinding:
      glob: "*.SJ.out.tab"
  junctions_pass1:
    type: File
    outputBinding:
      glob: "*._STARpass1/SJ.out.tab"
  logs:
    type:
      type: array
      items: File
    outputBinding:
      glob: "*.*.out"
