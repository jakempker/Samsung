##Coursera: Getting and Cleaning Data Course Project

##The below steps do not need to be repeated since all files are already in Samsung repo
##and will be in working directory once the Samsung repo is cloned.
#setwd("~/Box Sync/Coursera/Samsung") #I work from 2 computers, Mac and PC, so always set 2 directories
#setwd("C:/Users/jkempke/Box Sync/Coursera/Samsung")
#download data file.  method = "curl" needed for Mac and https:\\ (not for http:\\)
#download.file(url2, destfile = "run_data.zip", method = "curl") 
#date.Downloaded <- date()

# Full description of the data available at:
url1 <- "http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones"
# Data for the project available at:
url2 <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

#Clone the Samsung repo then setwd() to this repo
# this repo  can be found at: "https://github.com/jkempker/Samsung"

#Extract column labels from 'features.txt' file.  
#Use make.names() to generate valid column names from character strings
labels <- read.table(file= "./UCI HAR Dataset/features.txt", sep = "", stringsAsFactors = F)
labels <- make.names(labels$V2, unique = TRUE)

#Create train set from subject_id, activity_id and data.  
train_data <- read.table(file = "./UCI HAR Dataset/train/X_train.txt", sep = "", header = F)
#Apply column names to data.  Use col.names of read.table() to name other sets.
names(train_data) <- labels
train_subject <- read.table(file= "./UCI HAR Dataset/train/subject_train.txt", col.names = "subject_id")
train_activity <- read.table(file= "./UCI HAR Dataset/train/y_train.txt", col.names = "activity_id")

    train <- cbind(train_subject, train_activity, train_data)

#Repeat for the second set of data.
test_data <- read.table(file = "./UCI HAR Dataset/test/X_test.txt", sep = "", header = F)
names(test_data) <- labels
test_subject <- read.table(file="./UCI HAR Dataset/test/subject_test.txt", col.names = "subject_id")
test_activity <- read.table(file="./UCI HAR Dataset/test/y_test.txt", col.names = "activity_id")
    
    test <- cbind(test_subject, test_activity, test_data)

#now concatenate both datasets (they should have same column names!)    
run_analysis <- rbind(test, train)

#dplyr helpful for its data manipulation functions
#install.packages("dplyr")
#library(dplyr)

run_analysis2 <- tbl_df(run_analysis) #tbl_df just helps with printing

run_analysis2 <- arrange(run_analysis2, subject_id, activity_id)

#want to select the columns that represent means and standard deviations.  
#the contains argument of the select() of dplyr allows to extract column headings of interest.
#remember to keep activity_id and subject_id!
run_analysis3 <- select(run_analysis2, subject_id, activity_id, contains("mean", ignore.case = TRUE))
run_analysis4 <- select(run_analysis2, subject_id, activity_id, contains("std", ignore.case = TRUE))
run_analysis5 <- cbind(run_analysis3, run_analysis4)

#the plyr package has the revalue() function that allows easy revaluing of factor values
#beware that loading plyr will suppress some dplyr functions!
#install.packages("plyr")
library(plyr)
#make activity_id from an integer into a factor
run_analysis5$activity_id <- as.factor(run_analysis5$activity_id)
#Use revalue() to give activities meaningful names.
run_analysis5$activity_id <- revalue(run_analysis5$activity_id, c('1'="Walking", 
    '2'="Walking Upstairs", '3'="Walking Downstairs", '4'="Sitting", '5'="Standing", '6'="Laying"))

#Now I want to reshape the data.
#the reshape2 package has some great functions for this
library(reshape2)

#melt() will all you to set id variables and measurment variables
#if the measure.vars argument is unspecified (like below) it uses all non-id vars as default
run <- melt(run_analysis5, id.vars = 1:2 )
#Once melted into this LONG format, can now recast the dataset with a function
#dcast() specifies the dataframe and then the formula.
#Everything on left side of formula specifies the unique groups over which aggregate measures will be calculated
#Everything on right side of formula specifies measurement variables to aply function to
#the '...' is a special variable that mean ALL OTHER variables.
run1 <- dcast(run, subject_id + activity_id ~ ..., mean)

write.table(run1, file = "./run_analysis.txt", row.name=FALSE)

#To extract the code from this text file
#run2 <- read.table("./run_analysis.txt", stringsAsFactors = FALSE, header = TRUE)

