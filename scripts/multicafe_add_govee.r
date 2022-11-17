#### Set the working directory as the current directory ####
setwd(".")


#### Installing packages if they are not already installed and then loading them #### 
if(require(stringr)){
  library(stringr)
} else { 
  install.packages("stringr")
}


#### Defining a convenience function to use str_split #### 
split <- function(x, y, z){
  unlist(lapply(str_split(x, y), "[", z)) 
}


#### Get all of the arguments given at the command line ####
args = commandArgs(trailingOnly=TRUE)


#### Load consumption table (first argument given at command line) ####
#### Load govee data (second argument given at command line) ####
tabc <- read.csv(as.character(args[1]))
tabg <- read.csv(as.character(args[2]))


#### Get the time incrememnt unit (options are "hour", "minute", or "second") 
increment_unit = as.character(args[3])

#### Get the time increments used for data capture during the experiment ####
increment = args[4]

#### Get the start time of the experiment ####
start = as.character(args[5])

#### Separating date information into individual units #### 
year <- as.numeric(split(split(tabg[, 1], " ", 1), "-", 1))
month <- as.numeric(split(split(tabg[, 1], " ", 1), "-", 2))
day <- as.numeric(split(split(tabg[, 1], " ", 1), "-", 3))
hour <- as.numeric(split(split(tabg[, 1], " ", 2), ":", 1))
minute <- as.numeric(split(split(tabg[, 1], " ", 2), ":", 2))
second <-  as.numeric(split(split(tabg[, 1], " ", 2), ":", 3))


#### Adding date units back into the original govee data table ####
tabg <- cbind(tabg, data.frame(year = year, month = month, day = day, hour = hour, minute = minute, second = second))


#### Getting the start values for the experiment ####
tmp <-data.frame(
  NA,
  NA,
  NA,
  NA, 
  as.numeric(split(split(start, "/", 1), "-", 1)), 
  as.numeric(split(split(start, "/", 1), "-", 2)),
  as.numeric(split(split(start, "/", 2), ":", 1)),
  as.numeric(split(split(start, "/", 2), ":", 2)),
  as.numeric(split(split(start, "/", 2), ":", 3)))

colnames(tmp) <- colnames(tabg)


#### Adding the start values to the govee data table ####
tabg <- rbind(tabg, tmp)

#### Ordering the table by date ####
tabg <- tabg[order(tabg$month, tabg$day, tabg$day, tabg$hour, tabg$minute, tabg$second),]

#### Removing the everything before the start time ####

top_remove <- which(
  tabg[, 5] == tmp[,5] & 
  tabg[, 6] == tmp[,6] &
  tabg[, 6] == tmp[,6] &
  tabg[, 7] == tmp[,7] &
  tabg[, 8] == tmp[,8] & 
  tabg[, 9] == tmp[,9])

top_remove <- top_remove[length(top_remove)]

tabg <- tabg[-(1:top_remove), ]

#### Getting aggregated data for time increments (using mean values for temperature and humidity) ####
if(increment_unit %in% "hour"){ 
  
  #### Aggregate by hour ####
  tabg$cut <- cut(tabg$hour, breaks = seq(0, 24, as.numeric(increment)), include.lowest = TRUE)
  temp <- setNames(aggregate(tabg[, 2], by = list(tabg$year, tabg$month, tabg$day, tabg$cut), mean), c("year", "month", "day", "cut", "temperature"))
  hum <- setNames(aggregate(tabg[, 3], by = list(tabg$year, tabg$month, tabg$day, tabg$cut), mean), c("year", "month", "day", "cut", "humidity"))
  
} else if(increment_unit %in% "minute"){ 
  
  #### Aggregate by minute ####
  tabg$cut <- cut(tabg$minute, breaks = seq(0, 60, as.numeric(increment)), include.lowest = TRUE)
  temp <- setNames(aggregate(tabg[, 2], by = list(tabg$year, tabg$month, tabg$day, tabg$cut), mean), c("year", "month", "day", "cut", "temperature"))
  hum <- setNames(aggregate(tabg[, 3], by = list(tabg$year, tabg$month, tabg$day, tabg$cut), mean), c("year", "month", "day", "cut", "humidity"))

} else if(increment_unit %in% "second"){ 
  
  #### Aggregate by second ####
  tabg$cut <- cut(tabg$second, breaks = seq(0, 60, as.numeric(increment)), include.lowest = TRUE)
  temp <- setNames(aggregate(tabg[, 2], by = list(tabg$year, tabg$month, tabg$day, tabg$cut), mean), c("year", "month", "day", "cut", "temperature"))
  hum <- setNames(aggregate(tabg[, 3], by = list(tabg$year, tabg$month, tabg$day, tabg$cut), mean), c("year", "month", "day", "cut", "humidity"))
  
  }


#### Numbering the increments as in the consumption data ####
tabg$time <- seq(0, dim(tabg)[1]-1, 1)


#### Saving quick temperature and humidity plots ####
png(paste("govee_plots/", split(as.character(args[6]), "[.]", 1), "_temp.png", sep = ""))
plot(tabg$time, tabg$Temperature_Fahrenheit, xlab = "Time", ylab = "Temp (F)")
dev.off()

png(paste("govee_plots/", split(as.character(args[6]), "[.]", 1), "_humidity.png", sep = ""))
plot(tabg$time, tabg$Relative_Humidity, xlab = "Time", ylab = "Relative Humidity (%)")
dev.off()

#### Adding the govee data to the consumption table #### 
tabc$temperature <- tabg[,2][match(tabc$time, tabg$time)]
tabc$humidity <- tabg[,3][match(tabc$time, tabg$time)]


#### Writing new output
write.csv(x = tabc, file = as.character(args[6]), quote = FALSE, row.names = FALSE)


