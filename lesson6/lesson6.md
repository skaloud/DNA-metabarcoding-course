# Lesson 6: DNA Metabarcoding Data Analysis - Processing of RUN1 and RUN2 Replicates

In this lesson, we will process the data from RUN1 and RUN2 to analyze DNA metabarcoding data.

## Processing RUN1 Data

### Unzip the Sequences
```bash
cd /home/ubuntu/RUN1
gunzip subset_R1.fastq.gz
gunzip subset_R2.fastq.gz
```

### Quality Filtering
We will use the `Reads_Quality_Length_distribution.pl` script to filter out low-quality and short sequences.
- `fw`: forward reads
- `rw`: reverse paired-end reads
- `sc`: Illumina Phred format
- `q`: mean quality threshold
- `l`: reads shorter than this number will be discarded
- `ld`: give read length distribution

```bash
perl ../scripts/Reads_Quality_Length_distribution.pl -fw subset_R1.fastq -rw subset_R2.fastq -sc 33 -q 26 -l 150 -ld N
```

**Output**:
- Total number of reads: 1,000,000
- Reads without Ns (F/R): 998,526 (99.8526%)
- Reads without Ns, quality cutoff 26 and length cutoff 150: 805,859 (80.5859%)

### Remove Adapters
Remove adapters and the sequences following them using `cutadapt`.
- `-a`: forward reads
- `-A`: reverse reads
- `-o`, `-p`: output files for forward and reverse reads

```bash
cutadapt -a AGATCGGAAGAGCACACGTCTGAACTCCAGTCAC -A AGATCGGAAGAGCGTCGTGTAGGGAAAGA -o  filtered1.fastq -p filtered2.fastq Filtered_reads_without_Ns_quality_threshold_26_length_threshold_150_R1.fastq Filtered_reads_without_Ns_quality_threshold_26_length_threshold_150_R2.fastq
```

**Output**:
- Summary of adapter presence in %
- Bases preceding removed sequences
- Overview of removed sequences

### Paired-End Assembly
Assemble forward and reverse reads using `pandaseq`.
- `-f`: forward reads
- `-r`: reverse reads
- `-F`: preserve fastq format
- `-N`: remove reads with unknown nucleotides
- `-o`: minimum read overlap between forward and reverse reads

```bash
pandaseq -f filtered1.fastq -r filtered2.fastq -F -N -o 5 > paired_assembled.fastq
```

**Output**:
- ELAPSED
- READS
- NOALGN
- LOWQ
- BADR
- SLOW
- OK
- OVERLAPS

**Check number of reads**:
```bash
cat paired_assembled.fastq | wc -l | awk '{print $1/4}'
```
Result: 803,907 reads

### Extract Reads by Primers
Create a folder to store green algal sequences.
```bash
mkdir green_algae
```

Remove primer artifacts using `remove_multiprimer.py`.
```bash
python ../scripts/remove_multiprimer.py -i paired_assembled.fastq -o green_algae/paired_assembled.NOmultiprimer_ready.fastq -f GAATTCCGTGAACCATCGAATCTTT -r TCCTCCGCTTATTGATATGC
```

Change to the new folder.
```bash
cd green_algae
```

Extract reads by primers.
- `-m`: allow 2 mismatches
- `-p`: primer used to extract reads
- `-e`: input fastq file

```bash
../../programs/fqgrep/fqgrep -m 2 -p 'GAATTCCGTGAACCATCGAATCTTT' -e paired_assembled.NOmultiprimer_ready.fastq > good_5-3.fastq
../../programs/fqgrep/fqgrep -m 2 -p 'TCCTCCGCTTATTGATATGC' -e paired_assembled.NOmultiprimer_ready.fastq > good_3-5.fastq
```

Reorient reads to 5’-3’.
```bash
../../programs/fastx_toolkit-0.0.14/src/fastx_reverse_complement/fastx_reverse_complement -Q33 -i good_3-5.fastq >> good_5-3.fastq
cp good_5-3.fastq 5-3_oriented.fastq
```

**Check number of reads**:
```bash
cat 5-3_oriented.fastq | wc -l | awk '{print $1/4}'
```
Result: 797,309 reads

### Demultiplexing
Create a new directory for demultiplexed fastq files.
```bash
mkdir fastq
cd fastq
```

Prepare CSV tables with barcodes and primers.
- `forward_labels.csv`: contains sample names and the 5’-3’ orientation label + primer sequences
- `reverse_labels.csv`: contains sample names and the 3’-5’ orientation label + primer sequences (should be in reverse complement)

Demultiplex into individual samples and save as FASTQ.
```bash
bash ../../../scripts/demultiplex.sh forward_labels.csv reverse_labels.csv ../5-3_oriented.fastq
```

**Results**: Individual primer combinations (samples) saved as separate FASTQ files.

## Processing RUN2 Data

### Produce Subsets for RUN2
```bash
cd /home/ubuntu/RUN2
zcat 221122_R1.fastq.gz | head -n 4000000 | gzip > subset_221122_R1.fastq.gz
zcat 221122_R2.fastq.gz | head -n 4000000 | gzip > subset_221122_R2.fastq.gz
```

### Unzip the Sequences
```bash
gunzip subset_221122_R1.fastq.gz
gunzip subset_221122_R2.fastq.gz
```

### Quality Filtering
```bash
perl ../scripts/Reads_Quality_Length_distribution.pl -fw subset_221122_R1.fastq -rw subset_221122_R2.fastq -sc 33 -q 26 -l 150 -ld N
```

**Output**:
- Total number of reads: 1,000,000
- Reads without Ns (F/R): 994,884 (99.4884%)
- Reads without Ns, quality cutoff 26 and length cutoff 150: 889,838 (88.9838%)

### Remove Adapters
```bash
cutadapt -a AGATCGGAAGAGCACACGTCTGAACTCCAGTCAC -A AGATCGGAAGAGCGTCGTGTAGGGAAAGA -o  filtered1.fastq -p filtered2.fastq Filtered_reads_without_Ns_quality_threshold_26_length_threshold_150_R1.fastq Filtered_reads_without_Ns_quality_threshold_26_length_threshold_150_R2.fastq
```

### Paired-End Assembly
```bash
pandaseq -f filtered1.fastq -r filtered2.fastq -F -N -o 5 > paired_assembled.fastq
```

**Check number of reads**:
```bash
cat paired_assembled.fastq | wc -l | awk '{print $1/4}'
```
Result: 889,223 reads

### Extract Reads by Primers
Create a folder to store green algal sequences.
```bash
mkdir green_algae
```

Remove primer artifacts using `remove_multiprimer.py`.
```bash
python ../scripts/remove_multiprimer.py -i paired_assembled.fastq -o green_algae/paired_assembled.NOmultiprimer_ready.fastq -f GAATTCCGTGAACCATCGAATCTTT -r TCCTCCGCTTATTGATATGC
```

Change to the new folder.
```bash
cd green_algae
```

Extract reads by primers.
```bash
../../programs/fqgrep/fqgrep -m 2 -p 'GAATTCCGTGAACCATCGAATCTTT' -e paired_assembled.NOmultiprimer_ready.fastq > good_5-3.fastq
../../programs/fqgrep/fqgrep -m 2 -p 'TCCTCCGCTTATTGATATGC' -e paired_assembled.NOmultiprimer_ready.fastq > good_3-5.fastq
```

Reorient reads to 5’-3’.
```bash
../../programs/fastx_toolkit-0.0.14/src/fastx_reverse_complement/fastx_reverse_complement -Q33 -i good_3-5.fastq >> good_5-3.fastq
cp good_5-3.fastq 5-3_oriented.fastq
```

**Check number of reads**:
```bash
cat 5-3_oriented.fastq | wc -l | awk '{print $1/4}'
```
Result: 883,065 reads

### Demultiplexing
Create a new directory for demultiplexed fastq files.
```bash
mkdir fastq
cd fastq
```

Demultiplex into individual samples and save as FASTQ.
```bash
bash ../../../scripts/demultiplex.sh forward_labels.csv reverse_labels.csv ../5-3_oriented.fastq
```

**Results**: Individual primer combinations (samples) saved as separate FASTQ files.

---

[Previous Lesson](../lesson5/lesson5.md) | [Next Lesson](../lesson7/lesson7.md)
