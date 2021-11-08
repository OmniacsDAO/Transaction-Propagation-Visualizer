## Load libraries
library(shinydashboard)
library(collapsibleTree)
library(httr)
library(jsonlite)
library(DT)

dashboardPage(
	dashboardHeader(
						title = "PARSIQ Tx Viz",
						tags$li(a(
									href = 'https://parsiq.net',
									target="_blank",
									img(src = 'parsiq_logo.png',title = "PARSIQ", height = "30px"),
									style = "padding-top:10px; padding-bottom:10px;"
								),
						class = "dropdown"
						)
					),

    dashboardSidebar(
		sidebarMenu(
			id = "tabs",
			menuItem("Configure", tabName = "config", icon = icon("cogs")),
			menuItem("Visualisation", tabName = "vis", icon = icon("chart-line")),
			menuItem("Transactions", tabName = "txs", icon = icon("arrows-alt-h"))
		)
	),

	dashboardBody(
		tabItems(
			tabItem(tabName = "config",
				column(width = 12,
					textInput("add_track", label = h3("Address To Track "), value = "0xB5d6801bC3dd17648e66aE22B80757692b1C5a42"),
					actionButton("push_track", label = "Start Tracking")
				)
			),
			tabItem(tabName = "vis",
				column(width = 12,
					collapsibleTreeOutput("Tree")
				)
			),
			tabItem(tabName = "txs",
				column(width = 12,
					dataTableOutput('Tx_table')
				)
			)
		)
	)
)