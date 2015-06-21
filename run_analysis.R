# Getting and Clearning Data
## Peer Assessments 

# 1. Merges the training and the test sets to create one data set.
feat <- read.table("features.txt")
feat <- feat[,2]

labels <- read.table("activity_labels.txt")
labels <- labels[,2]

x.train <- read.table("train/X_train.txt")
y.train <- read.table("train/y_train.txt")
s.train <- read.table("train/subject_train.txt")

x.test <- read.table("test/X_test.txt")
y.test <- read.table("test/y_test.txt")
s.test <- read.table("test/subject_test.txt")


# 2. Extracts only the measurements on the mean and standard deviation for each measurement. 
extract.feat <- grepl("mean|std", feat)
x.train <- x.train[, extract.feat]
x.test <- x.test[, extract.feat]

# 3. Uses descriptive activity names to name the activities in the data set
y.train[,2] <- labels[y.train[,1]]
names(y.train) <- c("Activity_ID", "Activity_Label")
names(s.train) <- "subject"

y.test[,2] <- labels[y.test[,1]]
names(y.test) <- c("Activity_ID", "Activity_Label")
names(s.test) <- "subject"

# 4. Appropriately labels the data set with descriptive variable names. 
data.train <- cbind(s.train, y.train, x.train)
data.test <- cbind(s.test, y.test, x.test)
data <- rbind(data.train, data.test)

# 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
id.labels <- c("subject", "Activity_ID", "Activity_Label")
data.lables <- setdiff(colnames(data), id.labels)
melt.data <- melt(data, id=id.labels, measure.vars=data.lables)

tidy.data <- dcast(melt.data, subject + Activity_Label ~ variable, mean)

# Save
write.table(tidy.data, file="./tidy_data.txt", row.names=FALSE)
