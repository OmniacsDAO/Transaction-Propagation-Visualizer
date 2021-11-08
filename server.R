## Load libraries
library(shinydashboard)
library(collapsibleTree)
library(httr)
library(jsonlite)
library(plyr)
library(xtable)
library(lubridate)
library(DT)
source("env.R")
options(scipen=9999)

## Define function to get HTML table for a node
get_node_html <- function(add,tx_dat,u_dat)
{
	node_data <- data.frame(
							Parameter = c("Node Name","Node Address","Level","Total Txs Received","Total Txs Sent","Total ETH Received","Total ETH Sent"),
							Value = c(
									u_dat$Name[match(add,u_dat$address)],
									add,
									u_dat$Level[match(add,u_dat$address)],
									sum(tx_dat$to==add),
									sum(tx_dat$from==add),
									paste(sum(as.numeric(tx_dat$value[tx_dat$to==add]))/10^18,"ETH"),
									paste(sum(as.numeric(tx_dat$value[tx_dat$from==add]))/10^18,"ETH")
								)
							)
	rownames(node_data) <- NULL
	print(xtable(node_data), type = "html")
}

function(input, output, session)
{
	## Tx Data
	tx_dat_r <- reactiveFileReader(1000, session, 'data_body.RDS', readRDS)

	## Make Tree Data
	observeEvent(input$push_track,
	{
		data_body <- data.frame()
		saveRDS(data_body,"data_body.RDS")
		data_user <- data.frame(address=tolower(input$add_track),Level="0")
		saveRDS(data_user,"data_user.RDS")
		PUT(table_url, add_headers(Authorization = paste0("Bearer ",proj_api_key),'Content-Type'="application/json"),body = toJSON(data_user,auto_unbox = TRUE), encode = "raw")
  	})
	

	output$Tree <- renderCollapsibleTree({
											# u_dat <- readRDS("data_user.RDS")
											# tx_dat <- readRDS("data_body.RDS")
											u_dat <- readRDS("data_user.RDS")
											u_dat$Name <- paste0("Add:",1:nrow(u_dat))
											tx_dat <- tx_dat_r()
											tx_dat_old <- data.frame(from_Name=NA,to_Name = "Add:1",from=NA,to=u_dat$address[u_dat$Level=="0"],value=0,from_Level=0,to_Level=0)
											if(nrow(tx_dat) ==0)
											{
												tx_dat_plot <- tx_dat_old
											}
											if(nrow(tx_dat)>0)
											{
												tx_dat$to_Level <- as.numeric(u_dat$Level[match(tx_dat$to,u_dat$address)])
												tx_dat$from_Level <- as.numeric(u_dat$Level[match(tx_dat$from,u_dat$address)])
												tx_dat$to_Name <- u_dat$Name[match(tx_dat$to,u_dat$address)]
												tx_dat$from_Name <- u_dat$Name[match(tx_dat$from,u_dat$address)]
												tx_dat_plot <- rbind.fill(tx_dat_old,tx_dat[tx_dat$from_Level < tx_dat$to_Level,][,c(13,12,2:3,8,11,10)])
											}
											tx_dat_plot$tooltip <- sapply(tx_dat_plot$to,get_node_html,tx_dat=tx_dat,u_dat=u_dat)
											collapsibleTreeNetwork(tx_dat_plot,collapsed = FALSE,attribute="to",nodeSize="leafCount",tooltipHtml="tooltip",fontSize=10)
									})
	output$Tx_table <- renderDataTable({
												tx_dat <- tx_dat_r()
												if(nrow(tx_dat) ==0) return(NULL)
												out_tab <- data.frame(
																		Time = as_datetime(as.numeric(tx_dat$block_timestamp)),
																		From = tx_dat$from,
																		To = tx_dat$to,
																		Value = paste0(as.numeric(tx_dat$value)/10^18," ETH"),
																		"Tx Link" = paste0('<a href="',paste0("https://rinkeby.etherscan.io/tx/",tx_dat$tx_hash),'">View</a>'),
																		check.names=FALSE
																	)
												datatable(
															out_tab[order(out_tab$Time,decreasing=TRUE),],
															escape=FALSE,selection = 'none',
															rownames=FALSE,
															options = list(pageLength = 10,bInfo = FALSE,searching=FALSE)
														)%>%formatDate(1, method = 'toLocaleString')
										})
}
