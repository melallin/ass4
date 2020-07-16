**Objective**
-------------

The purpose of this project is to demonstrate my ability to collect,
work with, and clean a data set.

### **Review criteria:**

     1.  The submitted data set is tidy.
     2.  The Github repo contains the required scripts.
     3.  GitHub contains a code book that modifies and updates the available codebooks with the data to indicate 
     all the variables and summaries calculated, along with units, and any other relevant information.
     4.  The README that explains the analysis files is clear and understandable.
     5.  The work submitted for this project is the work of the student who submitted it.

### **Getting and Cleaning Data Course Project:**

The purpose of this project is to demonstrate my ability to collect,
work with, and clean a data set. The goal is to prepare tidy data that
can be used for later analysis. The requirements are to submit: 1) a
tidy data set as described below, 2) a link to a Github repository with
my script for performing the analysis, and 3) a code book that describes
the variables, the data, and any transformations or work that I
performed to clean up the data called CodeBook.md. I will also include a
README.md in the repo with my scripts. This repo explains how all of the
scripts work and how they are connected.

One of the most exciting areas in all of data science right now is
wearable computing - see for example this article . Companies like
Fitbit, Nike, and Jawbone Up are racing to develop the most advanced
algorithms to attract new users. The data linked to from the course
website represent data collected from the accelerometers from the
Samsung Galaxy S smartphone. A full description is available at the site
where the data was obtained:

<a href="http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones" class="uri">http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones</a>

Here are the data for the project:

<a href="https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip" class="uri">https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip</a>

I will create one R script called run\_analysis.R that does the
following.

     1.  Merges the training and the test sets to create one data set.
     2.  Extracts only the measurements on the mean and standard deviation for each measurement.
     3.  Uses descriptive activity names to name the activities in the data set
     4.  Appropriately labels the data set with descriptive variable names.
     5.  From the data set in step 4, creates a second, independent tidy data set with the average of each variable 
     for each activity and each subject.

### **Retrieving the Data**

The first step is to download and unzip the file
<a href="https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip" class="uri">https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip</a>.
Once this step is complete, the necessary data files are in a local
directory “UCI HAR Dataset”. Package dplyr is used for this assignment.

    library(dplyr)

    ## 
    ## Attaching package: 'dplyr'

    ## The following objects are masked from 'package:stats':
    ## 
    ##     filter, lag

    ## The following objects are masked from 'package:base':
    ## 
    ##     intersect, setdiff, setequal, union

### **Converting Data to Data Frames**

Convert all .txt files for the test data, as well as the training data,
into data frames.

    subjecttestdata<-data.frame(read.table("./subject_test.txt"))
    activitytestdata<-data.frame(read.table("./y_test.txt"))
    featuretestdata<-data.frame(read.table("./X_test.txt"))
    subjecttraindata<-data.frame(read.table("./subject_train.txt"))
    activitytraindata<-data.frame(read.table('./y_train.txt'))
    featuretraindata<-data.frame(read.table("./X_train.txt"))

### **Combining Test and Training Data Frames**

Using rbind(), combine test and training data frames into one data frame
for subject, activity and features.

    subjectdata<-rbind(subjecttestdata,subjecttraindata)
    activitydata<-rbind(activitytestdata,activitytraindata)
    featuredata<-rbind(featuretestdata,featuretraindata)

### **Name Columns in each Data Frame**

Read the source file “features.txt” into a data frame “features”.
Extract a vector “featurenames” from the second column of features.
Assign variable names to the data frame featuredata utilizing the vector
featurenames. Name column in subjectdata “Subject” and name column in
activitydata “Activity”.

    #name columns
    features<-read.table("./features.txt")
    featurenames<-features$V2
    names(featuredata)<-featurenames
    names(subjectdata)<-"Subject"
    names(activitydata)<-"Activity"

### **Combine all Data Frames into One**

    #combine data frames
    mydata2<-cbind(subjectdata,activitydata,featuredata)

### **Select only Relevant Columns from Data Frame**

Relevant columns for this exercise are “Subject”, “Activity” and all
feature variables for measurement mean and standard deviation.

    #select only mean and std variables
    mydata2<-mydata2 %>% select("Subject":"Activity",contains("mean"),contains("std"))

### **Assign Descriptive Labels for Activites instead of Activity Codes**

    activityvec<-mydata2$Activity
    activityvec2<-vector('character')
    for (i in 1:length(activityvec)){
         if (activityvec[i]==1){
              activityvec2[i]<-"WALKING"
         }else if(activityvec[i]==2){
              activityvec2[i]<-"WALKING_UPSTAIRS"
         }else if(activityvec[i]==3){
              activityvec2[i]<-"WALKING_DOWNSTAIRS"
         }else if(activityvec[i]==4){
              activityvec2[i]<-"SITTING"
         }else if(activityvec[i]==5){
              activityvec2[i]<-"STANDING"
         }else{
              activityvec2[i]<-"LAYING"
         }
    }
    mydata2[,2]<-activityvec2

### **Assign Descriptive Labels for Features Variables**

    #assign descriptive labels to features
    names(mydata2)<-gsub("^t","time_domain",names(mydata2))
    names(mydata2)<-gsub("Acc","Acceleration",names(mydata2))
    names(mydata2)<-gsub("Gyro","Gyroscope",names(mydata2))
    names(mydata2)<-gsub("Mag","Magnitude",names(mydata2))
    names(mydata2)<-gsub("^f","frequency_domain",names(mydata2))

### **Reorder Data Frame based on Subject and then Activity**

    #order data frame by first Subject factor and then Activity factor
    mydata2<-mydata2[order(mydata2$Subject,mydata2$Activity),]

### **Create a Tidy Data Set**

This will be done by calculating the mean for each feature variable
grouped by first the Subject factor and then the Activity factor and
then writing resultant tidy data frame to a text file for uploading.

    #calculate mean of each column based on Subject and Activity factor groupings
    tidydata<-mydata2 %>% group_by(Subject, Activity) %>% summarise_all(mean)
    names(tidydata)

    ##  [1] "Subject"                                                     
    ##  [2] "Activity"                                                    
    ##  [3] "time_domainBodyAcceleration-mean()-X"                        
    ##  [4] "time_domainBodyAcceleration-mean()-Y"                        
    ##  [5] "time_domainBodyAcceleration-mean()-Z"                        
    ##  [6] "time_domainGravityAcceleration-mean()-X"                     
    ##  [7] "time_domainGravityAcceleration-mean()-Y"                     
    ##  [8] "time_domainGravityAcceleration-mean()-Z"                     
    ##  [9] "time_domainBodyAccelerationJerk-mean()-X"                    
    ## [10] "time_domainBodyAccelerationJerk-mean()-Y"                    
    ## [11] "time_domainBodyAccelerationJerk-mean()-Z"                    
    ## [12] "time_domainBodyGyroscope-mean()-X"                           
    ## [13] "time_domainBodyGyroscope-mean()-Y"                           
    ## [14] "time_domainBodyGyroscope-mean()-Z"                           
    ## [15] "time_domainBodyGyroscopeJerk-mean()-X"                       
    ## [16] "time_domainBodyGyroscopeJerk-mean()-Y"                       
    ## [17] "time_domainBodyGyroscopeJerk-mean()-Z"                       
    ## [18] "time_domainBodyAccelerationMagnitude-mean()"                 
    ## [19] "time_domainGravityAccelerationMagnitude-mean()"              
    ## [20] "time_domainBodyAccelerationJerkMagnitude-mean()"             
    ## [21] "time_domainBodyGyroscopeMagnitude-mean()"                    
    ## [22] "time_domainBodyGyroscopeJerkMagnitude-mean()"                
    ## [23] "frequency_domainBodyAcceleration-mean()-X"                   
    ## [24] "frequency_domainBodyAcceleration-mean()-Y"                   
    ## [25] "frequency_domainBodyAcceleration-mean()-Z"                   
    ## [26] "frequency_domainBodyAcceleration-meanFreq()-X"               
    ## [27] "frequency_domainBodyAcceleration-meanFreq()-Y"               
    ## [28] "frequency_domainBodyAcceleration-meanFreq()-Z"               
    ## [29] "frequency_domainBodyAccelerationJerk-mean()-X"               
    ## [30] "frequency_domainBodyAccelerationJerk-mean()-Y"               
    ## [31] "frequency_domainBodyAccelerationJerk-mean()-Z"               
    ## [32] "frequency_domainBodyAccelerationJerk-meanFreq()-X"           
    ## [33] "frequency_domainBodyAccelerationJerk-meanFreq()-Y"           
    ## [34] "frequency_domainBodyAccelerationJerk-meanFreq()-Z"           
    ## [35] "frequency_domainBodyGyroscope-mean()-X"                      
    ## [36] "frequency_domainBodyGyroscope-mean()-Y"                      
    ## [37] "frequency_domainBodyGyroscope-mean()-Z"                      
    ## [38] "frequency_domainBodyGyroscope-meanFreq()-X"                  
    ## [39] "frequency_domainBodyGyroscope-meanFreq()-Y"                  
    ## [40] "frequency_domainBodyGyroscope-meanFreq()-Z"                  
    ## [41] "frequency_domainBodyAccelerationMagnitude-mean()"            
    ## [42] "frequency_domainBodyAccelerationMagnitude-meanFreq()"        
    ## [43] "frequency_domainBodyBodyAccelerationJerkMagnitude-mean()"    
    ## [44] "frequency_domainBodyBodyAccelerationJerkMagnitude-meanFreq()"
    ## [45] "frequency_domainBodyBodyGyroscopeMagnitude-mean()"           
    ## [46] "frequency_domainBodyBodyGyroscopeMagnitude-meanFreq()"       
    ## [47] "frequency_domainBodyBodyGyroscopeJerkMagnitude-mean()"       
    ## [48] "frequency_domainBodyBodyGyroscopeJerkMagnitude-meanFreq()"   
    ## [49] "angle(tBodyAccelerationMean,gravity)"                        
    ## [50] "angle(tBodyAccelerationJerkMean),gravityMean)"               
    ## [51] "angle(tBodyGyroscopeMean,gravityMean)"                       
    ## [52] "angle(tBodyGyroscopeJerkMean,gravityMean)"                   
    ## [53] "angle(X,gravityMean)"                                        
    ## [54] "angle(Y,gravityMean)"                                        
    ## [55] "angle(Z,gravityMean)"                                        
    ## [56] "time_domainBodyAcceleration-std()-X"                         
    ## [57] "time_domainBodyAcceleration-std()-Y"                         
    ## [58] "time_domainBodyAcceleration-std()-Z"                         
    ## [59] "time_domainGravityAcceleration-std()-X"                      
    ## [60] "time_domainGravityAcceleration-std()-Y"                      
    ## [61] "time_domainGravityAcceleration-std()-Z"                      
    ## [62] "time_domainBodyAccelerationJerk-std()-X"                     
    ## [63] "time_domainBodyAccelerationJerk-std()-Y"                     
    ## [64] "time_domainBodyAccelerationJerk-std()-Z"                     
    ## [65] "time_domainBodyGyroscope-std()-X"                            
    ## [66] "time_domainBodyGyroscope-std()-Y"                            
    ## [67] "time_domainBodyGyroscope-std()-Z"                            
    ## [68] "time_domainBodyGyroscopeJerk-std()-X"                        
    ## [69] "time_domainBodyGyroscopeJerk-std()-Y"                        
    ## [70] "time_domainBodyGyroscopeJerk-std()-Z"                        
    ## [71] "time_domainBodyAccelerationMagnitude-std()"                  
    ## [72] "time_domainGravityAccelerationMagnitude-std()"               
    ## [73] "time_domainBodyAccelerationJerkMagnitude-std()"              
    ## [74] "time_domainBodyGyroscopeMagnitude-std()"                     
    ## [75] "time_domainBodyGyroscopeJerkMagnitude-std()"                 
    ## [76] "frequency_domainBodyAcceleration-std()-X"                    
    ## [77] "frequency_domainBodyAcceleration-std()-Y"                    
    ## [78] "frequency_domainBodyAcceleration-std()-Z"                    
    ## [79] "frequency_domainBodyAccelerationJerk-std()-X"                
    ## [80] "frequency_domainBodyAccelerationJerk-std()-Y"                
    ## [81] "frequency_domainBodyAccelerationJerk-std()-Z"                
    ## [82] "frequency_domainBodyGyroscope-std()-X"                       
    ## [83] "frequency_domainBodyGyroscope-std()-Y"                       
    ## [84] "frequency_domainBodyGyroscope-std()-Z"                       
    ## [85] "frequency_domainBodyAccelerationMagnitude-std()"             
    ## [86] "frequency_domainBodyBodyAccelerationJerkMagnitude-std()"     
    ## [87] "frequency_domainBodyBodyGyroscopeMagnitude-std()"            
    ## [88] "frequency_domainBodyBodyGyroscopeJerkMagnitude-std()"

    #write tidy data to text file
    write.table(tidydata,"mytidydata.txt",row.name=FALSE)
