# Getting and Cleaning Data Course Project 

The purpose of this project is to demonstrate your ability to collect, work with, and clean a data set. The goal is to prepare tidy data that can be used for later analysis. You will be graded by your peers on a series of yes/no questions related to the project. You will be required to submit: 
1. a tidy data set as described below, 
2. a link to a Github repository with your script for performing the analysis, and 
3. a code book that describes the variables, the data, and any transformations or work that you performed to clean up the data called CodeBook.md. 
4. a README.md in the repo with your scripts. This repo explains how all of the scripts work and how they are connected.

One of the most exciting areas in all of data science right now is wearable computing - see for example this article . Companies like Fitbit, Nike, and Jawbone Up are racing to develop the most advanced algorithms to attract new users. The data linked to from the course website represent data collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at the site where the data was obtained:

http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

Here are the data for the project:

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

You should create one R script called run_analysis.R that does the following.

Merges the training and the test sets to create one data set.
Extracts only the measurements on the mean and standard deviation for each measurement.
Uses descriptive activity names to name the activities in the data set
Appropriately labels the data set with descriptive variable names.
From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.


# Code Explanations

Same read format was applied to all files. sep="" reflected all given files' format. And also header=FALSE, just don't want to lose first row of data. If its true, first row would be column names which we don't want to. 
Reads two test and train files from UCI HAR Dataset and combine them with **rbind** function:
``` 
##Reading Sets
testSet <- read.csv("test/X_test.txt", sep = "", header = FALSE)
trainSet <- read.csv("train/X_train.txt", sep = "", header = FALSE)
mergedData <- rbind(testSet, trainSet)
```
Then we read two activity label files. 
```
##Reading Activity labels
testLabels <- read.csv("test/y_test.txt", sep = "", header = FALSE)
trainLabels <- read.csv("train/y_train.txt", sep = "", header = FALSE)
mergedLabels <- rbind(testLabels, trainLabels)
```
Read subjects (volunteer IDs) files and **merge** all rows.
```
##Reading Volunteers' identifiers
testVolunteers <- read.csv("test/subject_test.txt", sep = "", header = FALSE)
trainVolunteers <- read.csv("train/subject_train.txt", sep = "", header = FALSE)
mergedVolunteers <- rbind(testVolunteers, trainVolunteers)
```
The **features** file is read to introduce all coloumn names for test and train sets. The **activity_labels** file contains the id and value of 6 activitieis. 
```
##Reading Features and ActivityLabels vector
features <- read.csv("features.txt", sep = "", header = FALSE)[2]
activities <- read.csv("activity_labels.txt", sep = "", header = FALSE)
```
Regular expression is used to extract only the measurements on the **mean** and **standard** deviation for each measurement. 
```
##Extracting columns which includes measurements
names(mergedData) <- features[ ,1]
mergedData <- mergedData[grepl("std|mean", names(mergedData), ignore.case = TRUE)]
```
This inserts two columns into the biginning of final dataset. Both will be used to **group** the data.
```
##Descriptive Activity name analysis
library(dplyr)
mergedLabels$id <- 1: nrow(mergedLabels)
merged <- merge(x=mergedLabels, y=activities, by.x = "V1", by.y = "V1", all.x =TRUE)
ordered <- merged[order(mergedLabels$id),]
df <- arrange(ordered, id)
Labels <- df[, 3]
mergedData <- cbind(Labels, mergedVolunteers, mergedData)
names(mergedData)[1:2] <- c("Activities", "VolunteerID")
```
Group the data according to activities and volunteer IDs. A tidying set in txt file is created with **write.table()** using row.names=FALSE.
```
##Tidying mergedSet
tidyData <-  group_by(mergedData, Activities, VolunteerID) %>%
         summarise_each(funs(mean))
write.table(tidyData, "tidy_data.txt", row.name=FALSE, col.name=FALSE)
write.csv(tidyData, "tidy_data.csv")
```
