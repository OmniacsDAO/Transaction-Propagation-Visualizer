#' @post /
function(req)
{
  ## Loading Required Libraries
  require(jsonlite)
  require(httr)
  source("env.R")

  ## Receive Call Data
  data_call <- as.data.frame(jsonlite::fromJSON(req$postBody))

  ## Receive User Data
  data_usr <- fromJSON(content(GET(table_url, add_headers(Authorization = paste0("Bearer ",proj_api_key))),"text"))

  ####################################################
  ## Manage Local Data
  ####################################################
  data_body <- readRDS("data_body.RDS")
  data_body <- rbind(data_body,data_call)
  saveRDS(unique(data_body),"data_body.RDS")
  ####################################################
  ####################################################

  ####################################################
  ## Manage User Data
  ####################################################
  data_user <- readRDS("data_user.RDS")
  data_user$Level <- as.numeric(data_user$Level)
  if(!(data_call$to %in% data_user$address))
  {
    n_d_u <- data.frame(address = data_call$to, Level = data_user$Level[match(data_call$from,data_user$address)]+1)
    data_user <- rbind(data_user,n_d_u)
    data_user$Level <- as.character(data_user$Level)
    saveRDS(unique(data_user),"data_user.RDS")
    PUT(table_url, add_headers(Authorization = paste0("Bearer ",proj_api_key),'Content-Type'="application/json"),body = toJSON(data_user,auto_unbox = TRUE), encode = "raw")
  }
  ####################################################
  ####################################################
}