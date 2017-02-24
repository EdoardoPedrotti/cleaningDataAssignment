library(dplyr)

if (!file.exists("data")) dir.create("data")
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile="./data/UCI HAR Dataset/zipfile.zip")
unzip("./data/UCI HAR Dataset/zipfile.zip",exdir = "data")

activitiesLabels = read.table("./data/UCI HAR Dataset/activity_labels.txt")
activitiesLabels[,2] = as.character(activitiesLabels[,2])

features = read.table("./data/UCI HAR Dataset/UCI HAR Dataset/features.txt")
features[,2] = as.character(features[,2])

meanAndStd = grep(".*mean.*|.*std.*", features[,2])
meanAndStd.names = features[meanAndStd,2]
meanAndStd.names = gsub('-mean','Mean', meanAndStd.names)
meanAndStd.names = gsub('-std', 'Std', meanAndStd.names)
meanAndStd.names = gsub('[-()]','', meanAndStd.names)

train = read.table("./data/UCI HAR Dataset/train/X_train.txt")[meanAndStd]
trainActivities = read.table("./data/UCI HAR Dataset/train/y_train.txt")
trainSubjects = read.table("./data/UCI HAR Dataset/train/subject_train.txt")
train = cbind(trainSubjects, trainActivities, train)

test = read.table("./data/UCI HAR Dataset/test/X_test.txt")[meanAndStd]
testActivities = read.table("./data/UCI HAR Dataset/test/y_test.txt")
testSubjects = read.table("./data/UCI HAR Dataset/test/subject_test.txt")
test = cbind(testSubjects, testActivities, test)

allData = rbind(train, test)
colnames(allData) = c("subject", "activity", meanAndStd.names)

allData$activity = factor(allData$activity, levels = activitiesLabels[,1], labels = activitiesLabels[,2])
allData$subject = as.factor(allData$subject)

allData = allData %>% group_by(subject, activity)
allDataMean = allData %>% summarize_each(funs(mean))

write.table(allDataMean, "tidy.txt", row.names = F, quote = F)


