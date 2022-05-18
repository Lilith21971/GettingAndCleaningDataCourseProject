# Assigning the working directory to the variable my_working_dir (remember that R uses / ; not \).
#my_working_dir <- "D:/Treinamento/CursosR/GettingAndCleaningData/Week4/scripts/Course_Project"

# Setting working directory
#setwd(my_working_dir)

# Installing packages (comment the next line if packages were already installed)
#install.packages("dplyr")

# Loading packages
library(dplyr)

# Downloading dataset (the if condition will skip the download if it was already done)
filename <- "GCD_CP.zip" # Getting and Cleaning Data - Course Project
if (!file.exists(filename)){
        fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
        download.file(fileURL, filename, method="curl")
}  

# Creating a new folder and unzipping the dataset (if needed) 
if (!file.exists("UCI HAR Dataset")) { 
        unzip(filename) 
}

# Before proceeding, read the http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones and
# the "readme.txt" for the dataset and take a look at the files downloaded; read also the features_info.txt.

# Loading the databases into R and assigning variables (colunm) names 
activities <- read.table("UCI HAR Dataset/activity_labels.txt", col.names = c("code", "activity"))
features <- read.table("UCI HAR Dataset/features.txt", col.names = c("n", "feat_variable"))

subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt", col.names = "subject")
x_test <- read.table("UCI HAR Dataset/test/X_test.txt", col.names = features$feat_variable) # column names come from the features table feat_variable
y_test <- read.table("UCI HAR Dataset/test/y_test.txt", col.names = "code")

subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt", col.names = "subject")
x_train <- read.table("UCI HAR Dataset/train/X_train.txt", col.names = features$feat_variable) # column names come from the features table feat_variable
y_train <- read.table("UCI HAR Dataset/train/y_train.txt", col.names = "code")

# Merging the training and the test sets to create one dataset
# Row binding x, y and subject from training and test datasets
x <- rbind(x_train, x_test)
y <- rbind(y_train, y_test)
subject <- rbind(subject_train, subject_test)
# Column binding subject, y (activity code) and x (feature measurements)
Merged_Data <- cbind(subject, y, x)

# Extracting only the measurements on the mean and standard deviation for each measurement
Merged_Data_Sub <- Merged_Data %>% select(subject, code, contains("mean"), contains("std"))

# Using descriptive activity names to label the activities in the dataset
# Replacing the codes with their matched activity labels from the second column of the activities table
Merged_Data_Sub$code <- activities[Merged_Data_Sub$code, 2]

# Appropriately labeling the dataset with descriptive variables names
# Renaming the dataset to TidyData
TidyData <- Merged_Data_Sub
# Calling 'names' to see and check which labels need to be clarified (the columns were initially named above using col.names)
names(TidyData)
# Replacing the labels by a more intuitive wording and, to preserve uniformity, keeping the first letter of each word as capital
# The goal is to have descriptive names but not too long ones, since labels that are too long are also difficult to read and work with (therefore, some abbreviation will remain)
# The codebook will explain the variables meanings
# This dataset can be transformed in a tidy dataset keeping it in the wide format; it could also be reshaped to a narrow form, but there is no need
names(TidyData)<-gsub("subject", "Subject", names(TidyData)) # using capital letter at the beginning of words to keep uniformity
names(TidyData)[2] = "Activity" # renaming code as Activity
names(TidyData)<-gsub("^t", "Time", names(TidyData)) # replacing t at the beginning of the labels by Time
names(TidyData)<-gsub("^f", "Freq", names(TidyData)) # replacing f at the beginning of the labels by Freq (stands for Frequency)
names(TidyData)<-gsub("tBody", "TimeBody", names(TidyData)) # replacing tBody (not at the beginning) by TimeBody
names(TidyData)<-gsub("angle", "Angle", names(TidyData)) # using capital letter at the beginning of words to keep uniformity
names(TidyData)<-gsub("gravity", "Gravity", names(TidyData)) # using capital letter at the beginning of words to keep uniformity
names(TidyData)<-gsub("BodyBody", "Body", names(TidyData)) # deleting repeated words
names(TidyData)<-gsub("mean", "Mean", names(TidyData)) # using capital letter at the beginning of words to keep uniformity
names(TidyData)<-gsub("std", "Sd", names(TidyData)) # replacing abbreviation for Standard deviation
names(TidyData)<-gsub("freq", "Freq", names(TidyData)) # using capital letter at the beginning of words to keep uniformity
names(TidyData)<-gsub("_", "", names(TidyData)) # deleting any _ in the names
names(TidyData)<-gsub("\\.", "", names(TidyData)) # deleting any . in the names
names(TidyData)<-gsub("()", "", names(TidyData)) # deleting any () in the names
names(TidyData)<-gsub("MeanX", "XMean", names(TidyData)) # reordering words to a more meaningful way (stands for X axis Mean)
names(TidyData)<-gsub("MeanY", "YMean", names(TidyData)) # reordering words to a more meaningful way (stands for Y axis Mean)
names(TidyData)<-gsub("MeanZ", "ZMean", names(TidyData)) # reordering words to a more meaningful way (stands for Z axis Mean)
names(TidyData)<-gsub("SdX", "XSd", names(TidyData)) # reordering words to a more meaningful way (stands for X axis Standard deviation)
names(TidyData)<-gsub("SdY", "YSd", names(TidyData)) # reordering words to a more meaningful way (stands for Y axis Standard deviation)
names(TidyData)<-gsub("SdZ", "ZSd", names(TidyData)) # reordering words to a more meaningful way (stands for Z axis Standard deviation)
names(TidyData)<-gsub("MeanFreqX", "XMeanFreq", names(TidyData)) # reordering words to a more meaningful way (stands for X axis Mean Frequency)
names(TidyData)<-gsub("MeanFreqY", "YMeanFreq", names(TidyData)) # reordering words to a more meaningful way (stands for Y axis Mean Frequency)
names(TidyData)<-gsub("MeanFreqZ", "ZMeanFreq", names(TidyData)) # reordering words to a more meaningful way (stands for Z axis Mean Frequency)

# Checking the final labels
names(TidyData)

# Inspecting the dataset
View(TidyData)

########################
# Creating a second, independent tidy data set, with the average of each variable for each activity and each subject
FinalData <- TidyData %>%                
        group_by(Subject, Activity) %>%  # grouping by pairs of Subject and Activity
        summarise_all(mean)        # generating the means of each variable (feature measurement), within each pair of Subject and Activity
write.table(FinalData, "FinalData.txt", row.name=FALSE) # exporting the dataset as a txt (supressing the row index)

# Inspecting the final dataset
str(FinalData)
View(FinalData)
