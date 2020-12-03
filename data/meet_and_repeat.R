# Data wrangling week 6
# Johanna Räbinä
# 2.12.2020

# accessing the necessary libraries
library(dplyr)
library(tidyr)

# loading the datasets to R

BPRS <- read.table("https://raw.githubusercontent.com/KimmoVehkalahti/MABS/master/Examples/data/BPRS.txt", sep  =" ", header = T)
RATS <- read.table("https://raw.githubusercontent.com/KimmoVehkalahti/MABS/master/Examples/data/rats.txt", header = TRUE, sep = '\t')

# exploring the datasets

str(BPRS)
head(BPRS)
summary(BPRS)

str(RATS)
head(RATS)
summary(RATS)

# All the variables in the two datasets are type integer. In both datasets, the target variable is measured many times. The wide form of the data means that there are as many rows as there are subjects, and each measurement of the target variable has its own column. In the long form of the data there are the amount of subjects x measurements rows and only one column for the target variable. In wide form, it is easy to see e.g. from the summaries of the variables, how the values of the target variable develop over time (e.g. BPRS values seem to decrease over time, rat weight values seem to increase over time).

# converting categorical variables to factors

BPRS <- BPRS %>% mutate(treatment = as.factor(BPRS$treatment)) %>% mutate(subject = as.factor(BPRS$subject))
str(BPRS)

RATS <- RATS %>% mutate(ID = as.factor(RATS$ID)) %>% mutate(Group = as.factor(RATS$Group))
str(RATS)

# converting the datasets to long form

BPRSL <-  BPRS %>% 
  gather(key = weeks, value = bprs, -treatment, -subject)

RATSL <- RATS %>%
  gather(key = WD, value = Weight, -ID, -Group) 

# adding week variable to BPRSL

BPRSL <- BPRSL %>% mutate(week = as.integer(substr(BPRSL$weeks,5,5)))

# adding Time variable to RATSL

RATSL <- RATSL %>% mutate(Time = as.integer(substr(WD,3,4)))

glimpse(BPRSL)
head(BPRSL)
summary(BPRSL)

glimpse(RATSL)
head(RATSL)

# Long form puts all the measurements of the target variable to the same column. So, each measurement of each subject has its own row. From the summary of the variables it is not possible to directly evaluate the changes in the target variable over time (as it was with the wide form). 

write.csv(BPRSL, file = "data/BPRSL.csv", row.names = T)
BPRSL <- read.csv("data/BPRSL.csv", row.names = 1)
head(BPRSL)

write.csv(RATSL, file = "data/RATSL.csv", row.names = T)
RATSL <- read.csv("data/RATSL.csv", row.names = 1)
head(RATSL)

# it looks like I managed to write the files correctly