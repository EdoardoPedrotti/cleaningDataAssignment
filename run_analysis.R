library(dplyr)

activitiesLabels = read.table("./data/activity_labels.txt")
activitiesLabels[,2] = as.character(activitiesLabels[,2])

features = read.table("./data/features.txt")
features[,2] = as.character(features[,2])

meanAndStd = grep(".*mean.*|.*std.*", features[,2])
meanAndStd.names = features[meanAndStd,2]
meanAndStd.names = gsub('-mean','Mean', meanAndStd.names)
meanAndStd.names = gsub('-std', 'Std', meanAndStd.names)
meanAndStd.names = gsub('[-()]','', meanAndStd.names)

train = read.table("./data/train/X_train.txt")[meanAndStd]
trainActivities = read.table("./data/train/y_train.txt")
trainSubjects = read.table("./data/train/subject_train.txt")
train = cbind(trainSubjects, trainActivities, train)

test = read.table("./data/test/X_test.txt")[meanAndStd]
testActivities = read.table("./data/test/y_test.txt")
testSubjects = read.table("./data/test/subject_test.txt")
test = cbind(testSubjects, testActivities, test)

allData = rbind(train, test)
colnames(allData) = c("subject", "activity", meanAndStd.names)

allData$activity = factor(allData$activity, levels = activitiesLabels[,1], labels = activitiesLabels[,2])
allData$subject = as.factor(allData$subject)

allData = allData %>% group_by(subject, activity)
allDataMean = allData %>% summarize_each(funs(mean))

write.table(allDataMean, "./data/tidy.txt", row.names = F, quote = F)


