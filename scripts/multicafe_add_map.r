setwd(".")

if(require(stringr)){
  library(stringr)
} else { 
  install.packages("stringr")
}

split <- function(x, y, z){
  unlist(lapply(str_split(x, y), "[", z)) 
}

args = commandArgs(trailingOnly=TRUE)

tab <- read.csv(as.character(args[1]))

design <- as.character(args[2]) 

design0 <- split(design, "/", 1:10)
design1 <- split(design0, "_", 1)
design2 <- split(design0, "_", 2)

for(i in 1:10){ 
  tab[tab[, "chamber"] %in% i, "treatment"] <- design1[i]
  tab[tab[, "chamber"] %in% i, "treatment_value"] <- design2[i]
  }

write.csv(x = tab, file = as.character(args[3]), quote = FALSE, row.names = FALSE)
