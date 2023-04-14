library(tidyverse)
library(readxl)

cover <- read_xlsx("coverCZ-2023-04-02-IA.xlsx")
env <- read_xlsx("env-data-extra.xlsx")
nom <- read_xlsx("nomenclatureCZ-2023-04-07-IA.xlsx")
abund <- read_xlsx("tvabund.xlsx")
habita <- read_xlsx("tvhabita.xlsx")

names(nom)
names(habita)
names(env)

spe_long <- abund %>% 
  left_join(nom %>% select(SPECIES_NR, Kaplan, nonvascular, NO_CZ)) %>% 
  left_join(habita %>% select(RELEVE_NR, COVERSCALE, LONGITUDE, LATITUDE)) %>% 
  left_join(cover) %>% 
  select(-ID, -COVERSCALE, -CoverScaleName) %>% 
  filter(is.na(nonvascular) & is.na(NO_CZ)) %>% 
  select(-nonvascular, -NO_CZ, -SPECIES_NR)


