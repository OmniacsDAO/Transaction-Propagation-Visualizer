## Load libraries
library(shinydashboard)
library(collapsibleTree)
library(httr)
library(jsonlite)

dashboardPage(
	dashboardHeader(title = "PARSIQ Tx Viz"),

    dashboardSidebar(
		sidebarMenu(
			id = "tabs",
			menuItem("Configure", tabName = "config", icon = icon("cogs")),
			menuItem("Visualisation", tabName = "vis", icon = icon("chart-line"))
		)
	),

	dashboardBody(
		tabItems(
			tabItem(tabName = "config",
				column(width = 12,
					textInput("add_track", label = h3("Address To Track "), value = "0xB5d6801bC3dd17648e66aE22B80757692b1C5a42"),
					actionButton("push_track", label = "Start Tracking"),
					# uiOutput("aum_writeup")
				)
			),
			tabItem(tabName = "vis",
				column(width = 12,
					collapsibleTreeOutput("aa"),
					# hr(),
					# uiOutput("b_tok_writeup")
				)
			)
		)
	)
)