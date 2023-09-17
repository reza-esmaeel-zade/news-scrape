library(jsonlite)
load('yjc.RData')
load('hamshahri.RData')

data <- c(yjc, hamshahri)

rm(list = ls()[-4])

json_file <- "data.json"
write(toJSON(data, pretty = T), json_file)