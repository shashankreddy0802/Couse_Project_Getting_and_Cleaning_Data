# 1. Merges the training and the test sets to create one data set:

# Downloading the data:
test1 <- readLines("C:/R/GettingAndCleaningData-CourseProject-Cellphones/test/X_test.txt")
  # test set (2947 x 561)
test2 <- readLines("C:/R/GettingAndCleaningData-CourseProject-Cellphones/test/y_test.txt")
  # test labels (2947) - 1 to 6
test3 <- readLines("C:/R/GettingAndCleaningData-CourseProject-Cellphones/test/subject_test.txt")
  # subject test (2947)
train1 <- readLines("C:/R/GettingAndCleaningData-CourseProject-Cellphones/train/X_train.txt")
  # train test (7352 x 561)
train2 <- readLines("C:/R/GettingAndCleaningData-CourseProject-Cellphones/train/y_train.txt")
  # train labels (7352) - 1 to 6
train3 <- readLines("C:/R/GettingAndCleaningData-CourseProject-Cellphones/train/subject_train.txt")
  # subject train (7352)

# Working with the "test" files:

# Cleaning the data from the X_test file and transforming the
# resulting vector into a dataframe:
test_set <- strsplit(test1, " ")
test_set <- unlist(test_set)
empty <- test_set == ""
test_set <- test_set[!empty]
test_set <- as.data.frame(matrix(test_set, ncol = 561))

# Reading the y_test file and transforming the data:
test_labels <- as.numeric(test2)

# Reading the subject_test file and transforming the data:
subject_test <- as.numeric(test3)

# Cbinding the columns:
df_test <- cbind(test_set, test_labels, subject_test)

# Changing column names:
colnames(df_test) <- c(1:561, "labels", "subject")

# Working with the "training" files:

# Cleaning the data from the X_train file and transforming the
# resulting vector into a dataframe:
train_set <- strsplit(train1, " ")
train_set <- unlist(train_set)
empty <- train_set == ""
train_set <- train_set[!empty]
train_set <- as.data.frame(matrix(train_set, ncol = 561))

# Reading the y_train file and transforming the data:
train_labels <- as.numeric(train2)

# Reading the subject_train file and transforming the data:
subject_train <- as.numeric(train3)

# Cbinding the columns:
df_train <- cbind(train_set, train_labels, subject_train)

# Changing column names:
colnames(df_train) <- c(1:561, "labels", "subject")

# Rbinding the dataframes:
df <- rbind(df_test, df_train)

# ------------------------------------------------------------------

# 2. Extracts only the measurements on the mean and standard
# deviation for each measurement. Obs: in order for the dataframe
# not to get too heavy, I've selected only the first 3 variables.

mean_sd_columns <- c(1:6, 41:46, 81:86, "labels", "subject")
df_mean_sd <- df[ , mean_sd_columns]

# ------------------------------------------------------------------

# 3. Uses descriptive activity names to name the activities in
# the data set:

change_label <- function(label) {
  if(label == 1) {
    return("WALKING")
  }
  if(label == 2) {
    return("WALKING UPSTAIRS")
  }
  if(label == 3) {
    return("WALKING DOWNSTAIRS")
  }
  if(label == 4) {
    return("SITTING")
  }
  if(label == 5) {
    return("STANDING")
  }
  if(label == 6) {
    return("LAYING")
  }
}

df_mean_sd$labels <- lapply(df_mean_sd[['labels']], change_label)

# ------------------------------------------------------------------

# 4. Appropriately labels the data set with descriptive
# variable names.

colnames(df_mean_sd) <- c("tBodyAcc-mean()-X", "tBodyAcc-mean()-Y",
                          "tBodyAcc-mean()-Z", "tBodyAcc-std()-X",
                          "tBodyAcc-std()-Y", "tBodyAcc-std()-Z",
                          "tGravityAcc-mean()-X", "tGravityAcc-mean()-Y",
                          "tGravityAcc-mean()-Z", "tGravityAcc-std()-X",
                          "tGravityAcc-std()-Y", "tGravityAcc-std()-Z",
                          "tBodyAccJerk-mean()-X", "tBodyAccJerk-mean()-Y",
                          "tBodyAccJerk-mean()-Z", "tBodyAccJerk-std()-X",
                          "tBodyAccJerk-std()-Y", "tBodyAccJerk-std()-Z",
                          "activity", "subject")

# ------------------------------------------------------------------

# 5. From the data set in step 4, creates a second, independent
# tidy data set with the average of each variable for each activity
# and each subject.

tidy_df <- df_mean_sd

# Transformir the values from factor to numeric:
for(i in 1:18) {
  tidy_df[ ,i] <- as.numeric(as.character(tidy_df[ ,i]))
}

# Creating new columns for the mean of each variable:
tidy_df["tBodyAcc_mean"] <- rowMeans(tidy_df[c(1,2,3)])
tidy_df["tBodyAcc_std"] <- rowMeans(tidy_df[c(4,5,6)])
tidy_df["tGravityAcc_mean"] <- rowMeans(tidy_df[c(7,8,9)])
tidy_df["tGravityAcc_std"] <- rowMeans(tidy_df[c(10,11,12)])
tidy_df["tBodyAccJerk_mean"] <- rowMeans(tidy_df[c(13,14,15)])
tidy_df["tBodyAccJerk_std"] <- rowMeans(tidy_df[c(16,17,18)])

# Eliminating the columns that will no longer be used:
tidy_df <- tidy_df[ , -(1:18)]

# Grouping the data by subject and activity:
library(dplyr)
tidy_df <- tbl_df(tidy_df)
tidy_df$activity <- as.character(tidy_df$activity)
select(tidy_df, 2, 1, 3, 4, 5, 6, 7, 8)
by_subject <- group_by(tidy_df, subject, activity) 

tidy_df <- summarize(by_subject, tBodyAcc_mean = mean(tBodyAcc_mean),
          tBodyAcc_std = mean(tBodyAcc_std),
          tGravityAcc_mean = mean(tGravityAcc_mean),
          tGravityAcc_std = mean(tGravityAcc_std),
          tBodyAccJerk_mean = mean(tBodyAccJerk_mean),
          tBodyAccJerk_std = mean(tBodyAccJerk_std))
