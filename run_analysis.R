##Coursera: Getting and Cleaning Data Course Project
# Full description of the data available at:
url1 <- "http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones"
# Data for the project available at:
url2 <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

setwd("~/Box Sync/Coursera/Samsung") #after cloning Samsung repo from Github, setwd()
download.file(url2, destfile = "run_data.zip", method = "curl") #download data file.  method = "curl" needed for Mac and https:\\ (not for http:\\)
date.Downloaded <- date()
train <- read.table(file = "./UCI HAR Dataset/train/X_train.txt", sep = "", header = F)
test <- read.table(file = "./UCI HAR Dataset/test/X_test.txt", sep = "", header = F)
run_analysis <- rbind(test, train)
