library(magrittr)
library(tidyverse)
library(readxl)


#' tvhabita - header data, each releve has RELEVE_NR code, which matches the one in tvabund

#' species - to translate the species codes to species names we further need species list which is stored in
#'' Turbowin/species as species.dbf

#' nomenclature - alternative approach to species - I created a special file where the codes in Turboveg are directly
#' matched to more name variants/ Danihelka, Kaplan, ESy  (file name: nomenclatureCZ-2023-04-02-IA)

#' cover - in the file TVabund we have only original cover codes which we need to translate to %. However, first we
#' need to add the information on the cover-abundance scale from tvhabita and then we can append translation table.
#' This happens during the transport to JUICE automatically, but here we can adjust the final CoverPerc values in the
#' translation table. (file name: coverCZ-2023-04-02-IA)

##### import ####
spp<- read_xlsx ("data/Productivity_IA/tvabund.xlsx") #3784
env1 <-read_xlsx("data/Productivity_IA/tvhabita.xlsx")
env2 <-read_xlsx("data/Productivity_IA/env-data-extra.xlsx")
cover<- read_xlsx ("data/Productivity_IA/coverCZ-2023-04-02-IA.xlsx")
nomenclature <- read_xlsx ("data/Productivity_IA/nomenclatureCZ-2023-04-02-IA.xlsx")

glimpse (nomenclature)
tibble (nomenclature)


tibble (spp)


data<- spp %>% left_join(nomenclature)
names (data)
data %<>% select (RELEVE_NR, Kaplan, nonvascular, COVER_CODE, LAYER)
data %<>% rename (Species = Kaplan)
test<- data %>% filter (nonvascular == "nonvascular")
data %<>% filter (!nonvascular == "nonvascular"|is.na (nonvascular)) 

env.selected <- env1 %>% select (RELEVE_NR, COVERSCALE)
data %<>% left_join(env.selected)
cover %<>% select (COVERSCALE, COVER_CODE, CoverPerc)
names (cover)
data %<>% left_join(cover)


tibble(data)
data %<>% select (-nonvascular)

data %<>% select (-COVERSCALE)
names (env2)
env.selected <- env2 %>% select (RELEVE_NR, Sum_Herbs, `Sum_Herbs+Juv`, Biomass, pH_KCl, Canopy_E3, Vyber3)
data %<>% left_join(env.selected)
tibble (data)
unique (data$Vyber3)
data %<>% filter (Vyber3 == "1")
PlotCount <- data %>% select (RELEVE_NR) %>% distinct ()
names (data)

data %<>% rename (Sum_HerbsJuv = `Sum_Herbs+Juv`)
data %<>% select (-Vyber3)
tibble(data)
names (data)
data %<>% select (-COVER_CODE)

head<- data %>% select (- Species, - LAYER, -CoverPerc)

ggplot(data = head, aes(x = Canopy_E3, y =Sum_Herbs ))+
  geom_point()
ggplot(data = data, aes(x = LATITUDE, y = LONGITUDE ))+
  geom_point()
ggplot(data = data, aes(x = deg_lat, y = deg_lon)) +
  geom_point()

ggplot(data = head, aes(x = Canopy_E3, y =Sum_HerbsJuv ))+
  geom_smooth()

ggplot(data = data, aes(x = Biomass, y =Sum_Herbs ))+
  geom_smooth()

ggplot(data = data, aes(x = pH_KCl, y =Sum_Herbs ))+
  geom_smooth()

ggplot(data = data, aes(x = Biomass, y =Sum_HerbsJuv ))+
  geom_smooth()

names (env2)
env.selected <- env2 %>% select (RELEVE_NR, Biomass_log, Radiation, Heat, TWI)
data %<>% left_join(env.selected)
env.selected <- env1 %>% select (RELEVE_NR, LONGITUDE, LATITUDE)
names (env1)
### add deg lat long, check nomenclature, add Expert file names from ESy
spp.list<- unique (data$Species) %>% as.data.frame()

write.table(spp.list, file=paste0("clipboard-", 2^12), sep="\t", row.names = F, col.names=T)  

names (data)

write.table(data,"data/data-productivity-CZ-long.txt",
            sep="\t",fileEncoding = "UTF-8", row.names=F, quote=F)
write.table(env.selected,"data/data-productivity-CZ-head.txt",
            sep="\t",fileEncoding = "UTF-8", row.names=F, quote=F)

env.selected<- env1 %>% select (RELEVE_NR, LONGITUDE, LATITUDE)
data.to.add <- read.delim("clipboard",header=T)


data %<>% left_join(data.to.add) 
names (data)

spp.list %<>% distinct ()
data %<>% left_join(spp.list)

data %<>% mutate (Species= ESy)
data %<>% select(-ESy)

write.table(data,"data/data-productivity-CZ-long.txt",
            sep="\t",fileEncoding = "UTF-8", row.names=F, quote=F)
