setwd(".")

if(require(tidyverse)){
  library(tidyverse)
} else { 
  install.packages("tidyverse")
}

if(require(readxl)){
  library(readxl)
} else { 
  install.packages("readxl")
}

source("scripts/packages.r")

args = commandArgs(trailingOnly=TRUE)

input <- as.character(args[1])

dat <- list()
dat[["topraw"]] <- read_excel(path = input, sheet = "topraw")
dat[["toplevel"]] <- read_excel(path = input, sheet = "toplevel")
dat[["toplevelLR"]] <- read_excel(path = input, sheet = "toplevel_L+R")
dat[["topdelta"]] <- read_excel(path = input, sheet = "topdelta")
dat[["topdeltaLR"]] <- read_excel(path = input, sheet = "topdelta_L+R")
dat[["bottomlevel"]] <- read_excel(path = input, sheet = "bottomlevel")

gather_data <- function(x){
  gather(data = x, key = time, value = topraw, which(colnames(x) %in% "t0"):dim(x)[2])
}

dat_gathered <- lapply(dat, FUN = gather_data)

dat_combined <- data.frame(
  dat_gathered[["topraw"]], 
  toplevel = dat_gathered[["toplevel"]]$topraw,
  toplevelLR = dat_gathered[["toplevelLR"]]$topraw,
  topdelta = dat_gathered[["topdelta"]]$topraw,
  topdeltaLR = dat_gathered[["topdeltaLR"]]$topraw,
  bottomlevel = dat_gathered[["bottomlevel"]]$topraw
)


# Change chamber names

dat_combined$Cage_ID <- as.character(as.numeric(sub(pattern = "A", x = dat_combined$Cage_ID, replacement = ""))+1)
dat_combined$Cage_ID  <- factor(dat_combined$Cage_ID, levels = c("1","2","3","4","5","6","7","8","9","10"))

# Save new spreadsheet 

write.csv(x = dat_combined, file = as.character(args[2]), quote = FALSE, row.names = FALSE, )






