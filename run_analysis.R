library(dplyr)
#set working directory and download data file
setwd("C:/Users/212542601/Documents/R/Coursera/ass4")
if(!file.exists("./mydata.zip")){
     download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip",destfile="./mydata.zip")
     unzip(zipfile="./mydata.zip")
}
#set new working directory and read testing text files into data frames
setwd("./UCI HAR Dataset/test")
subjecttestdata<-data.frame(read.table("./subject_test.txt"))
activitytestdata<-data.frame(read.table("./y_test.txt"))
featuretestdata<-data.frame(read.table("./X_test.txt"))
#set new working directory and read training text files into data frames
setwd('../train')
subjecttraindata<-data.frame(read.table("./subject_train.txt"))
activitytraindata<-data.frame(read.table('./y_train.txt'))
featuretraindata<-data.frame(read.table("./X_train.txt"))
#set new working directory and combine data frames
setwd("../")
subjectdata<-rbind(subjecttestdata,subjecttraindata)
activitydata<-rbind(activitytestdata,activitytraindata)
featuredata<-rbind(featuretestdata,featuretraindata)
#name columns
features<-read.table("./features.txt")
featurenames<-features$V2
names(featuredata)<-featurenames
names(subjectdata)<-"Subject"
names(activitydata)<-"Activity"
#combine data frames
mydata2<-cbind(subjectdata,activitydata,featuredata)
#select only mean and std variables
mydata2<-mydata2 %>% select("Subject":"Activity",contains("mean"),contains("std"))
#assign descriptive labels to activities
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
#assign descriptive labels to features
names(mydata2)<-gsub("^t","time_domain",names(mydata2))
names(mydata2)<-gsub("Acc","Acceleration",names(mydata2))
names(mydata2)<-gsub("Gyro","Gyroscope",names(mydata2))
names(mydata2)<-gsub("Mag","Magnitude",names(mydata2))
names(mydata2)<-gsub("^f","frequency_domain",names(mydata2))
#order data frame by first Subject factor and then Activity factor
mydata2<-mydata2[order(mydata2$Subject,mydata2$Activity),]
#calculate mean of each column based on Subject and Activity factor groupings
tidydata<-mydata2 %>% group_by(Subject, Activity) %>% summarise_all(mean)
#write tidy data to text file
write.table(tidydata,"mytidydata.txt",row.name=FALSE)