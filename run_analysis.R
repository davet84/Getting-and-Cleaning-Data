library(dplyr)
library(reshape2)

##Read data in to tables
x_test <- read.table("./test/X_test.txt")
y_test <- read.table("./test/y_test.txt")
x_train <- read.table("./train/x_train.txt")
y_train <- read.table("./train/y_train.txt")
sub_train <- read.table("./train/subject_train.txt")
sub_test <- read.table("./test/subject_test.txt")
features <- read.table("features.txt")
activity_labels <- read.table("activity_labels.txt")

##1 Merge train and test data sets
merged_x <- rbind(x_test, x_train, sort=F)
merged_y <- rbind(y_test, y_train, sort=F)
merged_sub <- rbind(sub_test, sub_train, sort=F)

colnames(merged_sub)[1] <- "Subject"
colnames(merged_y)[1] <- "Activity"

##2 extracts only mean and std variables
filter_features <- filter(features, grepl('mean|std',V2))
columns <- filter_features[,1]
column_names <-filter_features[,2]
merged_x_meanSTD <- merged_x[,columns]
colnames(merged_x_meanSTD) <- column_names

mergedDATA <- cbind(merged_sub, merged_y, merged_x_meanSTD)

##3/4 use descriptive activity names
mergedDATA2 <- merge(mergedDATA, activity_labels, by.x="Activity", by.y="V1")
mergedDATA2 <- mergedDATA2[,!(names(mergedDATA2) %in% c("Activity"))]
colnames(mergedDATA2)[81] <- "Activity"

##5 creates independent tidy data set with mean of each vraible for each activity and subject.
meanDATA <- melt(mergedDATA2, id=c("Subject", "Activity"), measure.vars=column_names)
meanDATAnew <- dcast(meanDATA, Subject + Activity ~ variable, mean)

write.table(meanDATAnew, './tidydata.txt', row.name=FALSE)
