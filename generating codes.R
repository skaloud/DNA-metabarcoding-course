### 1. copy files and rename ###

#Load table
library(xlsx)
input = read.xlsx("../METABARCODING.xlsx", sheetIndex = 1)
#data of interest
data = input[675:698,c(3,7:21)] ### UPDATE DATA OF INTEREST ! row numbers = excel lines - 1
colnames(data)=c("sample",c(rep(c("library","primerF","primerR"),ncol(data)/3)))
#append the columns
L = lapply(split(as.list(data), names(data)), unlist)
df2 = as.data.frame(L, stringrsAsFactors = FALSE, row.names = NULL)
df3 = na.omit(df2)

# Define the path to the samples
sample_path <- "green_algae/fastq" # DEFINE THE PATH to fastq files, inside the "library name" folder

file_conn <- file("code.copyfiles.txt", "w")
filename_dict <- list()

# Loop through each row of the table
for (i in 1:nrow(df3)) {
  # Extract the row information
  library_name <- df3$library[i]
  sample <- df3$sample[i]
  primerF <- df3$primerF[i]
  primerR <- df3$primerR[i]
  
  # Generate the base filename
  base_filename <- sprintf("%s_%s", sample, library_name)
  
  # Check if the base filename already exists in the dictionary
  if (base_filename %in% names(filename_dict)) {
    # Increment the counter for this base filename
    filename_dict[[base_filename]] <- filename_dict[[base_filename]] + 1
    # Generate the text with the counter
    text <- sprintf("cp ../%s/%s/%s_%s.fastq %s%d.fastq",
                    library_name, sample_path, primerR, primerF, base_filename,
                    filename_dict[[base_filename]])
  } else {
    # Initialize the counter for this base filename
    filename_dict[[base_filename]] <- 1
    # Generate the text without the counter
    text <- sprintf("cp ../%s/%s/%s_%s.fastq %s.fastq",
                    library_name, sample_path, primerR, primerF, base_filename)
  }
  
  # Write the text to the file
  writeLines(text, file_conn)
}
close(file_conn)

library(icesTAF)
dos2unix("code.copyfiles.txt")

### 2. remove primers ###

seqnames = read.table("code.copyfiles.txt")
names <- gsub(".fastq", "", seqnames$V3, fixed = TRUE)

FORWARD <- 31 #set the number of bases to be removed 
REVERSE <- 31 #set the number of bases to be removed

file_conn2 <- file("code.removeprimers.txt", "w")

# Loop through each row of the table
for (j in 1:length(names)) {
  # Extract the row information
  text1 <- sprintf("fastx_trimmer -f %d -i %s.fastq -o %s_t.fastq",
                  FORWARD, names[j], names[j])
  
  text2 <- sprintf("fastx_trimmer -t %d -i %s_t.fastq -o %s_trimmed.fastq",
                  REVERSE, names[j], names[j])
  
  # Print the generated text
  cat(text1, "\n", file = file_conn2)
  cat(text2, "\n", file = file_conn2)
}

dos2unix("code.removeprimers.txt")


### 3. dereplicate ###

file_conn3 <- file("code.dereplicate.txt", "w")

# Loop through each row of the table
for (i in 1:length(names)) {
  # Extract the row information
  text <- sprintf("vsearch --quiet --derep_fulllength %s.fasta --sizeout --fasta_width 0 --relabel_sha1 --output der_%s.fasta",
                  names[i], names[i])
  
  # Print the generated text
  cat(text, "\n", file = file_conn3)
}

dos2unix("code.dereplicate.txt")
