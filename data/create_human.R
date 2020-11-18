
# Reading the data to R

hd <- read.csv("http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/human_development.csv", stringsAsFactors = F)

gii <- read.csv("http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/gender_inequality.csv", stringsAsFactors = F, na.strings = "..")

# Let's see the structure and dimensions of Human development -data and look at the summaries of the variables:
str(hd)
dim(hd)
summary(hd)
colnames(hd)

# Human development -data has 8 variables and 195 observations (countries). Data includes information about the developmental position of the countries. The order of the countries in the data seems to go from "most developed" to "least developed". Variables are integers, characters or numbers. 

# Let's see the structure and dimensions of Gender inequality -data and look at the summaries of the variables:
str(gii)
dim(gii)
summary(gii)
colnames (gii)

# Gender inequality -data has 10 variables and 195 observations (same countries as Human development -data). Data includes information about lifes of men and women separately, so it makes it possible to compare the two sexes and their equality. Variables are integers, characters or numbers.

# accessing dplyr -library to wrangle data
library(dplyr)

# renaming the long-named columns of hd

hd <- hd %>% rename(
  HDI = Human.Development.Index..HDI.,
  Life.exp = Life.Expectancy.at.Birth,
  Edu.exp = Expected.Years.of.Education,
  Edu.mean = Mean.Years.of.Education,
  GNI = Gross.National.Income..GNI..per.Capita,
  GNI_HDI.Rank = GNI.per.Capita.Rank.Minus.HDI.Rank
  )

# renaming the long-named columns of gii

gii <- gii %>% 
rename(
  GII = Gender.Inequality.Index..GII.,
  Ado.BR = Adolescent.Birth.Rate,
  F.2edu = Population.with.Secondary.Education..Female.,
  F.lab = Labour.Force.Participation.Rate..Female.,
  Mat.mor. = Maternal.Mortality.Ratio,
  Parl.rep = Percent.Representation.in.Parliament,
  M.2edu = Population.with.Secondary.Education..Male.,
  M.lab = Labour.Force.Participation.Rate..Male.
)
  
# adding two new columns "eduratio" and "labratio" to gii

gii <- mutate (gii, eduratio = F.2edu / M.2edu)

gii <- mutate (gii, labratio = F.lab / M.lab)


# joining hd and gii -datasets using variable Country

human <- inner_join(hd, gii, by = "Country")

# Checking that everything is in order after joining and after saving. Looks ok!

head(human)
str(human)
dim(human)

write.csv(human, file = "data/human.csv", row.names = FALSE)
human <- read.csv("data/human.csv")
str(human)
