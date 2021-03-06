# Packages
rm(list = ls())
library(shiny)

# get user interface (ui) and server (defines what is happening)
source("ui.R")
source("server.R")

# Create app
shinyApp(ui = ui, server = server)

