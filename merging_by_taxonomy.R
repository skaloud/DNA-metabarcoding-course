#Load data
data = read.csv2(file="taxonomy.csv", header=T)
df = data[,-1] #delete the Taxonomy column

taxa <- data$Taxonomy

#Sum by taxonomy
sumtax <- aggregate(df, by=list(taxa), FUN = sum)

write.csv2(sumtax, file = "sumtax.csv")
