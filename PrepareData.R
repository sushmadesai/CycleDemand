#Set the working directoryy
setwd("c://sushma/ds/cycle")

#Required libraries
library(gbm)
library(lubridate)

Train = F
if( Train == T) {
train <- read.csv(file = "train.csv",header=T,stringsAsFactors=F )
} else 
{
  train <- read.csv(file = "test.csv",header=T,stringsAsFactors=F )  
}

# Extract year, month, hour and day of the week.
train$datetime = ymd_hms(train$datetime)
train$mon = month(train$datetime,label=T)
train$year=year(train$datetime)
train$wday = wday(train$datetime,label = T)
train$hour = hour(train$datetime)

#Factorise the categorical variables.
train$season = factor(train$season,c(1,2,3,4),ordered=F)
train$holiday = factor(train$holiday,c(0,1),ordered=F)
train$workingday = factor(train$workingday,c(0,1),ordered=F)
train$weather = factor(train$weather,c(1,2,3,4),ordered=T)


#feature scaling

train$windspeedn = (train$windspeed - mean(train$windspeed))/sd(train$windspeed)
train$tempn = (train$temp - mean(train$temp))/sd(train$temp)
train$atempn = (train$atemp - mean(train$atemp))/sd(train$atemp)
train$humidityn = (train$humidity - mean(train$humidity))/sd(train$humidity)

if (Train == T )
{
  traincyc <- train
  #Conver the count to log. Since the evaluation is in Log
  traincyc$logcount = log1p(traincyc$count)
} else
{
  test <- train
}

