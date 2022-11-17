setwd(".")

if(require(tidyr)){
  library(tidyr)
} else { 
  install.packages("tidyr")
}

if(require(stringr)){
  library(stringr)
} else { 
  install.packages("stringr")
}

split <- function(x, y, z){
  unlist(lapply(str_split(x, y), "[", z)) 
}

args = commandArgs(trailingOnly=TRUE)

# Read in long format data table 
# Use the multicafe_make_long.r script to generate this
# The file needs to be in .csv format, which is the default output format for the multicafe_make_long.r script 

tab <- read.csv(as.character(args[1]))
num <- c(as.numeric(args[3:length(args)]))


x <- dat_combined[dat_combined$Cage_ID %in% 1 & dat_combined$Cap %in% "L", ]






# Find the average consumption between the left and right capillaries in the evaporation chamber 
# This subsets the column named "top_consumption" which matches the values from the top_consumption spreadsheet from icy 
# The evaporation chamber ID is given as a parameter to this script 

tab_ag <- aggregate(tab[tab[, "chamber"] %in% num, "top_consumption"], by = list(tab[tab[, "chamber"] %in% num, "time"]), mean)

# For each of the chamber/capillary combinations, subtract the average evaporation top_consumption for each time point

tab_temp <- tab[, c("time", "top_consumption")]
tab_temp$chamcap <- paste(tab[, "chamber"], tab[, "cap"], tab[, "treatment"], tab[, "treatment_value"], sep = "_")
tab_temp <- spread(data = tab_temp, key = chamcap, value = top_consumption)

tab_temp2 <- data.frame(apply(tab_temp, 2, function(x){ x - tab_ag[,2]}), check.names = FALSE)
tab_temp2 <- tab_temp2[, -1]
tab_temp2 <- data.frame(time = tab_temp[,  "time"], tab_temp2, check.names = FALSE)

tab_temp3 <- gather(tab_temp2, key = chamcap, value = top_consumption, 2:dim(tab_temp2)[2])

tab_final <- data.frame(time = tab_temp3[, "time"], 
                        chamber = split(tab_temp3$chamcap, "_", 1),
                        cap = split(tab_temp3$chamcap, "_", 2),
                        treatment = split(tab_temp3$chamcap, "_", 3),
                        treatment_value = split(tab_temp3$chamcap, "_", 4),
                        top_consumption = tab[, "top_consumption"],
                        top_consumption_corrected = tab_temp3[, "top_consumption"], check.names = FALSE)

# Write the output 

write.csv(x = tab_final, file = as.character(args[2]), quote = FALSE, row.names = FALSE)

