---
title: "CodeBook"
author: "Kulvir Kaur"
date: "16/08/2019"
output: html_document
---

##Code Book

This is a Code book explains the variables, steps and other information about cleaning and merging data.

setwd("F:/DATA SCIENCE")
##is used to set the working directory.

download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip",destfile='Downloads/HARUS.zip')
##Download the  dataset from given link that is in zip folder.

data4<- unzip('Downloads/HARUS.zip')
## the file.

setwd("UCI HAR Dataset")
##Now set the new working directory 
 
X_train<- read.table("train/X_train.txt")
Y_train<- read.table("train/Y_train.txt")
##Train data set
##X_train is trainig data  and Y_train is labels for trining data.


X_test<- read.table("test/X_test.txt")
Y_test<- read.table("test/Y_test.txt")
##Test Data set
##X_test is testing data and Y_test is lables for testing data.


Subject_train <-read.table("train/Subject_train.txt")
Subject_test <-read.table("test/Subject_test.txt")
##Subject Dataset
##'train/subject_train.txt': Each row identifies the subject who performed the activity for each window sample. Its range is from 1 to 30.

X_merge <- rbind(X_train,X_test)
Y_merge <- rbind(Y_train,Y_test)
##Merge  with rows

Subject_merge<- rbind(Subject_test,Subject_train)
##again merge wit rows
 
Features <- read.table("features.txt")
##'features.txt': List of all features.

names(Subject_merge)<-c("subject")
names(Y_merge)<- c("activity")
names(X_merge)<- Features[ ,2]
##Assign the names for features

indices <- grep("-mean\\(\\)|-std\\(\\)", Features[, 2])
extracted <- X_merge[, indices]
names(extracted) <- Features[indices, 2]
names(extracted) <- gsub("\\(|\\)", "", names(extracted))
names(extracted) <- tolower(names(extracted))
##Look for mean and standard words in names

activities <- read.table("activity_labels.txt")
activities[, 2] = gsub("_", "", tolower(as.character(activities[, 2])))
##'activity_labels.txt': Links the class labels with their activity name
##Activity: The type of activity performed when the corresponding measurements were taken.

Y_merge[,1] = activities[Y_merge[,1], 2]
names(Y_merge) <- "activity"
names(Subject_merge) <- "subject"
clean <- cbind(Subject_merge,Y_merge,extracted)
write.table(clean, "merged_and_cleaned_data.txt")
clean2<-aggregate(. ~subject + activity, clean, mean)
clean2<-clean2[order(clean2$subject,clean2$activity),]
write.table(clean2, file = "merged_cleaned_dataset.txt",row.name=FALSE)
##Save the cleaned Data in text file. 



