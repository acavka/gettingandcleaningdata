###############################################################################

# Coursera - Getting and Cleaning Data Course Project

# run_analysis.R

# This script will perform the following steps on the UCI HAR Dataset downloaded from 
# https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 
# 1. Merge the training and the test sets to create one data set.
# 2. Extract only the measurements on the mean and standard deviation for each measurement. 
# 3. Use descriptive activity names to name the activities in the data set
# 4. Appropriately label the data set with descriptive activity names. 
# 5. Creates a second, independent tidy data set with the average of each variable for each 
#    activity and each subject.


###############################################################################

library(reshape2)
library(knitr)

# Create a data directory
if (!file.exists("data"))
{
  dir.create("data")
}
# Downloads the file as a zip
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
fileName <- "data/data.zip"
if (!file.exists(fileName))
  download.file(fileUrl, destfile = fileName, method = "auto")

# Unzips Files
unzip("data/UCI HAR Dataset/data.zip", exdir="data")

# 1. Merge the training and the test sets to create one data set.

# Reads in the data
# Activity Names
activitylabels <- read.table("data/UCI HAR Dataset/activity_labels.txt")
names(activitylabels) <- c("id", "name")
# Feature Names
features <- read.table("data/UCI HAR Dataset/features.txt")
names(features) <- c("id", "name")

# Subject Data
test_sub <- read.table("data/UCI HAR Dataset/test/subject_test.txt")
train_sub <- read.table("data/UCI HAR Dataset/train/subject_train.txt")
names(test_sub) <- c("subjectnumber")
names(train_sub) <- c("subjectnumber")
# X Data
test_x <- read.table("data/UCI HAR Dataset/test/X_test.txt")
train_x <- read.table("data/UCI HAR Dataset/train/X_train.txt")
names(test_x) <- features[,2]
names(train_x) <- features[,2]
# Y Data
test_y <- read.table("data/UCI HAR Dataset/test/y_test.txt")
train_y <- read.table("data/UCI HAR Dataset/train/y_train.txt")
names(test_y) <- c("id")
names(train_y) <- c("id")
train_y <- merge(activitylabels, train_y)
test_y <- merge(activitylabels, test_y)

# Temporary Dataset
test_df <- data.frame(test_sub, test_x, test_y)
train_df <- data.frame(train_sub, train_x, train_y)

# Combined Dataset
ds <- rbind(test_df, train_df)


# 2. Extract only the measurements on the mean and standard deviation for each measurement.
features_index <- grep("mean|std", features[,2])

ds_index <- grep("mean|std", colnames(ds))
ds <- ds[,c(1,ds_index,563,564)]


# 3. Use descriptive activity names to name the activities in the data set
#    NOTE: Activity Labels were applied in step 1 using the following code
#          train_y <- merge(activitylabels, train_y)
#          test_y  <- merge(activitylabels, test_y)


# 4. Appropriately label the data set with descriptive activity names
# Rename Columns to be more descriptive
names(ds) <- tolower(names(ds))
names(ds) <- gsub("\\()", "", names(ds))
names(ds) <- gsub("-std$", "stddev", names(ds))
names(ds) <- gsub("-mean", "mean", names(ds))
names(ds) <- gsub("^(t)","time", names(ds))
names(ds) <- gsub("^(f)","freq", names(ds))
names(ds) <- gsub("(bodybody|body)", "body", names(ds))

# 5. Creates a second, independent tidy data set with the average of each variable for each 
#    activity and each subject.
dsm <- melt(ds, id = c("subjectnumber", "name"))
final_ds <- acast(dsm, subjectnumber + name ~ variable, mean)

write.table(final_ds, file = "data/final.txt")
