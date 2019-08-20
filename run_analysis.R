setwd("C:\\Users\\Innovation\\Downloads\\getdata_projectfiles_UCI HAR Dataset (1)\\UCI HAR Dataset")
getwd()

library(dplyr)

# read train data
X_train <- read.table("train/X_train.txt")
y_train <- read.table("train/y_train.txt")
sub_train <- read.table("train/subject_train.txt")

# read test data
X_test <- read.table("test/X_test.txt")
y_test <- read.table("test/y_test.txt")
sub_test <- read.table("test/subject_test.txt")

#read data description
variable_names <- read.table("features.txt")

# read activity label
activity_label <- read.table('activity_labels.txt')

# 1. Merge the training and test sets to create one data sets
X_total <- rbind(X_train, X_test)
y_total <- rbind(y_train, y_test)
sub_total <- rbind(sub_train, sub_test)

# 2. Extracts only the measurements on the mean and standard deviation foe each measurement
selected_var <- variable_names[grep("mean\\(\\)|std\\(\\)", variable_names[,2]),]
X_total <- X_total[, selected_var[,1]]

# 3. Uses descriptive activity names to name the activities in the data set
colnames(y_total) <- "activity"
y_total$activitylabel <- factor(y_total$activity, labels = as.character(activity_label[,2]))
activitylabel <- y_total[,-1]

# 4. Appropriately labels the data set with descriptive variable names
colnames(X_total) <- variable_names[selected_var[,1],2]

# 5. From the data set in step-4, creates a second, independent tidy data set with the average od each
#variable for each activity and each subject
colnames(sub_total) <- "subject"
total <- cbind(X_total, activitylabel, sub_total)
total_mean <- total %>% group_by(activitylabel, subject) %>% summarize_each(funs(mean))
write.table(total_mean, file = 'tidydata.txt', row.names = FALSE, col.names = TRUE)







