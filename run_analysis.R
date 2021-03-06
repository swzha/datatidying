
##Reading Sets
testSet <- read.csv("test/X_test.txt", sep = "", header = FALSE)
trainSet <- read.csv("train/X_train.txt", sep = "", header = FALSE)
mergedData <- rbind(testSet, trainSet)

##Reading Activity labels
testLabels <- read.csv("test/y_test.txt", sep = "", header = FALSE)
trainLabels <- read.csv("train/y_train.txt", sep = "", header = FALSE)
mergedLabels <- rbind(testLabels, trainLabels)

##Reading Volunteers' identifiers
testVolunteers <- read.csv("test/subject_test.txt", sep = "", header = FALSE)
trainVolunteers <- read.csv("train/subject_train.txt", sep = "", header = FALSE)
mergedVolunteers <- rbind(testVolunteers, trainVolunteers)

##Reading Features and ActivityLabels vector
features <- read.csv("features.txt", sep = "", header = FALSE)[2]
activities <- read.csv("activity_labels.txt", sep = "", header = FALSE)

##Extracting columns which includes measurements
names(mergedData) <- features[ ,1]
mergedData <- mergedData[grepl("std|mean", names(mergedData), ignore.case = TRUE)]

##Descriptive Activity name analysis
library(dplyr)
mergedLabels$id <- 1: nrow(mergedLabels)
merged <- merge(x=mergedLabels, y=activities, by.x = "V1", by.y = "V1", all.x =TRUE)
ordered <- merged[order(mergedLabels$id),]
df <- arrange(ordered, id)
Labels <- df[, 3]

mergedData <- cbind(Labels, mergedVolunteers, mergedData)
names(mergedData)[1:2] <- c("Activities", "VolunteerID")

##Tidying mergedSet
tidyData <-  group_by(mergedData, Activities, VolunteerID) %>%
         summarise_each(funs(mean))
write.table(tidyData, "tidy_data.txt", row.name=FALSE, col.name=FALSE)
write.csv(tidyData, "tidy_data.csv")