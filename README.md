# Couse Project - Getting and Cleaning Data

# The script is pretty straightforward. I've followed the 5 stpes listed on the project description.

# 1. I've merged the training and the test sets to create one data set. During this step, I've also cleaned the data and transformed
# the resulting vector into a dataframe. I've used the command "cbind" to bind the columns and "rbind" to  bind the rows. 

# 2. I've extracted only the measurements on the mean and standard deviation for the first three measurements.
# Obs: in order for the dataframe not to get too heavy, I've selected only the first 3 variables (tBodyAcc, tGravityAcc, 
# and tBodyAccJerk), both the mean and sd for each one of them. 

# 3. I've used descriptive activity names (WALKING, WALKING_UPSTAIRS, WALKING DOWNSTAIRS, SITTING, STANDING, LAYING) to name
# the activities in the data set. I've created a function called "change_label" in order to do that.

# 4. I've appropriately labeled the data set with descriptive variable names ("tBodyAcc-mean()-X", "tBodyAcc-mean()-Y", 
# "tBodyAcc-mean()-Z", "tBodyAcc-std()-X", "tBodyAcc-std()-Y", "tBodyAcc-std()-Z", "tGravityAcc-mean()-X", "tGravityAcc-mean()-Y",
# "tGravityAcc-mean()-Z", "tGravityAcc-std()-X", "tGravityAcc-std()-Y", "tGravityAcc-std()-Z", "tBodyAccJerk-mean()-X",
# "tBodyAccJerk-mean()-Y", "tBodyAccJerk-mean()-Z", "tBodyAccJerk-std()-X", "tBodyAccJerk-std()-Y", "tBodyAccJerk-std()-Z",
# "activity", "subject").

# 5. From the data set in step 4, I've created a second, independent tidy data set with the average of each variable for each activity
# and each subject.
