library(reshape2)
library(plyr)
library(data.table)

activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt")[,2]
features<- read.table("./UCI HAR Dataset/features.txt")[,2]

#Loading all relevant data.

X_train <- read.table("./UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")
X_test <- read.table("./UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")

# Loading colnames for X and labels for y

features <- read.table("./UCI HAR Dataset/features.txt")[,2]
labels <- read.table("./UCI HAR Dataset/activity_labels.txt")[,2]


# Setting colnames for X and labels for y

names(X_train) <- features
names(X_test) <- features
names(subject_train) <- "subject"
names(subject_test) <- "subject"
y_train[,2] <- labels[y_train[,1]]
y_test[,2] <- labels[y_test[,1]]
names(y_train) <- c("ID", "label")
names(y_test) <- c("ID", "label")

# Merging data   --Task1
train <- cbind(X_train, y_train, subject_train)
test <- cbind(X_test, y_test, subject_test)
mt <- rbind(train, test)

# Extracting mean and std of each measurement  --Task2
feature_mnstd <- grepl("mean|std", features)
mt_mnstd <- mt[, feature_mnstd]

# Changing descriptive colnames -- Task3
names(mt_mnstd) <- gsub("Acc", "Accelerometre", names(mt_mnstd))
names(mt_mnstd) <- gsub("Gyro", "Gyroscope", names(mt_mnstd))
names(mt_mnstd) <- gsub("^t", "Time", names(mt_mnstd))
names(mt_mnstd) <- gsub("^f", "Frequency", names(mt_mnstd))

# Creating tidy data -- Task4
tidydata<- ddply(mt_mnstd, c("subject","label"), numcolwise(mean))

write.table(tidydata, file = "tidydata.txt")
