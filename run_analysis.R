setwd("/Users/bryangottshall/Downloads/UCI HAR Dataset")

library(reshape2)

####Read Data Sets###

###Activity Labels
act.lab<-read.table("activity_labels.txt",col.names=c("activity_id","activity_name"))


###Feature Labels
features<-read.table("features.txt")
feat.name<-features[,2]


###Test Data
test.data<-read.table("test/X_test.txt")
colnames(test.data)<-feat.name

###Training Data
train.data<-read.table("train/X_train.txt")
colnames(train.data)<-feat.name

###Test Subject IDs
test.sub.ID<-read.table("test/subject_test.txt")
colnames(test.sub.ID)<-"subject_id"

###Test Activity IDs
test.act.ID<-read.table("test/y_test.txt")
colnames(test.act.ID)<-"activity_id"


###Train Subject IDs
train.sub.ID<-read.table("train/subject_train.txt")
colnames(train.sub.ID)<-"subject_id"

###Train Acitivty IDs
train.act.ID<-read.table("train/y_train.txt")
colnames(train.act.ID)<-"activity_id"

###Combine subject and test IDs
test.data<-cbind(test.sub.ID, test.act.ID, test.data)

###Combine subject and training IDs
train.data<-cbind(train.sub.ID, train.act.ID, train.data)


###Combine Test and Training Data
all.data<-rbind(train.data, test.data)

###Get the means
mean.ID<-grep("mean",names(all.data),ignore.case=TRUE)
mean.names<-names(all.data)[mean.ID]
std.ID<-grep("std",names(all.data),ignore.case=TRUE)
std.names<-names(all.data)[std.ID]
mean.std<-all.data[,c("subject_id","activity_id", mean.names, std.names)]

###Merge data sets
merge.dat<-merge(act.lab, mean.std, by.x="activity_id",by.y="activity_id",all=TRUE)

##Melt the data set with descriptive names
melt.dat<-melt(merge.dat,id=c("activity_id","activity_name","subject_id"))

##Add the mean data
mean.dat<-dcast(melt.dat, activity_id + activity_name + subject_id ~variable, mean)

##Create file for the new clean data
write.table(mean.dat, "clean.data.activity.txt", row.names=FALSE)
