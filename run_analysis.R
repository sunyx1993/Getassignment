# download data and unzip
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", 
              "raw_data.dat", method="curl")
unzip("raw_data.dat")

# load data into R
train_data    <- read.table('UCI HAR Dataset/train/X_train.txt')
train_label   <- read.table('UCI HAR Dataset/train/y_train.txt')
train_subject <- read.table('UCI HAR Dataset/train/subject_train.txt')
test_data     <- read.table('UCI HAR Dataset/test/X_test.txt')
test_label    <- read.table('UCI HAR Dataset/test/y_test.txt')
test_subject  <- read.table('UCI HAR Dataset/test/subject_test.txt')

# Step 1
# Merge the training and test sets to create one data set
data    <- rbind(train_data, test_data)
label   <- rbind(train_label, test_label)
subject <- rbind(train_subject, test_subject)

# Step 2
# Extracts only the measurements on the mean and standard deviation for each 
# measurement.
feature <- read.table("UCI HAR Dataset/features.txt")
colnames(data) <- feature$V2
result <- data[, grep("-(mean|std)\\(\\)", colnames(data))]

# Step 3
# Use descriptive activity names to name the activities in the data set
activity <- read.table('UCI HAR Dataset/activity_labels.txt')
label[, 1] <- activity[label[, 1], 2]
colnames(label) <- 'activity'

# Step 4
# Appropriately label the data set with descriptive variable names
colnames(subject) <- 'subject'
all_data <- cbind(data, label, subject)

# Step 5
# Create a second, independent tidy data set with the average of each variable
# for each activity and each subject
library(plyr)
averages_data <- ddply(all_data, .(subject, activity), function(x) colMeans(x[,1:561]))
write.table(averages_data, "averages_data.txt", row.name=FALSE, col.names = TRUE, quote = FALSE)

