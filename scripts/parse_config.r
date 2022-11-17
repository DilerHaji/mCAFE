#### Loading in the arguments give at the command line #### 
args = commandArgs(trailingOnly=TRUE)

#### Getting the first command line argument only (i.e., the master script) #### 
arg = as.character(args[1])

#### Saving the contents of the first argument given at the command line (i.e., config file) #### 
sys <- system(paste("cat", arg, sep =" "), intern = TRUE)

#### Getting the number of experiments (rigs) from the config file #### 
num_experiments <- as.numeric(sys[grep(pattern = "num_experiments", sys)+1])

#### Getting the paired files for each experiment from the config file #### 
pairs <- sys[ (grep(pattern = "filenames", sys)+1):(grep(pattern = "filenames", sys)+num_experiments) ]

#### Getting Govee data from the config file ####
gov <- sys[ (grep(pattern = "govee_tables", sys)+1):(grep(pattern = "govee_tables", sys)+num_experiments) ]
