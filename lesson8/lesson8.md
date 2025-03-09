# Lesson 8: Preparing the Swarm Table and BLAST Searches

This lesson provides detailed instructions for preparing the swarm table and performing BLAST searches, including identifying species of interest, processing replicates, extracting green algal amplicons, aligning sequences, inferring phylogenetic trees, and creating taxonomic assignments.

## Preparing the Swarm Table

1. **From the previous step, we have two tables**:
   - `swarms_table.txt`: The main table storing all data on swarms
   - `representatives_d3.fas`: Swarm sequences in FASTA format

2. **Open the swarms table in Excel**:
   - Import the table as a tab-delimited file and save it as an xlsx file.
   - Delete unnecessary columns (cloud, abundance, spread, quality, identity, taxonomy, reference).

3. **Open the FASTA file in Notepad**:
   - Replace `;size=` with `_size_` and delete all `;` symbols; save the file.

4. **Filter the FASTA file**:
   - Make a copy of the FASTA file and delete all sequences with an abundance (size) less than 100. Save the file as `representatives_d3_min100.fas`.
   - In our case, 219 sequences (swarms) remained.

## BLAST Searches

1. **Run the program by executing Seed2.exe**:
   - File – Open FASTA file – select the `representatives_d3_min100.fas` file.
   - Click "Show and Edit Sequences".

2. **Perform BLAST searches**:
   - Identification – NCBI Blast
   - BLAST – Run BLAST (settings)
     - In Parameters, change the number of Tasks to 20 to speed up the searches.
     - Leave the other settings as is.
     - Click RUN (removes previous results).
   - Automatic BLAST searches will begin.
   - Disable automatic updates and sleeping mode, and save the BLAST results once per day to avoid loss of results.
   - After all BLAST searches are done, the message "Blast is done" will appear.
   - To save the BLAST results, click on Table – Get table - best hit – Save as...
   - Import the best hit table into Excel as a tab-delimited table.
     - Keep the columns SEQ TITLE, Accession, Description, Similarity, and Coverage, and save the file as `SEED_results.xlsx`.

## Identify Species of Interest

1. **Open the swarms_table**:
   - Hide rows with reads having an abundance (column total) less than 100.
   - Sort the remaining sequences by the "amplicon" column.

2. **Open the SEED_results table**:
   - Sort the rows by SEQ TITLE.
   - Paste all the SEED_results columns into the swarms_table. Ensure the amplicon codes match.
   - Sort the table by the "Description" column to organize BLAST results.
   - Identify species of interest or make taxonomic assignments based on the BLAST results.
     - In this course, identify all green algae (taxa of interest) and mark the rows accordingly, e.g., by including a "green algae" column where the assignment is given.

3. **Use Similarity and Coverage values for identification**:
   - For ITS rDNA, coverage values usually mean the following:
     - 80 and more: well-identified species
     - 70-80: related species, but also chimeras and pseudogenes
   - It is recommended to select sequences with low coverage and test their assignment phylogenetically.

4. **Select sequences belonging to the group of interest**:
   - Hide other rows.
   - In our case, 70 swarms remained.
   - Check negative controls for the presence of reads with an abundance higher than 10. Subtract their abundance by this value (in this course, the highest sum of negative controls is 14).
   - Remove chimeras. Here, we have just two swarms detected as chimeras.

## Process the Replicates

1. **Each sample was sequenced in two replicates**:
   - To avoid putative contaminants, only those swarms detected in both replicates were further processed.
   - Select the samples in both replicates (a total of 16 columns) along with column names, and copy them to a new list. Save as a tab-delimited csv file `2rep.csv`.

2. **Open the `comparing_replicates.R` file**:
   - Run the first script to compare two replicates. As a result, the file `1rep.csv` is generated, keeping only those swarms obtained in both replicates and outputting the highest value from both replicates.
   - Inspect the output file to ensure the table was generated correctly.

3. **Update the main table**:
   - Copy the table of green algal swarms to a new list in the Excel table, replace the replicates by the newly generated table of single replicates.
   - Summarize the abundances of all samples, sort the swarms by their total abundances, and remove those swarms with zero abundances (i.e., those obtained only in one of two replicates).
   - In our case, we removed 15 swarms, retaining 53 green algal swarms occurring in both replicates.
   - Save the table as `swarms_table.xlsx`.

## Extract the Green Algal Amplicons

1. **Copy the "amplicon" column to a new list**:
   - Save as a tab-delimited csv table `amplicons.csv`.

2. **Open the `selection_of_sequences.R` script**:
   - Use the script to extract the sequences of selected green algal swarms from the alignment of all sequences.
   - As a result, the FASTA file `selected.fas` is generated. In our case, the file contains 53 selected sequences of green algae.

3. **Download reference sequences from NCBI**:
   - Open the NCBI database: [NCBI Nucleotide](https://www.ncbi.nlm.nih.gov/)
   - Select Nucleotide from the selection, and paste all Accessions in the 1rep excel list to the query field.
   - In our case, 44 accessions are resulted.
   - Download the reference sequences by Send to – File – Format: FASTA – Create file. Save.
   - Check the sequences for their origin. In our case, BLAST resulted in two chromosome sequences, which should be deleted (OZ110890 and AC277064) and replaced by ITS rDNA references (LR872707, OQ873197).
   - Add the reference sequences to the selected amplicon sequences and save.

## Align the Sequences and Infer the Phylogenetic Tree

1. **Access the MAFFT web server**: [MAFFT](https://mafft.cbrc.jp/alignment/server/index.html)
   - Select the file with selected amplicon sequences and reference GenBank sequences.
   - Under Advanced settings, select G-INS-I strategy.
   - Submit.
   - Ensure there are no blue lines in LAST hits plots.
   - After computing, download the alignment in Fasta format.

2. **Open the alignment in MEGA**:
   - Delete the nucleotide positions outside the region used in DNA metabarcoding, save by Data – Export Alignment – FASTA Format.
   - Copy the fasta file into the “bin” folder in IQ tree.

3. **Infer the ML tree**:
   - Open the command line and run:
     ```bash
     iqtree -s selected_ncbi_mafft2.fas -st DNA -m GTR -bb 1000 -redo
     ```
   - Copy the treefile back to the working folder, open it in FigTree.
   - Select Tree – Midpoint Root and Tree – Increasing Node Order.
   - Tick the box Node Labels, select Display – label to show the bootstraps.
   - Save to PDF by File – Export PDF.
   - Check the phylogeny for the presence of long branches without reference sequences. If present, check the sequences in FASTA for putative chimeric origin.

## Create the Taxonomic Assignment

1. **Define the taxa according to the inferred phylogenetic tree**:
   - In the `swarms_table`, 1rep list, create a new column “Taxonomy” and assign each swarm to the taxon based on the phylogenetic analysis. In large datasets, it is useful to sort the table according to Description as it is probable many swarms are correctly determined by BLAST hits.

2. **Create a new list “Taxonomy”**:
   - Copy there the abundances of all samples and the Taxonomy column, which should be the first column. Save as a tab-delimited table `taxonomy.csv`.

3. **Open the `merging_by_taxonomy.R` script**:
   - Use the script to merge swarms identified to belong to the same species.
   - As a result, the `sumtax.csv` table is generated. This is the final taxonomic table presenting abundances of each taxon in a given sample. In our case, we identified a total of 39 taxa of green algae in the soil of arctic samples.
   - You can paste the table into the swarms table to store all steps of the analysis, and save it as an xlsx table.

---

[Previous Lesson](../lesson7/lesson7.md)
