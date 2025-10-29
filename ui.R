source("environment.R")

ui <- fluidPage(
  # Setup title part ---------------------------
  titlePanel(
    windowTitle = "Non-WEIRD web-based", #this appears in the browser tab
    title = h1("Web-based sampling in Global South countries",
            h4("by Jens Roeser & Rowena Garcia"),
            h4("email: jens.roeser@ntu.ac.uk"),
            h4(""))
          ),
  
  # Themes changes app layout
  theme = shinytheme("sandstone"),
#  shinythemes::themeSelector(),  # <--- Add this somewhere in the UI
  navbarPage("non-WEIRD app",
  # Inputs
  sidebarLayout(
    sidebarPanel( 
      selectInput('country', 
                  'Select country/ies', 
                  c(nonweird), 
                  selected = "Philippines",
                  multiple = T),
      selectInput('vars',
                  'Select variables',
                  unique(data$vars),
                  selected = unique(data$vars),
                  multiple = T),
      downloadButton("downloadData", 'Download summary')),
    fluidPage(
      mainPanel(
        tabsetPanel(id = "tabs",
          tabPanel("Summary",
                   h2(),
                   dataTableOutput("summary")),
          tabPanel("Plot",
                   tags$style(type="text/css",
                              ".shiny-output-error { visibility: hidden; }",
                              ".shiny-output-error:before { visibility: hidden; }"
                   ),
                   plotOutput('mobile_plot', width = "100%")),
          tabPanel("Timecourse",
                   tags$style(type="text/css",
                              ".shiny-output-error { visibility: hidden; }",
                              ".shiny-output-error:before { visibility: hidden; }"
                   ),
                   plotOutput('timecourse', width = "100%")),
          tabPanel("Map",
  #                 tags$style(type="text/css",
  #                            ".shiny-output-error { visibility: hidden; }",
  #                            ".shiny-output-error:before { visibility: hidden; }"
  #                 ),
                    fluidRow(
                      column(width = 12, plotOutput("map")),
                      h1(),
                      column(width = 12, plotOutput("map2"))
                    )
  #                 plotlyOutput('map', width = "100%"),
   #                h2(),
    #               plotOutput('map2', width = "100%"))
            ),
        tabPanel("Language distribution", 
                 fluidRow(
                   column(width = 12, plotOutput("map_language")),
                   h1(),
                   column(width = 12, plotOutput("no_of_langs"))
                 )
          )
        )
      )
    )
  )
)
)