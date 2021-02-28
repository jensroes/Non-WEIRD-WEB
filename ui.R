source("environment.R")

ui <- fluidPage(
  # Setup title part ---------------------------
  titlePanel(
    windowTitle = "Non-WEIRD web-based", #this appears in the browser tab
    title = h1("Web-based sampling in non-WEIRD countries",
               h4("by Jens Roeser & Rowena Garcia"),
               h4("email: jens.roeser@ntu.ac.uk"),
               h4("Source: World Bank"))),
  
  # Themes changes app layout
  theme = shinytheme("cosmo"),
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
    mainPanel(
      tabsetPanel(id = "tabs",
        tabPanel("Summary",
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
                 tags$style(type="text/css",
                            ".shiny-output-error { visibility: hidden; }",
                            ".shiny-output-error:before { visibility: hidden; }"
                 ),
                 plotOutput('map', width = "100%"))
      )
      )
    )
  )
)