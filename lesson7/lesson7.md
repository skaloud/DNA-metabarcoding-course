# Lesson 7: DNA Metabarcoding Data Analysis - Demultiplexing and Clustering

While in the previous analysis we processed individual sequencing libraries and replicates, here we will analyze data belonging to a single study, which may come from multiple sequencing runs (replicates).

- The aim is to process data on the diversity of green algae in the soil of different regions of Europe.
- We will work with a total of 64 samples, including NC (4x) and MPC (5x), in two replicates: REP1 and REP2.
- Keep in mind that for the purposes of this course, we work only with a subset of reads, but the workflow is identical to a full dataset.

## Copying and Renaming FASTQ Files

1. **Prepare the Analysis Environment**

   Access your virtual machine and create a working directory for the green algae dataset:
   ```bash
   mkdir /home/ubuntu/analysis_green_algae
   cd /home/ubuntu/analysis_green_algae
   ```

2. **Export the Barcode Table**

   On your local machine:
   - Open `barcodes.xlsx`.
   - Export it as CSV UTF‑8 (with delimiters) — this ensures the file uses semicolons (;) and UTF‑8 encoding.
   - Upload the resulting `barcodes.csv` into /home/ubuntu/analysis_green_algae

3. **Clean the CSV File**:

   Excel often adds a UTF‑8 BOM and Windows-style line endings. Clean the file using:
   ```bash
   sed 's/\r$//' barcodes.csv | sed '1s/^\xEF\xBB\xBF//' > barcodes_clean.csv
   ```

4. **Define Paths and Input File**:

   Inside your analysis directory, define paths to input fastq files and to the cleaned .csv file:
   ```bash
   sample_path="green_algae/fastq"
   input="barcodes_clean.csv"
   ```

5. **Generate Copy Commands (Dry Run)**:

   Before copying anything, print the commands to verify that paths and filenames are correct:
   ```bash
   while IFS=';' read -r sample info library primerF primerR; do
    [[ "$sample" == "sample" ]] && continue

    src="../$library/$sample_path/${primerR}_${primerF}.fastq"
    dest="${sample}_${library}.fastq"

    echo cp "$src" "$dest"
   done < "$input"
   ```

   Check the output carefully — it should list all expected cp commands for RUN1 and RUN2.

6. **Copy Files**:

   Once the dry run looks correct, remove "echo" in the script and run. This will copy and rename all FASTQ files according to the barcode table:
   ```bash
   while IFS=';' read -r sample info library primerF primerR; do
    [[ "$sample" == "sample" ]] && continue

    src="../$library/$sample_path/${primerR}_${primerF}.fastq"
    dest="${sample}_${library}.fastq"

    cp "$src" "$dest"
   done < "$input"
     ```
   Check the sizes of files. Both MPC and NC samples should be of small size if the sequencing run and no major contamination occurred.

## Removing Primers and Labels

1. **Calculate the number of bases to remove**:
   - Forward: `3 + 8 + 20 = 31`
   - Reverse: `3 + 8 + 20 = 31`

2. **Remove primers and labels using cutadapt**:

   Use the following loop to trim 31 bp from the 5′ end and 31 bp from the 3′ end of each read:
    ```bash
     for f in *.fastq; do 
   base=${f%.fastq};
   cutadapt -u 31 -u -31 -o "${base}_trimmed.fastq" "$f"; 
   done
     ```

## Converting to FASTA Format

1. **Create a new folder for trimmed sequences**:
   ```bash
   mkdir fastq
   cd fastq
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

1. **Run the following loop to dereplicate every .fasta file in the directory:**:
     ```bash
     for f in *.fasta; do
     base=${f%.fasta}
     vsearch --quiet --derep_fulllength "$f" \
            --sizeout \
            --fasta_width 0 \
            --relabel_sha1 \
            --output "der_${base}.fasta"
     done
     ```

   What this script does:
   - `--derep_fulllength` : Collapses identical sequences into unique entries.
   - `--sizeout` : Adds a `;size=X;` annotation showing how many times each sequence occurred.
   - `--fasta_width 0` : Writes sequences in a single line (no wrapping), which is required by many tools.
   - `--relabel_sha1` : Assigns each unique sequence a reproducible SHA‑1 hash identifier.
   - Output files are saved as: `der_<originalname>.fasta`


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
   swarm -d 3 -z -t 80 -i swarm_d3.struct -s amplicons_d3.stats -w swarm_REPRESENTATIVES_d3.fasta -o amplicons_d3.swarms dereplicated_global.fasta
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

7. **Close the MobaXterm program**.

---

[Previous Lesson](../lesson6/lesson6.md) | [Next Lesson](../lesson8/lesson8.md)
