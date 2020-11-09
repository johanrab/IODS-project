#Johanna Räbinä
#9.11.2020
#Data wrangling exercise 3
#Data from UCI Machine Learning Repository: https://archive.ics.uci.edu/ml/datasets/Student+Performance

#Reading both file into R and exploring the data
por <- read.table("data/student-por.csv", sep = ";", header = TRUE)
math <- read.table("data/student-mat.csv", sep = ";", header = TRUE)

dim(por)
dim(math)
str(por)
str(math)

#Both data have the same variables (33). por has 649 observations, math has 395 observations.

#Joining the two datasets and exploring the joined dataset
library(dplyr)
join_by <- c("school", "sex", "age", "address", "famsize", "Pstatus", "Medu", "Fedu", "Mjob", "Fjob", "reason", "nursery","internet")
math_por <- inner_join(math, por, by = join_by, suffix = c(".math", ".por"))

dim(math_por)
str(math_por)

#math_por has 382 observations and 53 variables

#Combining the duplicated answers in the joined data
alc <- select(math_por, one_of(join_by))
notjoined_columns <- colnames(math)[!colnames(math) %in% join_by]

for(column_name in notjoined_columns) {
  two_columns <- select(math_por, starts_with(column_name))
  first_column <- select(two_columns, 1)[[1]]
  
  if(is.numeric(first_column)) {
    alc[column_name] <- round(rowMeans(two_columns))
  } else { 
    alc[column_name] <- first_column
  }
}

# Creating new columns alc_use and high_use
alc <- mutate(alc, alc_use = (Dalc + Walc)/2)
alc <- mutate(alc, high_use = alc_use > 2)

#Seeing whether everything is ok and saving the data
glimpse(alc)

write.csv(alc, file = "data/alc.csv", row.names = FALSE)
alc <- read.csv("data/alc.csv")
str(alc)
head(alc)
#Everything looks ok!