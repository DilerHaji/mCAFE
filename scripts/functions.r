split <- function(x, y, z){
  unlist(lapply(str_split(x, y), "[", z)) 
}
