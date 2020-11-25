# Johanna Räbinä
# This is a script of wrangling the human-data for the future exercises
# Original data from http://hdr.undp.org/en/content/human-development-index-hdi

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
  Mat.mor = Maternal.Mortality.Ratio,
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

###

# Week 5: Continuing the wrangling and checking that everything is ok with the data

str(human)
dim(human)

# The human-data has 195 observations (countries) and 19 variables. 

# "Country" = Country name

# Indexes and ranks

# "HDI" = human development index (consisting of )
# "HDI.Rank" = rank of the countries based on HDI
# "GII" = gender inequality index
# "GII.Rank" = rank of the countries based on GII
# "GNI_HDI.Rank = rank of the countries based on GNI and HDI

# Health and knowledge

# "GNI" = Gross National Income per capita
# "Life.exp" = Life expectancy at birth
# "Edu.exp" = Expected years of schooling 
# "Edu.mean" = Mean years of schooling
# "Mat.mor" = Maternal mortality ratio
# "Ado.BR" = Adolescent birth rate

# Empowerment

# "Parl.rep" = Percetange of female representatives in parliament
# "F.2edu" = Proportion of females with at least secondary education
# "M.2edu" = Proportion of males with at least secondary education
# "F.lab" = Proportion of females in the labour force
# "M.lab" " Proportion of males in the labour force

# "eduratio" = F.2edu / M.2edu
# "labratio" = F.lab / M.lab

# The variables are mostly integer and numeric, but there are also two character variables at this point, "Country" and "GNI".


# Mutating variable GNI from character to numeric

library(stringr)
human$GNI<- str_replace(human$GNI, pattern=",", replace ="") %>% as.numeric

str(human) # the mutation succeeded

# Excluding unnecessary variables

keep <- c("Country","eduratio","labratio","Edu.exp","Life.exp","GNI","Mat.mor","Ado.BR","Parl.rep")
human <- dplyr::select(human, one_of(keep))
str(human) # all good

# Removing the rows with missing values

data.frame(human[-1], comp = complete.cases(human))
human <- filter(human, complete.cases(human) == TRUE)
complete.cases(human) # removing succeeded

# Removing observations that relate to regions not countries

human$Country # from this list of Country names I see that 7 of the last "countries" are actually regions
last <- nrow(human) - 7
human <- human[1:last, ]


tail(human) # the observations related to reagions are now gone

# Defining row names of the data by the countries and removing the country name column

rownames(human) <- human$Country
human <- select(human, -Country)
head(human)
dim(human) # 155 observations and 8 variables, so everything ok!

write.csv(human, file = "data/human.csv", row.names = rownames(human))
human <- read.csv("data/human.csv", row.names = 1)
dim(human)
head(human) # Still 155 observations and 8 variables, perfect!

# I first had trouble having the rownames correctly when reading the data (R thought that the rownames where a variable), but I googled and got it done, yei!