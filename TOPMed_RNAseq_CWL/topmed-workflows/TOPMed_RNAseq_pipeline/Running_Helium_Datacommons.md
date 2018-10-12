## Running in Helium Datacommons

This document describes running the TOPMed RNA-seq pipeline in the Helium DataCommons environment.

Steps:
* Register files into iRODS
    * [STAR index](https://personal.broadinstitute.org/francois/topmed/STAR_genome_GRCh38_noALT_noHLA_noDecoy_ERCC_v26_oh100.tar.gz)
    * [RSEM reference](https://personal.broadinstitute.org/francois/topmed/rsem_reference_GRCh38_gencode26_ercc.tar.gz)
    * [Genome FASTA](https://personal.broadinstitute.org/francois/topmed/Homo_sapiens_assembly38_noALT_noHLA_noDecoy_ERCC.tar.gz)
    * [Genes GTF](https://personal.broadinstitute.org/francois/topmed/gencode.v26.GRCh38.ERCC.genes.gtf.gz)
    * Unpack `tar` and `gz` files.
    ```
    $ cd /renci/irods/topmed-demo/
    $ gunzip -c LC_C13_cRNA_sequence_R1.txt.gz > LC_C13_cRNA_sequence_R1.fastq
    $ gunzip -c LC_C13_cRNA_sequence_R2.txt.gz > LC_C13_cRNA_sequence_R2.fastq
    $ mkdir star_index
    $ tar -xvvf STAR_genome_GRCh38_noALT_noHLA_noDecoy_ERCC_v26_oh100.tar.gz -C star_index --strip-components=1
    ```
    * Run `ireg` command for all files into desired resource.
* Start an appliance using the instructions [here](https://github.com/heliumdatacommons/PIVOT/blob/master/examples/cwl.md).
* Run with toil
```
cwltoil --noLinkImports --jobStore /<path>/jobstore1 --batchSystem chronos --workDir ./ /<path>/<workflow>.cwl /<path>/<workflow-inputs>.yml
```
