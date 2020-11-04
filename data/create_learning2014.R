#Johanna Räbinä
#4.11.2020
#IODS exercise 2 data wrangling part

learning2014 <- read.table("http://www.helsinki.fi/~kvehkala/JYTmooc/JYTOPKYS3-data.txt",  sep = "\t", header = TRUE)
dim(learning2014)
str(learning2014)

# data has 60 variables (as columns) and 183 subjects (as rows)
# most of the variables are measured as likert-type variables with values 1-5

library(dplyr)

#combining the variables

deep_questions <- c("D03", "D11", "D19", "D27", "D07", "D14", "D22", "D30","D06",  "D15", "D23", "D31")
surface_questions <- c("SU02","SU10","SU18","SU26", "SU05","SU13","SU21","SU29","SU08","SU16","SU24","SU32")
strategic_questions <- c("ST01","ST09","ST17","ST25","ST04","ST12","ST20","ST28")

# selecting the columns and scaling the combined variables
deep_columns <- select(learning2014, one_of(deep_questions))
learning2014$deep <- rowMeans(deep_columns)

surface_columns <- select(learning2014, one_of(surface_questions))
learning2014$surf <- rowMeans(surface_columns)

strategic_columns <- select(learning2014, one_of(strategic_questions))
learning2014$stra <- rowMeans(strategic_columns)

learning2014$attitude <- learning2014$Attitude / 10

# making a new subset of the data and erasing the rows in which points is 0
keep_columns <- c("gender","Age","attitude", "deep", "stra", "surf", "Points")
sub_learning2014 <- select(learning2014, one_of(keep_columns))

sub_learning2014 <- filter(sub_learning2014, Points > 0)
str(sub_learning2014)

# seeing whether the working directory is IODS project folder, and noticing it is

getwd()
dir()

# saving the new subset of data for the analysis
write.csv(sub_learning2014, file = "data/Learning2014_SUBSET.csv", row.names = FALSE)
sub_learning2014 <- read.csv("data/Learning2014_SUBSET.csv")
str(sub_learning2014)
head(sub_learning2014)
