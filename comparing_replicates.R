#2 REPLICATES

#Load data
df = read.csv2(file="2rep.csv", header=T)

#Load function group_and_replace_zeros
group_and_replace_zeros <- function(df) {
  num_cols <- ncol(df)
  
  # Check if the number of columns is even
  if (num_cols %% 2 != 0) {
    stop("Number of columns in the data frame must be even.")
  }
  
  # Create a new data frame to store the modified values
  new_df <- df
  
  # Iterate over every two columns
  for (i in seq(1, num_cols, by = 2)) {
    # Get the column indices for the current group
    col_indices <- c(i, i + 1)
    
    # Iterate over each row
    for (row in 1:nrow(df)) {
      # Check if one of the values is zero
      if (df[row, col_indices[1]] == 0 || df[row, col_indices[2]] == 0) {
        # Replace the other value with zero
        new_df[row, col_indices] <- 0
      }
    }
  }
  
  return(new_df)
}

#New df
derep <- group_and_replace_zeros(df)
#Convert to numeric matrix
DF = as.matrix(as.data.frame(lapply(derep, as.numeric)))

#Load function select_highest
select_highest <- function(DF) {
  num_cols <- ncol(DF)
  new_DF <- DF[, seq(1, num_cols, by = 2)]
  
  for (i in seq(1, num_cols, by = 2)) {
    group_max <- pmax(DF[, i], DF[, i + 1])
    new_DF[, (i + 1)/2] <- group_max
  }
  
  return(new_DF)
}

highest <- select_highest(DF)
write.csv2(highest, file = "1rep.csv")





#3 REPLICATES

#Load data
df = read.csv2(file="3rep.csv", header=T)

#Load function group_and_replace_zeros
group_and_replace_zeros <- function(df) {
  num_cols <- ncol(df)
  
  # Check if the number of columns is a multiple of 3
  if (num_cols %% 3 != 0) {
    stop("Number of columns in the data frame must be a multiple of 3.")
  }
  
  # Create a new data frame to store the modified values
  new_df <- df
  
  # Iterate over every three columns
  for (i in seq(1, num_cols, by = 3)) {
    # Get the column indices for the current group
    col_indices <- c(i, i + 1, i + 2)
    
    # Iterate over each row
    for (row in 1:nrow(df)) {
      # Check if one of the values is non-zero and the others are zero
      if ((df[row, col_indices[1]] != 0 && df[row, col_indices[2]] == 0 && df[row, col_indices[3]] == 0) ||
          (df[row, col_indices[1]] == 0 && df[row, col_indices[2]] != 0 && df[row, col_indices[3]] == 0) ||
          (df[row, col_indices[1]] == 0 && df[row, col_indices[2]] == 0 && df[row, col_indices[3]] != 0)) {
        # Replace all values in the triplet with zero
        new_df[row, col_indices] <- 0
      }
    }
  }
  
  return(new_df)
}

#New df
derep <- group_and_replace_zeros(df)
#Convert to numeric matrix
DF = as.matrix(as.data.frame(lapply(derep, as.numeric)))

# Load function select_highest
select_highest <- function(DF) {
  num_cols <- ncol(DF)
  
  # Check if the number of columns is a multiple of 3
  if (num_cols %% 3 != 0) {
    stop("Number of columns in the data frame must be a multiple of 3.")
  }
  
  # Create a new data frame to store the highest values
  new_DF <- DF[, seq(1, num_cols, by = 3)]
  
  for (i in seq(1, num_cols, by = 3)) {
    group_max <- pmax(DF[, i], DF[, i + 1], DF[, i + 2])
    new_DF[, (i + 2)/3] <- group_max
  }
  
  # Extract the new column names from the original column names
  new_colnames <- sapply(seq(3, num_cols, by = 3), function(i) {
    colname <- colnames(DF)[i]
    sub("_.*", "", colname)
  })
  
  colnames(new_DF) <- new_colnames
  
  return(new_DF)
}

highest <- select_highest(DF)
write.csv2(highest, file = "1rep.csv")
