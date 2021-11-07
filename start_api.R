## Loading Required Libraries
require(jsonlite)
require(httr)
source("env.R")

## Initial Data
data_body <- data.frame()
saveRDS(data_body,"data_body.RDS")
data_user <- data.frame(address="0xb5d6801bc3dd17648e66ae22b80757692b1c5a42",Level="0")
saveRDS(data_user,"data_user.RDS")
PUT(table_url, add_headers(Authorization = paste0("Bearer ",proj_api_key),'Content-Type'="application/json"),body = toJSON(data_user,auto_unbox = TRUE), encode = "raw")

## Start API
library(plumber)
library(jsonlite)
bot_api <- plumber::plumb("parsiq_api.R")
bot_api$run(host = '0.0.0.0', port = 6789)
