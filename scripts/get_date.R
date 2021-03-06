library(WDI)
library(tidyverse)
#library(wbstats)

#my_indicators <- c(
#  mobile = "gwp1_n",
#  internet = "IT.NET.USER.ZS"
#)

#d <- wbstats::wb_data(my_indicators)



mobile <- WDI(indicator = "gwp1_n") %>% #"Access to a mobile phone (% age 15+)" 
  group_by(country) %>% drop_na() %>%
  filter(year == max(year)) %>%
  rename(value = gwp1_n) %>% 
  select(iso2c,country, year, value) %>%
  mutate(vars = "mobile")

internet <- WDI(indicator = "IT.NET.USER.ZS") %>% #"Individuals using the Internet (% of population)"
  drop_na() %>%
  group_by(country) %>%
  filter(year == max(year)) %>%
  rename(value = `IT.NET.USER.ZS`) %>% 
  select(iso2c, country, year, value) %>%
  mutate(vars = "internet") 

internet2 <- WDI(indicator = "gwp2_n") %>% #"Access to internet (% age 15+)"  
  drop_na() %>%
  group_by(country) %>%
  filter(year == max(year)) %>%
  rename(value = "gwp2_n")  %>% 
  select(iso2c, country, year, value) %>%
  mutate(vars = "internet2") 

internet3 <- WDI(indicator = "IT.NET.BNDW") %>% #"International Internet bandwidth (Mbps)" 
  drop_na() %>%
  group_by(country) %>%
  filter(year == max(year)) %>%
  rename(value = "IT.NET.BNDW") %>% 
  select(iso2c,country, year, value) %>%
  mutate(vars = "internet3")

comp <- WDI(indicator = "IT.PC.HOUS.ZS") %>% # "Homes with a personal computer (%)" 
  drop_na() %>%
  group_by(country) %>%
  filter(year == max(year)) %>%
  rename(value = "IT.PC.HOUS.ZS") %>%
  select(iso2c,country, year, value) %>%
  mutate(vars = "comp")

lit <- WDI(indicator = "LO.PIAAC.LIT") %>% # PIAAC: Mean Adult Literacy Proficiency. Total
  drop_na() %>%
  group_by(country) %>%
  filter(year == max(year)) %>%
  rename(value = "LO.PIAAC.LIT") %>% 
  select(iso2c,country, year, value) %>%
  mutate(vars = "lit") 

lit2 <- WDI(indicator = "SE.ADT.LITR.ZS") %>% # "Literacy rate, adult total (% of people ages 15 and above)"
  drop_na() %>%
  group_by(country) %>%
  filter(year == max(year)) %>%
  rename(value = "SE.ADT.LITR.ZS") %>% 
  select(iso2c,country, year, value) %>%
  mutate(vars = "lit2")  

data <- bind_rows(mobile, internet, internet2, internet3, comp, lit, lit2) %>%
  ungroup() %>% 
  mutate(vars = recode(vars, mobile = "Access to a mobile phone (%, age 15+)",
                       internet = "Individuals using the Internet (% of population)",
                       internet2 = "Access to internet (%, age 15+)",
                       internet3 = "International Internet bandwidth (Mbps)",
                       comp = "Homes with a personal computer (%)",
                       lit = "PIAAC: Mean Adult Literacy Proficiency. Total",
                       lit2 = "Literacy rate, adult total (% of people ages 15 and above)"))

write_csv(data, "data/wbdata.csv")

#paste("'", mobile$country, "'", sep = "", collapse = ", ")
