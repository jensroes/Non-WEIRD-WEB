install.packages('WDI')
library(remotes)
install_github('vincentarelbundock/WDI')
library(tidyverse)
WDIsearch('literacy')

WDIsearch('reading')


WDIsearch('gdp.*')$name

(ids <- WDIsearch(''))
desc <- ids %>% as_tibble() %>% pull(name)
ids <- ids %>% as_tibble() %>% pull(indicator)

glimpse(WDI(indicator = ids[10]))
ids[50]
desc[20]
    

WDIsearch('gdp.*capita.*constant')$indicator

WDI(indicator = "SE.ADT.LITR.ZS") %>% # "Literacy rate, adult total (% of people ages 15 and above)"
  drop_na() %>%
  group_by(country) %>%
  filter(year == max(year)) 


# from CRAN
install.packages("OECD")

# from Github
library(devtools)
install_github("expersso/OECD")

library(OECD)
dataset_list <- get_datasets()
search_dataset("internet", data = dataset_list)
dataset <- "ICT_IUSERS"
dstruc <- get_data_structure(dataset)
str(dstruc, max.level = 1)
dstruc$LOCATION
get_dataset(dataset = dataset)
