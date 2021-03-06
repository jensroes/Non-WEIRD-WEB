# Packages
library(shiny)
library(shinythemes)
library(ggthemes)
library(tidyverse)
#library(grid)
library(DT)
library(magrittr)
library(WVPlots)
library(stringi)
library(cowplot)
library(sjmisc)
library(janitor)
library(rnaturalearth)
library(wbstats)
library(plotly)
source("scripts/get_countries.R")

# Functions
#percentile <- function(x) return((x - min(x, na.rm = T)) / (max(x, na.rm = T) - min(x, na.rm = T)))
percentile <- function(x) return( rank(x)/max(rank(x)) )  

# Plot layout
theme_set(theme_bw(base_size = 16) + 
            theme(axis.ticks = element_blank(),
                  #panel.grid = element_blank(),
                  strip.background = element_blank(),
                  legend.position = "bottom",
                  legend.justification = "right"))

data <- read_csv("data/wbdata.csv") %>%
  mutate(highlight = if_else(country == "Philippines", TRUE, FALSE)) %>%
  filter(country %in% nonweird)

data_time <- read_csv("data/wbdata_timecourse.csv") %>%
  mutate(highlight = if_else(country == "Philippines", TRUE, FALSE)) %>%
  filter(country %in% nonweird)

