##Coursera: Getting and Cleaning Data Course Project

# Full description of the data available at:
url1 <- "http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones"
# Data for the project available at:
url2 <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

#after cloning Samsung repo from Github, setwd()
#setwd("~/Box Sync/Coursera/Samsung") #I work from 2 computers, Mac and PC, so always set 2 directories
setwd("C:/Users/jkempke/Box Sync/Coursera/Samsung")

#download data file.  method = "curl" needed for Mac and https:\\ (not for http:\\)
download.file(url2, destfile = "run_data.zip", method = "curl") 
date.Downloaded <- date()

#Extract column labels.  Use make.names() to generate valid column names from character strings
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

#want to select teh columns that represent means and standard deviations.  
#the contains argument of the select() of dplyr allows to extract column headings of interest.
#remember to keep activity_id and subject_id!
run_analysis3 <- select(run_analysis2, subject_id, activity_id, contains("mean", ignore.case = TRUE))
run_analysis4 <- select(run_analysis2, subject_id, activity_id, contains("std", ignore.case = TRUE))
run_analysis5 <- cbind(run_analysis3, run_analysis4)

#the plyr package has the revalue() function that allows easy revaluing of factor values
#beware that loading plyr will suppress some dplyr functions!
install.packages("plyr")
library(plyr)
#make activity_id from an integer into a factor
run_analysis5$activity_id <- as.factor(run_analysis5$activity_id)
#Use revalue() to give activities meaningful names.
run_analysis5$activity_id <- revalue(run_analysis5$activity_id, c('1'="Walking", 
    '2'="Walking Upstairs", '3'="Walking Downstairs", '4'="Sitting", '5'="Standing", '6'="Laying"))

#I want to save this R dataframe so I don't have to rebuild it next time
write.csv(run_analysis5, "run_analysis.csv", row.names = FALSE)
#Now to create a separate dataset with average of each variable for each activity and each subject


