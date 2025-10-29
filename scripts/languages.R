library(tidyverse)
library(lingtypology)
library(janitor)
library(htmlwidgets)
library(leaflet)

data <- read_csv("https://goo.gl/GgscBE") %>% clean_names()
data %>%
  mutate(language_name = gsub(pattern = " ", replacement = "", language_name)) %>% 
  filter(is.glottolog(language_name) == TRUE) %>% 
  filter(area.lang(language_name) == "Africa") %>% 
  select(language_name) %>% 
  map.feature()

data %>%
  mutate(language_name = gsub(pattern = " ", replacement = "", language_name)) %>% 
  filter(is.glottolog(language_name) == TRUE) %>% 
  filter(area.lang(language_name) == "Africa") %>% 
  select(language_name) %>% 
  map.feature(., minimap = TRUE)

language_data <- glottolog %>% filter(level == "language") %>%
  select(-glottocode,-level,-iso,-area,-affiliation) %>%
  drop_na() %>%
  mutate(country = get_country(data = ., longitude, latitude),
         country = str_to_title(country))

map.feature(c("French", "Occitan")) %>% 
  fitBounds(0, 40, 10, 50) %>% 
  addPopups(2, 48, "Great day!")

m <- map.feature(c("Adyghe", "Korean"))
#saveWidget(m, file="TYPE_FILE_PATH/m.html")

df <- data.frame(language = c("Adyghe", "Kabardian", "Polish", "Russian", "Bulgarian"),
                 features = c("polysynthetic", "polysynthetic", "fusional", "fusional", "fusional"))

#map.feature(languages = df$language,
#            features = df$features)




