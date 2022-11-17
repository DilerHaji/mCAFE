setwd(".")
args = commandArgs(trailingOnly=TRUE)

# read evaporation-controlled data 

tab <- read.csv(args[1])

# combine consumption between capillaries for each chamber 

tab_combined <- setNames(aggregate(tab[, "top_consumption_corrected"], by = list(tab[, "time"], tab[, "chamber"], tab[, "treatment"], tab[, "treatment_value"]), function(x){ sum(x[x > 0] )}), nm = c("time", "chamber", "treatment", "treatment_value", "top_consumption_corrected"))
tab_combined2 <- setNames(aggregate(tab[, "top_consumption"], by = list(tab[, "time"], tab[, "chamber"], tab[, "treatment"], tab[, "treatment_value"]), function(x){ sum(x[x > 0] )}), nm = c("time", "chamber", "treatment", "treatment_value", "top_consumption"))

# add a column with the total ng consumed given either molecular weight and a final morality or a percentage
# this requires the treatment design (i.e., the concentrations for each of the treatments and controls) 

type <- as.character(args[2])

if(type %in% "molarity"){ 
  
  tab_combined$converted_consumption <- ((tab_combined[, "treatment_value"]/1000000) * (tab_combined[, "top_consumption_corrected"]/1000000) * args[4])*1000000
  
} else if(type %in% "percentage"){
  
  tab_combined$converted_consumption <- (tab_combined[, "treatment_value"]/100) * tab_combined[, "top_consumption_corrected"]
  
    }

tab_combined <- data.frame(tab_combined, top_consumption_uncorrected = tab_combined2[, "top_consumption"])

write.csv(x = tab_combined, file = as.character(args[3]), quote = FALSE, row.names = FALSE)
