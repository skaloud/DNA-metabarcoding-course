# Lesson 7: DNA Metabarcoding Data Analysis - Demultiplexing and Clustering

While in the previous analysis we processed individual sequencing libraries and replicates, here we will analyze data belonging to a single study, which may come from multiple sequencing runs (replicates).

- The aim is to process data on the diversity of green algae in the soil of different regions of Europe.
- We will work with a total of 64 samples, including NC (4x) and MPC (5x), in two replicates: REP1 and REP2.
- Processing all these data would take a long time for the purpose of the course. Therefore, we will focus on only one area. To make it more engaging, everyone can choose either the area I'm going to demonstrate the data processing on or another area, and at the end, we can compare our results.

## Setting Up the Analysis Environment

1. **Access your virtual machine** and create a new folder for the analysis:
   ```bash
   mkdir /home/ubuntu/analysis_green_algae
   cd /home/ubuntu/analysis_green_algae
   ```

2. **Generate Linux Commands**:
   - On your local machine, open the "generating codes.R" script using RStudio.
   - Use the `barcodes.xlsx` file to generate the necessary Linux commands for the next steps. For this course, we will analyze the arctic samples (first eight barcode pairs).
   - Run the 1st R script to copy and rename the files.
   - Save the commands in Linux format using `dos2unix`.
   - Check `code.copyfiles.txt` for the correct paths.

3. **Copy Files**:
   - Copy `code.copyfiles.txt` to the `analysis_green_algae` directory and run it:
     ```bash
     . code.copyfiles.txt
     ```
   - Check the sizes of files. Both MPC and NC samples should be of small size if the sequencing run and no major contamination occurred.

## Removing Primers and Labels

1. **Calculate the number of bases to remove**:
   - Forward: `3 + 8 + 20 = 31`
   - Reverse: `3 + 8 + 20 = 31`

2. **Run the second R script**:
   - Check `code.removeprimers.txt` for the correct paths.
   - Copy `code.removeprimers.txt` to the `analysis_green_algae` directory and run it:
     ```bash
     . code.removeprimers.txt
     ```

## Converting to FASTA Format

1. **Create a new folder for trimmed sequences**:
   ```bash
   mkdir /home/ubuntu/analysis_green_algae/fastq
   cd /home/ubuntu/analysis_green_algae/fastq
   mv ../*trimmed.fastq .
   rename 's/_trimmed//' *_trimmed.fastq
   ```

2. **Convert the sequences to FASTA**:
   ```bash
   mkdir ../fasta
   for fastq_file in *.fastq; do
     base_name=$(basename "$fastq_file" .fastq)
     awk '(NR%4==1) {print ">"substr($0,2)} (NR%4==2) {print}' "$fastq_file" > "../fasta/${base_name}.fasta"
   done
   cd ../fasta
   ```

## Dereplicating the Samples

1. **Run the third R script**:
   - Copy `. code.dereplicate.txt` to the `fasta` directory in the virtual machine and run it:
     ```bash
     . code.dereplicate.txt
     ```

2. **Create a directory for dereplicated files**:
   ```bash
   mkdir dereplicated
   mv der_*.fasta dereplicated/
   cd dereplicated
   ```

3. **Merge and dereplicate globally**:
   ```bash
   cat der_*.fasta > all-derep.fasta
   vsearch --derep_fulllength all-derep.fasta --sizein --sizeout --fasta_width 0 --output dereplicated_global.fasta > /dev/null
   ```

## SWARM Clustering

1. **Run SWARM clustering with denoising (d=3)**:
   ```bash
   screen -S swarm_analysis
   ../../../programs/swarm/bin/swarm -d 3 -z -t 80 -i swarm_d3.struct -s amplicons_d3.stats -w swarm_REPRESENTATIVES_d3.fasta -o amplicons_d3.swarms dereplicated_global.fasta
   ```

2. **Detach the screen**:
   ```bash
   ctrl + a + d
   ```

3. **Check the number of swarms**:
   ```bash
   screen -r swarm_analysis
   ```

## Chimera Detection and Preparation of SWARM (OTU) Table

1. **Make a fake quality file**:
   ```bash
   awk 'BEGIN {FS = "[>;_]"} {if (/^>/) {printf $2"\t0.0002\t"} else {printf "%d\n", length($1)} }' swarm_REPRESENTATIVES_d3.fasta > coolproject.assembled_d3.qual
   ```

2. **Sort OTU representatives**:
   ```bash
   vsearch --fasta_width 0 --sortbysize swarm_REPRESENTATIVES_d3.fasta --output representatives_d3.fas
   ```

3. **Make a chimera check file**:
   ```bash
   vsearch --uchime_denovo representatives_d3.fas --uchimeout representatives_d3.uchime --threads 80
   ```

4. **Make a fake taxonomic assignment file**:
   ```bash
   grep "^>" swarm_REPRESENTATIVES_d3.fasta | \
       sed 's/^>//
            s/;size=/\t/
            s/;$/\t100.0\tNA\tNA/' > representatives_d3.results
   ```

5. **Generate the OTU contingency table**:
   ```bash
   conda activate py2
   python ../../../scripts/OTU_contingency_table.py representatives_d3.fas amplicons_d3.stats amplicons_d3.swarms representatives_d3.uchime coolproject.assembled_d3.qual representatives_d3.results der_*.fasta > swarms_table.txt
   ```

6. **Save the resulting files**:
   - `swarms_table.txt`
   - `representatives_d3.fas`

7. **Close both MobaXterm and RStudio programs**.

---

[Previous Lesson](../lesson6/lesson6.md) | [Next Lesson](../lesson8/lesson8.md)
