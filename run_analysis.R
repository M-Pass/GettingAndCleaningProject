rm(list=ls())
library(dplyr)
library(tidyr)

#### Loading training data ####
varnames <- read.table("UCI HAR Dataset/features.txt")[,2]

datatrain <- read.table("UCI HAR Dataset/train/X_train.txt", quote= "", nrows=7352, comment.char="")
colnames(datatrain) <- varnames

# Adding activity and subject info
datatrain <- cbind(read.table("UCI HAR Dataset/train/y_train.txt"), datatrain)
datatrain <- cbind(read.table("UCI HAR Dataset/train/subject_train.txt"), datatrain)

#### Loading test data ####
datatest <- read.table("UCI HAR Dataset/test/X_test.txt", quote= "", nrows=3000, comment.char="")
colnames(datatest) <- varnames

# Adding activity and subject info
datatest <- cbind(read.table("UCI HAR Dataset/test/y_test.txt"), datatest)
datatest <- cbind(read.table("UCI HAR Dataset/test/subject_test.txt"), datatest)

#### Merging the training and test datasets ####
data <- rbind(datatest, datatrain)
colnames(data)[1:2] <- c("Subject", "Activity")
rm(list=c("datatrain", "datatest", "varnames")) # cleaning up

data <- data[ , !duplicated(colnames(data))] # removing duplicate columns

data <- tbl_df(data) # preparing data for dplyr

#### Tidying the dataset ####
# huge chain incoming!
data <- data %>%
  # Selecting only variable with mean and sd information:
  select(Subject, Activity, contains("mean()"), contains("std()")) %>%
  # Creating descriptive activity names:
  mutate(Activity=factor(Activity, levels=1:6, labels=read.table("UCI HAR Dataset/activity_labels.txt")[,2])) %>%
  # Converting the dataframe in a long, tidy format:
  gather(key=Sensor, value=Value,-Subject,-Activity) %>%
  # I decided to consider the type of sensor measurement, the descriptive statistic computed and 
  # the spatial dimension of the measurement as three separate variables (as they are independent of
  # each other). This leaves the value measured as a single, very long column:
  separate(Sensor, into=c("Sensor", "Statistic", "Dimension")) %>%
  # Order dataframe:
  arrange(Subject, Activity, Sensor, Statistic, Dimension) %>%
  # Preparing for further analysis:
  group_by(Subject, Activity, Sensor, Statistic, Dimension)

# summarizing the data, obtaining means for each variable, divided by subject and activity:
data_summary <- summarize(data, Value=mean(Value))

# output :)
write.table(data_summary, "results.txt", row.name=FALSE)

