##################
## Student DLARLICK
## COURSERA : Getting and Cleaning Data
## Week 4 Assignment
## Due 02/28/2016
##################


##Review Criteria
## 1. The submitted data set is tidy.
## 2. The Github repo contains the required scripts.
## 3. GitHub contains a code book that modifies and updates the available codebooks with the data to indicate all the variables 
##      and summaries calculated, along with units, and any other relevant information.
## 4. The README that explains the analysis files is clear and understandable.
## 5. The work submitted for this project is the work of the student who submitted it

##https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
##You should create one R script called run_analysis.R that does the following.
##
## 1. Merges the training and the test sets to create one data set.
## 2. Extract only the measurements on the mean and standard deviation for each measurement.
## 3. Uses descriptive activity names to name the activities in the data set
## 4. Appropriately label the data set with descriptive variable names.
## 5. From the data set in step 4, creates a second, independent tidy data set with the average 
##    of each variable for each activity and each subject.
##

## Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING)

##################
##Set the working directory and read in the relevant datasets

##library(plyr)
##plyr library screws up the group_by for the final dataset creation 
library(dplyr)
library(data.table)

##################
##Set the working directory and read in the relevant datasets

  ## Obtain the file path of the working directory.  All files are expected to be relative to this path
  ## x <- getwd()

  setwd("c:/rprogramming/working3/CaseProject/UCI HAR Dataset/")
  xtest <- read.delim("C:/rprogramming/Working3/CaseProject/UCI HAR Dataset/test/X_test.txt", header=FALSE, sep="")
  xtrain <- read.delim("C:/rprogramming/Working3/CaseProject/UCI HAR Dataset/train/X_train.txt", header=FALSE, sep="")

  ##Load In the activity identifiers relating to xtest/xtrain datasets
  ytestlbl <- read.delim("C:/rprogramming/Working3/CaseProject/UCI HAR Dataset/test/y_test.txt", header=FALSE, sep="")
  ytrainlbl <- read.delim("C:/rprogramming/Working3/CaseProject/UCI HAR Dataset/train/y_train.txt", header=FALSE, sep="")

  ##Load In the activity identifiers relating to xtest/xtrain datasets
  subjecttest  <- read.delim("C:/rprogramming/Working3/CaseProject/UCI HAR Dataset/test/subject_test.txt", header=FALSE, sep="")
  subjecttrain <- read.delim("C:/rprogramming/Working3/CaseProject/UCI HAR Dataset/train/subject_train.txt", header=FALSE, sep="")

  ##Obtain the column names from the feature dataset 
  features <- read.delim("C:/rprogramming/Working3/CaseProject/UCI HAR Dataset/features.txt", header=FALSE, sep="")

  ##Obtain the column names from the activity dataset
  actlbls <- read.delim("C:/rprogramming/Working3/CaseProject/UCI HAR Dataset/activity_labels.txt", header=FALSE, sep="")

##################
## 1. Create a seperate column and relabel columns as DUMMYCOL### from those matching 
##    A pattern of ()-##,## as this was being oddly interpreted as a duplicate column in 
##    later processing steps.  Ultimately these columns will be dropped.  Rename, then filter for requsite columns.
##  
## 3. Put an identifier on the respective datasets prior to appending them together.  
##     filetype = (train or test)
##  
## 4. Pull in the activity labels and bind as an extra row to the respective  train and test datasets
##     ytrainlbl and ytestlbl are the numerical representations,  this will append a column V1
##  
## 5. Append the subject identifier to the respective datasets
##  
## 6. Merge with the activity labels for a human readable decoded value
##      an inner join is to be done using the V1 attribute of both data frames, with the net result
##      of the V2 column being added with the text decoded value.
##
## 7. Append the train and test data frames to make a combined train test listing. 
##      combined
  
  ##Rename problem columns to dummy with a row number to avoid duplication of column names.  This will be excluded later on.
  features <-mutate(features, collabels= ifelse(grepl("()-[0-9]+,[0-9]+",V2, ), paste("DUMMYCOL",seq(nrow(features)), sep=""), paste(features$V2)))
  
  ##Apply column names to both test and train datasets
  colnames(xtest) <- features[,"collabels"]
  colnames(xtrain) <- features[,"collabels"]

  ##Add in the additional column for the numeric activity label
  xtrain <- cbind(ytrainlbl, xtrain)
  xtest  <- cbind(ytestlbl, xtest)

  ##Add an identifier into the data prior to merging to differentiate train from test
  xtrain$filetype = 'train'
  xtest$filetype = 'test'
 
  ##Rename the V1 to subjid and append to the respective train/test datasets
  colnames(subjecttest)  <- "subjid"
  colnames(subjecttrain) <- "subjid"
  xtrain <- cbind(subjecttrain,xtrain)
  xtest  <- cbind(subjecttest, xtest)
  
  ##Merge the activity name using an inner_join 
  xtrain <- inner_join(xtrain,actlbls,by="V1")
  xtest  <- inner_join(xtest,actlbls,by="V1")
  
  ##Rename the V2 Column as Activity in both datasets
  names(xtrain)[names(xtrain)=="V2"] <- "activity"
  names(xtest)[names(xtest)=="V2"] <- "activity"
  
  ##Append the training and testing datasets together
  combined <- rbind(xtrain,xtest)
  
  ##Select only the relevant datasets and merge the test and train datasets together
  combined <- select(combined,grep("*mean\\(\\)*|*std\\(\\)*|filetype|activity|subjid",colnames(combined),value=FALSE))

  ##Clean Up the names
  tempnames <- names(combined)
  tempnames <- gsub("\\(\\)-","",tempnames)
  tempnames <- gsub("\\(\\)","",tempnames)
  tempnames <- gsub("-","",tempnames)
  colnames(combined) <- tempnames
    
  ##ReOrder the columns... 
  combined <- combined[,c(1,68:69,2:67)]
 
  ##Create a data table
  ##dtcombined <- data.table(combined)  

  ##select(combined,-(subjid:activity))
  ##ddply(d, .(Name), summarize,  Rate1=mean(Rate1), Rate2=mean(Rate2))
  
  ##Generate Grouping and then summary "finalsummary" dataset
  ##  please note..  was attempting to use some sort of dynamic or regular expression
  ##  for creation of summary listing.  Unfortunately, was not able to achieve this and 
  ##  opted for an explicit column utilization to enable turn-in of project.

  summarymean <- group_by(combined, subjid, activity)
  finalsummary <- summarize(summarymean,
                            tBodyAccmeanX =mean(tBodyAccmeanX),
                            tBodyAccmeanY =mean(tBodyAccmeanY),
                            tBodyAccmeanZ =mean(tBodyAccmeanZ),
                            tBodyAccstdX =mean(tBodyAccstdX),
                            tBodyAccstdY =mean(tBodyAccstdY),
                            tBodyAccstdZ =mean(tBodyAccstdZ),
                            tGravityAccmeanX =mean(tGravityAccmeanX),
                            tGravityAccmeanY =mean(tGravityAccmeanY),
                            tGravityAccmeanZ =mean(tGravityAccmeanZ),
                            tGravityAccstdX =mean(tGravityAccstdX),
                            tGravityAccstdY =mean(tGravityAccstdY),
                            tGravityAccstdZ =mean(tGravityAccstdZ),
                            tBodyAccJerkmeanX =mean(tBodyAccJerkmeanX),
                            tBodyAccJerkmeanY =mean(tBodyAccJerkmeanY),
                            tBodyAccJerkmeanZ =mean(tBodyAccJerkmeanZ),
                            tBodyAccJerkstdX =mean(tBodyAccJerkstdX),
                            tBodyAccJerkstdY =mean(tBodyAccJerkstdY),
                            tBodyAccJerkstdZ =mean(tBodyAccJerkstdZ),
                            tBodyGyromeanX =mean(tBodyGyromeanX),
                            tBodyGyromeanY =mean(tBodyGyromeanY),
                            tBodyGyromeanZ =mean(tBodyGyromeanZ),
                            tBodyGyrostdX =mean(tBodyGyrostdX),
                            tBodyGyrostdY =mean(tBodyGyrostdY),
                            tBodyGyrostdZ =mean(tBodyGyrostdZ),
                            tBodyGyroJerkmeanX =mean(tBodyGyroJerkmeanX),
                            tBodyGyroJerkmeanY =mean(tBodyGyroJerkmeanY),
                            tBodyGyroJerkmeanZ =mean(tBodyGyroJerkmeanZ),
                            tBodyGyroJerkstdX =mean(tBodyGyroJerkstdX),
                            tBodyGyroJerkstdY =mean(tBodyGyroJerkstdY),
                            tBodyGyroJerkstdZ =mean(tBodyGyroJerkstdZ),
                            tBodyAccMagmean =mean(tBodyAccMagmean),
                            tBodyAccMagstd =mean(tBodyAccMagstd),
                            tGravityAccMagmean =mean(tGravityAccMagmean),
                            tGravityAccMagstd =mean(tGravityAccMagstd),
                            tBodyAccJerkMagmean =mean(tBodyAccJerkMagmean),
                            tBodyAccJerkMagstd =mean(tBodyAccJerkMagstd),
                            tBodyGyroMagmean =mean(tBodyGyroMagmean),
                            tBodyGyroMagstd =mean(tBodyGyroMagstd),
                            tBodyGyroJerkMagmean =mean(tBodyGyroJerkMagmean),
                            tBodyGyroJerkMagstd =mean(tBodyGyroJerkMagstd),
                            fBodyAccmeanX =mean(fBodyAccmeanX),
                            fBodyAccmeanY =mean(fBodyAccmeanY),
                            fBodyAccmeanZ =mean(fBodyAccmeanZ),
                            fBodyAccstdX =mean(fBodyAccstdX),
                            fBodyAccstdY =mean(fBodyAccstdY),
                            fBodyAccstdZ =mean(fBodyAccstdZ),
                            fBodyAccJerkmeanX =mean(fBodyAccJerkmeanX),
                            fBodyAccJerkmeanY =mean(fBodyAccJerkmeanY),
                            fBodyAccJerkmeanZ =mean(fBodyAccJerkmeanZ),
                            fBodyAccJerkstdX =mean(fBodyAccJerkstdX),
                            fBodyAccJerkstdY =mean(fBodyAccJerkstdY),
                            fBodyAccJerkstdZ =mean(fBodyAccJerkstdZ),
                            fBodyGyromeanX =mean(fBodyGyromeanX),
                            fBodyGyromeanY =mean(fBodyGyromeanY),
                            fBodyGyromeanZ =mean(fBodyGyromeanZ),
                            fBodyGyrostdX =mean(fBodyGyrostdX),
                            fBodyGyrostdY =mean(fBodyGyrostdY),
                            fBodyGyrostdZ =mean(fBodyGyrostdZ),
                            fBodyAccMagmean =mean(fBodyAccMagmean),
                            fBodyAccMagstd =mean(fBodyAccMagstd),
                            fBodyBodyAccJerkMagmean =mean(fBodyBodyAccJerkMagmean),
                            fBodyBodyAccJerkMagstd =mean(fBodyBodyAccJerkMagstd),
                            fBodyBodyGyroMagmean =mean(fBodyBodyGyroMagmean),
                            fBodyBodyGyroMagstd =mean(fBodyBodyGyroMagstd),
                            fBodyBodyGyroJerkMagmean =mean(fBodyBodyGyroJerkMagmean),
                            fBodyBodyGyroJerkMagstd =mean(fBodyBodyGyroJerkMagstd))
   
  ##Output the final dataset
  write.table(finalsummary,"finalsummary.txt", row.names=FALSE)
  
##END OF SCRIPT  