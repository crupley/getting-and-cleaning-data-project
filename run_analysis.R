## Coursera/Gettin and Cleaning Data
## Course Project

## Chris Rupley
## 2014-09-17

testdat <- read.table("./getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/test/X_test.txt")
testnames <- read.table("./getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/test/Y_test.txt")
testsubjects <- read.table("./getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/test/subject_test.txt")
names(testnames) <- "activity"
names(testsubjects) <- "subject"

traindat <- read.table("./getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/train/X_train.txt")
trainnames <- read.table("./getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/train/Y_train.txt")
trainsubjects <- read.table("./getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/train/subject_train.txt")
names(trainnames) <- "activity"
names(trainsubjects) <- "subject"

#load column names from file
colnames <- read.table("./getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/features.txt")
colnames <- as.character(colnames[,2])

#apply column names to objects
names(testdat) <- colnames
names(traindat) <- colnames

testdat <- cbind(testdat, testnames, testsubjects)
traindat <- cbind(traindat, trainnames, trainsubjects)

#merge the train and test data sets
dat <- rbind(testdat, traindat)

#give the activity variable descriptive names
activitynames <- read.table("./getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/activity_labels.txt")
activitynames[,2] <- as.character(activitynames[,2])


for (i in 1:6) {
    dat$activity[dat$activity == i] <- activitynames[i,2]
}
dat$activity <- as.factor(dat$activity)
dat$subject <- as.factor(dat$subject)

#Extract means and standard deviation columns

meancolnum <- grep("*mean\\(\\)*", names(dat))
stdcolnum <- grep("*std\\(\\)*", names(dat))

dat2 <- dat[,c(meancolnum, stdcolnum)]
dat2 <- cbind(dat[,563:562],dat2)

library(reshape2)
dm <- melt(dat2, id.vars = 1:2)
dmean <- with(dm, tapply(value, list(variable, activity, subject), mean))
output <- melt(dmean)

names(output) <- c("Measurements", "Activity", "Subject", "Average")
output <- output[,c(3, 2, 1, 4)]

write.table(output, "tidy_data.txt", row.names = FALSE)
