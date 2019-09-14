# Load in data
# # Local
#setwd("~/Downloads/UCI HAR Dataset/")


# # General
filename <- "Coursera_DS3_Final.zip"

if (!file.exists(filename)){
    fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
    download.file(fileURL, filename, method="curl")
}  

if (!file.exists("UCI HAR Dataset")) { 
    unzip(filename) 
}

features <- read.table("features.txt", col.names = c("n","functions"))
activities <- read.table("activity_labels.txt", col.names = c("code", "activity"))
subtest <- read.table("test/subject_test.txt", col.names = "subject")
xtest <- read.table("test/X_test.txt", col.names = features$functions)
ytest <- read.table("test/y_test.txt", col.names = "code")
subtrain <- read.table("train/subject_train.txt", col.names = "subject")
xtrain <- read.table("train/X_train.txt", col.names = features$functions)
ytrain <- read.table("train/y_train.txt", col.names = "code")

# Part 1: Merging datasets
require(magrittr)
require(dplyr)
X <- rbind(xtrain, xtest)
Y <- rbind(ytrain, ytest)
Subject <- rbind(subtrain, subtest)
mgdata <- cbind(Subject, Y, X) #combine data

# Part 2: Extract Measurements
TDat <- mgdata %>% select(subject, code, contains("mean"), contains("std"))

#Parts 3 and 4: Descriptive Names
names(TDat)[2] = "activity"
names(TDat)<-gsub("Mag", "Magnitude", names(TDat))
names(TDat)<-gsub("BodyBody", "Body", names(TDat))
names(TDat)<-gsub("Gyro", "Gyroscope", names(TDat))
names(TDat)<-gsub("Acc", "Accelerometer", names(TDat))
names(TDat)<-gsub("^f", "Frequency", names(TDat))
names(TDat)<-gsub("^t", "Time", names(TDat))
names(TDat)<-gsub("tBody", "TimeBody", names(TDat))
names(TDat)<-gsub("-mean()", "Mean", names(TDat), ignore.case = TRUE)
names(TDat)<-gsub("-std()", "STD.DEV", names(TDat), ignore.case = TRUE)
names(TDat)<-gsub("-freq()", "Frequency", names(TDat), ignore.case = TRUE)
names(TDat)<-gsub("angle", "Angle", names(TDat))
names(TDat)<-gsub("gravity", "Gravity", names(TDat))

# Part 5: Averages
cleaned_data <- TDat %>% group_by(subject, activity) %>% summarise_all(list(mean))

##export!
write.table(CleanData, "cleaned_data.txt", row.name=FALSE)

