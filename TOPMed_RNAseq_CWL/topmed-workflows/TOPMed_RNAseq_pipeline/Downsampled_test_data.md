## Creating downsampled inputs
The sample input files were created by downsampling sample input files and using chr12 of the Homo Sapian Assembly 38 Genome file.

### Chr12 Fasta file
Full file: [Homo_sapiens_assembly38_noALT_noHLA_noDecoy_ERCC.fasta](https://personal.broadinstitute.org/francois/topmed/Homo_sapiens_assembly38_noALT_noHLA_noDecoy_ERCC.tar.gz)

Split file by chromosome:
```
csplit -s -z Homo_sapiens_assembly38_noALT_noHLA_noDecoy_ERCC.fasta '/>/' '{*}'
for i in xx* ; do \
  n=$(sed 's/>// ; s/ .*// ; 1q' "$i") ; \
  mv "$i" "$n.fa" ; \
 done
```

Use `chr12.fa` in the following steps.

### Create .dict

Create the dictionary file using Picard CreateSequenceDictionary.

`~/chr12` contains the `chr12.fa` file.

```
docker run --rm -v ~/chr12:/temp heliumdatacommons/topmed-rnaseq \
    java -jar /opt/picard-tools/picard.jar CreateSequenceDictionary \
    R=/temp/chr12.fa \
    O=/temp/chr12.dict
```

### Create .fai

Create the index file using `samtools faidx`.

```
docker run --rm -v ~/chr12:/temp heliumdatacommons/topmed-rnaseq \
    samtools faidx /temp/chr12.fa
```

### Get and filter annotation file

Download file:
```
wget ftp://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_human/release_26/gencode.v26.annotation.gtf.gz
```

Filter file for chr12 reads that contain the `transcript_id` field:
```
grep --color=never "^chr12" gencode.v26.annotation.gtf > gencode.v26.annotation.chr12.gtf
grep --color=never "transcript_id" gencode.v26.annotation.chr12.gtf > gencode.v26.annotation.chr12.withTranscriptID.gtf
```

### Create star index

```
docker run --rm -v ~/chr12:/temp heliumdatacommons/topmed-rnaseq \
    STAR --runMode genomeGenerate \
    --genomeDir /temp/star_chr12 \
    --genomeFastaFiles /temp/chr12.fa \
    --sjdbGTFfile /temp/gencode.v26.annotation.chr12.withTranscriptID.gtf \
    --sjdbOverhang 100 --runThreadN 10
```

### Create RSEM reference

Create RSEM reference using `rsem-prepare-reference`:
```
docker run --rm -v ~/chr12:/temp heliumdatacommons/topmed-rnaseq:latest \
    rsem-prepare-reference --num-threads 4 \
    --gtf /temp/gencode.v26.annotation.chr12.withTranscriptID.gtf \
    /temp/chr12.fa \
    /temp/rsem_reference
```

### Downsample sample files

Download sample files:
```
wget ftp.sra.ebi.ac.uk/vol1/ERA156/ERA156312/fastq/LC_C13_cRNA_sequence_R1.txt.gz
wget ftp.sra.ebi.ac.uk/vol1/ERA156/ERA156312/fastq/LC_C13_cRNA_sequence_R2.txt.gz
```

Unzip:
```
gunzip LC_C13_cRNA_sequence_R1.txt.gz
gunzip LC_C13_cRNA_sequence_R2.txt.gz
```

Downsample (`k=10000` is the number of reads to keep):
```
paste LC_C13_cRNA_sequence_R1.txt LC_C13_cRNA_sequence_R2.txt | \
awk '{ printf("%s",$0); n++; if(n%4==0) { printf("\n");} else { printf("\t");} }' | \
awk -v k=10000 'BEGIN{srand(systime() + PROCINFO["pid"]);}{s=x++<k?x1:int(rand()*x); \
if(s<k)R[s]=$0}END{for(i in R)print R[i]}' | awk -F"\t" \
'{print $1"\n"$3"\n"$5"\n"$7 > "LC_C13_cRNA_sequence_R1_sub.fastq"; \
print $2"\n"$4"\n"$6"\n"$8 > "LC_C13_cRNA_sequence_R2_sub.fastq"}'
```
