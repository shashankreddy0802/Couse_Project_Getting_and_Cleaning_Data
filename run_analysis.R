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
col_names <- readLines("C:/R/GettingAndCleaningData-CourseProject-Cellphones/features.txt")

# Changing column names:
col_names <- gsub("\\(", "", col_names)
col_names <- gsub("\\)", "", col_names)
col_names <- gsub("-", "_", col_names)
col_names <- gsub(" ", "_", col_names)

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
# df_test: 2947 x 563

colnames(df_test) <- c(col_names, "labels", "subject")

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
# df_train: 2947 x 563

# Changing column names:
colnames(df_train) <- c(col_names, "labels", "subject")

# Rbinding the dataframes:
df <- rbind(df_test, df_train)
# df: 10299 x 563

# ------------------------------------------------------------------

# 2. Extracts only the measurements on the mean and standard
# deviation for each measurement.

# Getting the index of the columns where "mean" or "sd" appear: 
ind_mean_sd <- grep("mean|std", col_names)
ind_labels <- which(colnames(df) == "labels")
ind_subject <- which(colnames(df) == "subject")
ind_columns <- c(ind_mean_sd, ind_labels, ind_subject)
df_mean_sd <- df[ , ind_columns]
# df_mean_sd: 10299 x 81

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

This step has already been done.

# ------------------------------------------------------------------

# 5. From the data set in step 4, creates a second, independent
# tidy data set with the average of each variable for each activity
# and each subject.

tidy_df <- df_mean_sd

# Transformir the values from factor to numeric:
for(i in 1:79) {
  tidy_df[ ,i] <- as.numeric(as.character(tidy_df[ ,i]))
}

# Grouping the data by subject and activity:

tidy_df <- tidy_df[ ,c(81, 80, 1:79)]
tidy_df$labels <- as.character(tidy_df$labels)
tidy_df <- aggregate(tidy_df[3:81],
                     by = list(tidy_df$subject, tidy_df$labels),
                     FUN = mean)
colnames(tidy_df)[1] <- "subject"
colnames(tidy_df)[2] <- "activity"
order <- order(tidy_df$subject, tidy_df$activity)
tidy_df <- tidy_df[order, ]
rownames(tidy_df) <- 1:180

write.table(tidy_df, file = "tidy_dataset.txt", row.name=FALSE)
