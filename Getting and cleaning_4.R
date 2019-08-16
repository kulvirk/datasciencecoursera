setwd("F:/DATA SCIENCE")
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip",destfile='Downloads/HARUS.zip')
data4<- unzip('Downloads/HARUS.zip')
setwd("UCI HAR Dataset")
X_train<- read.table("train/X_train.txt")
Y_train<- read.table("train/Y_train.txt")
X_test<- read.table("test/X_test.txt")
Y_test<- read.table("test/Y_test.txt")
Subject_train <-read.table("train/Subject_train.txt")
Subject_test <-read.table("test/Subject_test.txt")
X_merge <- rbind(X_train,X_test)
Y_merge <- rbind(Y_train,Y_test)
Subject_merge<- rbind(Subject_test,Subject_train)
Features <- read.table("features.txt")
names(Subject_merge)<-c("subject")
names(Y_merge)<- c("activity")
names(X_merge)<- Features[ ,2]
indices <- grep("-mean\\(\\)|-std\\(\\)", Features[, 2])
extracted <- X_merge[, indices]
names(extracted) <- Features[indices, 2]
names(extracted) <- gsub("\\(|\\)", "", names(extracted))
names(extracted) <- tolower(names(extracted))
activities <- read.table("activity_labels.txt")
activities[, 2] = gsub("_", "", tolower(as.character(activities[, 2])))
Y_merge[,1] = activities[Y_merge[,1], 2]
names(Y_merge) <- "activity"
names(Subject_merge) <- "subject"
clean <- cbind(Subject_merge,Y_merge,extracted)
write.table(clean, "merged_and_cleaned_data.txt")
clean2<-aggregate(. ~subject + activity, clean, mean)
clean2<-clean2[order(clean2$subject,clean2$activity),]
write.table(clean2, file = "merged_cleaned_dataset.txt",row.name=FALSE)

