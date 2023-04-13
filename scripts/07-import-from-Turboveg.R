library(magrittr)
library(tidyverse)
library(readxl)

# Handling untidy data from a database export (Turboveg, Czech species list)
# tvabund - species data in a long format, opened as dbf file from Turbowin/data/xx , species names as codes, cover as codes
# tvhabita - header data,each releve has RELEVE_NR code, which matches the one in tvabund
# species - to translate the species codes to species names we further need a species list which is stored in the Turbowin/species as species.dbf
# nomenclature - alternative approach to species - I created a special file where the codes in Turboveg are directly matched to more name variants/ Danihelka, Kaplan, ESy  (file name: nomenclatureCZ-2023-04-02-IA)
# cover - in the file TVabund we have only original cover codes which we need to translate to %. However, first we need to add the information on the cover-abundance scale from tvhabita and then we can append this translation table. (file name: coverCZ-2023-04-07-IA)



#### import ####
spp<- read_xlsx ("data/Real-world-data_IA/tvabund.xlsx") #3784
env1 <-read_xlsx("data/Real-world-data_IA/tvhabita.xlsx")
env2 <-read_xlsx("data/Real-world-data_IA/env-data-extra.xlsx")
cover<- read_xlsx ("data/Real-world-data_IA/coverCZ-2023-04-02-IA.xlsx")
nomenclature <- read_xlsx ("data/Real-world-data_IA/nomenclatureCZ-2023-04-07-IA.xlsx")

names (spp)
tibble (spp)

##### translation of codes to names, filtering out nonvasculars
data<- spp %>% left_join(nomenclature)#Joining, by = "SPECIES_NR" 
names (data)
data %<>% select(RELEVE_NR, ESy, nonvascular, COVER_CODE, LAYER)
data %<>% rename(Species = ESy)
test<- data %>% filter(nonvascular == "nonvascular")
data %<>% filter(!nonvascular == "nonvascular"|is.na (nonvascular)) 

###header data
#first add info about cover scale to the data / need for translation of the code
env.selected <- env1 %>% select(RELEVE_NR, COVERSCALE)
data %<>% left_join(env.selected)
#now match the cover crosswalk table - by 
names (cover)
cover %<>% select(COVERSCALE, COVER_CODE, CoverPerc)
data %<>% left_join(cover)
tibble(data)

#remove not needed variables
data %<>% select(-nonvascular)
data %<>% select(-COVERSCALE)

#### add additional env data
names (env1)
env.selected <- env1 %>% select (RELEVE_NR, LONGITUDE, LATITUDE)
data %<>% left_join(env.selected)

# add additional header data / env variables/ originally not in TBV
names (env2)
env.selected <- env2 %>% select(RELEVE_NR, Vyber3, Sum_Herbs, `Sum_Herbs+Juv`, Biomass, Biomass_log, pH_KCl, Canopy_E3, Radiation, Heat, TWI)

data %<>% left_join(env.selected)
tibble (data)
table(data$Vyber3)

## filter to have only plots from the selection, check
data %<>% filter (Vyber3 == "1")
plotCount <- data %>% select(RELEVE_NR) %>% 
  distinct() %>% 
  count() %>% 
  print() 
names (data)

## some changes of names, select
data %<>% rename (Sum_HerbsJuv = `Sum_Herbs+Juv`)
data %<>% select (-Vyber3)
tibble(data)
names (data)
data %<>% select (-COVER_CODE)


### check spp data
spp.list<- unique (data$Species) %>% as.data.frame()
write.table(spp.list, file=paste0("clipboard-", 2^12), sep="\t", row.names = F, col.names=T)  

#### save the data
write.table(data,"data/data-productivity-CZ-long.txt",
            sep="\t",fileEncoding = "UTF-8", row.names=F, quote=F)

