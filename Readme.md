Hi!
## Warning: the script requires both dplyr and tidyr

## Loading data
The script run_analysis.R loads the training and test sets (provided the folder "UCI HAR Dataset" is in the work directory). 

Activity and subject info are loaded, respectively, from y_train.txt/y_test.txt and subject_train.txt/subject_test.txt - all included in the original data archive. Column names are obtained from features.txt and activity labels from activity_labels.txt (both in the main UCI HAR Dataset folder). 

The two dataframes are merged in a single dataframe (data) and duplicate columns are removed. 

## Tidying data
Only sensor measures with either "mean()" or "std()" in the name are included for analysis. Columns containing "meanFreq()" are NOT included, as features_info.txt makes it clear that meanFreq is a descriptive statistic different from the simple average of the values. 

The aim of the next section is to reorganize the dataset in a tidy long format. 

The original dataset mixed three type of information in each variable (sensor information considered, descriptive statistic computed and spatial dimension measured). After running run_analysis.R, these three informations are split in three different variables, respectively named "Sensor", "Statistic" and "Dimension". For each observation, the measurement obtained is stored in the column "Value". 

Note that this decision generates some missing values in the variable "Dimension", as all the magnitude sensor measurements have no spatial dimension associated to them. It could be argued that it would have been best not to split the two variables Sensor and Dimension. However, I personally believe that this kind of organization is more reflective of the data (as those variables are effectively separate) and simplifies further analysis that want to compare, e.g., average values on dimension X for all kinds of sensor measurement/activities. 

## Analysis
A simple call to summarize(), at the end of the script, returns means for each combination of Subject, Activity and variable measured (sensor x statistic x spatial dimension). 