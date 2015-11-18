##Coursera: Getting and Cleaning Data Course Project

#Prior to running the run_analysis.R code, you must clone the Samsung repo to your computer,
#then set working directory (setwd()) to the Samsung directory

#The run_analysis.R code does the following:
1. Uses read.table() to extract column labels from the features.txt
2. Uses make.names() to format labels into valid column names
3. Uses read.table() to read data from x_train.txt
4. Uses names() to apply column names to x_train data
5. Reads in subject_id and activity_id dataframes and binds them to x_train dataframe
6. Repeats steps3-5 for the x_test.txt dataset.
7. Concatenates the x_train and x_tests data
8. Loads dplyr package and uses select() function to extract variables of interest with the contains argument to obtain variables that represent means and standard deviations (which are conveniently coded into the original variable names)
9. Loads plyr package to use revalue() to give the activity labels meaningful values which were extracted from activity_labels.txt
10. Loads reshape2 package and uses melt() to convert data into long form grouped by subject_id and activity_id
11. Uses dcast(){reshape2} to apply the mean() by subject_id & activity_id groups and recast the data into wide format with each line representing the mean across values for a single subject and single activity.
