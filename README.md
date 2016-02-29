# Getting-and-Cleaning-Smart-Phone-Data
Course Assignment for turn in

This project is to demonstrate the capability of cleaning and tidying a dataset in a meaningful manner for eventual processing.

The course project has the following requirements 
  1. Merges the training and the test sets to create one data set.
  2. Extracts only the measurements on the mean and standard deviation for each measurement.
  3. Uses descriptive activity names to name the activities in the data set
  4. Appropriately labels the data set with descriptive variable names.
  5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

The following datasets were downloaded from the target URL.
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

  From the available datasets the following were loaded and utilized
   
  features.txt : Dataset containing column names of the X_test and X_Train 

  File Name           | Description of use
  ------------------- | --------------------------------------------------------------------------
  X_test.txt          | Subject identifiers correlating to train raw measurements by line number
  X_test.txt          | Raw measurements for subjects that were used in testing
  X_train.txt         | Raw measurements for subjects that were used in training
  y_test.txt          | activity numbers correlating to test raw measurements by line number
  y_train.txt         | activity numbers correlating to train raw measurements by line number
  subject_test.txt    | Subject identifiers correlating to test raw measurements by line number
  subject_train.txt   | Subject identifiers correlating to train raw measurements by line number
  activity_labels.txt | Human readable decoded value of y_test and y_train values.

Other available datasets within the smartphone zip are not used in the run_analysis.R script for this project.

Please note the script in current form does require the zip to be extracted in the "C:\RProgramming\Working3\CaseProject\UCI HAR Dataset\" folder.  




  
  
  
