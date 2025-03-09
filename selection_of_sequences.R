setwd(getwd())

########## extrakce sekvenci ##########

library(phytools)
data <- read.csv2("amplicons.csv", head = T)
OTU <- data$amplicon

align <- read.FASTA("representatives_d3.fas")
names <- substr(names(align), 0, 40)
m  <- which(names %in% OTU)
sel <- align[m]

write.FASTA(sel, file = "selected.fas")

