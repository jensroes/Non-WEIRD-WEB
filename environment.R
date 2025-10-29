# Packages
library(shiny)
library(shinythemes)
library(ggthemes)
library(tidyverse)
library(DT)
library(magrittr)
library(WVPlots)
library(stringi)
library(cowplot)
library(sjmisc)
library(janitor)
library(sf)
library(wbstats)
library(plotly)
library(rlang)
library(lingtypology)
library(rnaturalearthdata)
source("scripts/get_countries.R")


get_country <- function(data, longitude, latitude) {
  # Accept bare column names (tidy evaluation)
  lon_name <- as_name(enquo(longitude))
  lat_name <- as_name(enquo(latitude))
  
  # Convert to sf — use the selected columns
  points <- st_as_sf(data, coords = c(lon_name, lat_name), crs = 4326, remove = FALSE)
  
  # Load countries (this needs rnaturalearthdata to be installed on the server)
  countries <- rnaturalearth::ne_countries(scale = "medium", returnclass = "sf")
  
  # Spatial join and return the country names
  points_with_country <- st_join(points, countries["name_long"])
  points_with_country %>% pull(name_long)
}

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

language_data <- glottolog %>% 
  filter(level == "language") %>%
  select(-glottocode,-level,-iso,-area,-affiliation,-subclassification) %>%
  drop_na() %>%
  mutate(country = get_country(data = ., longitude, latitude),
         country = str_to_title(country),
         highlight = if_else(country == "Philippines", TRUE, FALSE),
         country = recode(country, Russia = "Russian Federation",
                                           Kyrgyzstan = "Kyrgyz Republic",
                                           Laos = "Lao PDR",
                                           Iran = "Iran, Islamic Rep.",
                                           Egypt = "Egypt, Arab Rep.",
                                           Yemen = "Yemen, Rep.",
                                           Uk = "United Kingdom",
                                           `South Korea` = "Korea, Rep.",
                                           Syria = "Syrian Arab Republic",
                                           `Republic Of The Congo` ="Congo, Rep.",
                                           Congo = "Congo, Dem. Rep.",
                                           `Cote D'ivoire` = "Côte d'Ivoire",
                                          Macedonia = 'Macedonia, FYR',
                                          `Hong Kong S.a.r.` = 'Hong Kong SAR, China',
                                          `Serbia And Montenegro` = 'Montenegro',
                                          `Bosnia-Herzegovina` = 'Bosnia and Herzegovina',
                                           `Myanmar (Burma)` = "Myanmar",
                                           `Equatorial Guinea` = "Papua New Guinea")) %>%
  drop_na() %>% 
  filter(!(country %in% c(weird, "Faroe Islands", "Isle Of Man" )))



