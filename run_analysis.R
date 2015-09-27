# will be using dplyr lib later in this script
library(dplyr)

# read the complete feature list
features<-read.table("features.txt",header = FALSE,stringsAsFactors = FALSE)
features<-features$V2

# get the indices of features containing mean() or std() in their names
# this is the project requirement
filtered_feature_indices<-which(grepl("mean\\(\\)",features) | grepl("std\\(\\)",features))

# read the list of activity labels
act_labels<-read.table("activity_labels.txt",header = FALSE,stringsAsFactors = FALSE)
act_labels<-act_labels$V2

# get the list of subject mapping for the train set of data
subj_train<-read.table("train/subject_train.txt",header = FALSE,stringsAsFactors = FALSE)
subj_train<-subj_train$V1

# get the list of activity label mapping for the train set of data
label_train<-read.table("train/y_train.txt",header = FALSE,stringsAsFactors = FALSE)
label_train<-label_train$V1

#read the train data and set the column names to certain features
data_train<-read.table("train/X_train.txt",header = FALSE,stringsAsFactors = FALSE)
names(data_train)<-features
#remove the columns which are not required for the project completion
data_train<-data_train[,filtered_feature_indices]

#enrich the training data by adding the subject column
data_train$subject<-subj_train

#enrich the training data by adding the Activity column and filling in 
#the activity names instead of numbers
data_train$Activity<-act_labels[label_train]

# get the list of subject mapping for the test set of data
subj_test<-read.table("test/subject_test.txt",header = FALSE,stringsAsFactors = FALSE)
subj_test<-subj_test$V1

# get the list of activity label mapping for the test set of data
label_test<-read.table("test/y_test.txt",header = FALSE,stringsAsFactors = FALSE)
label_test<-label_test$V1

#read the train data and set the column names to certain features
data_test<-read.table("test/X_test.txt",header = FALSE,stringsAsFactors = FALSE)
names(data_test)<-features

#remove the columns which are not required for the project completion
data_test<-data_test[,filtered_feature_indices]

#enrich the training data by adding the subject column
data_test$subject<-subj_test

#enrich the training data by adding the Activity column and filling in 
#the activity names instead of numbers
data_test$Activity<-act_labels[label_test]

#merge the train and test data sets to produce the first result (step 4)
tidyDataSet<-rbind(data_train,data_test)

#produce the aggregated dataset for each unique pair of subject and activity (step 5)
finalDataSet<- tidyDataSet %>% group_by(subject,Activity) %>% summarize_each(funs(mean))
