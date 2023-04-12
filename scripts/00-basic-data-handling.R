library(magrittr) # %<>% pipes
library(tidyverse)
library(readxl)

####import data and check their structure#####
### import spp data in long format
productivity <- read_xlsx(r'(data\Forest-understory-diversity_IA\Forest-understory-diversity-long.xlsx)') #2278rows

#### check the structure
names(productivity)
# [1] "RELEVE_NR"    "Species"      "LAYER"        "CoverPerc"    "Sum_Herbs"    "Sum_HerbsJuv"
# [7] "Biomass"      "Biomass_log"  "pH_KCl"       "Canopy_E3"    "Radiation"    "Heat"        
# [13] "TWI"          "LONGITUDE"    "LATITUDE"    
tibble(productivity)

sort(unique(productivity$LAYER))
table(productivity$LAYER)

#### rename names ####
productivity %>% rename(PlotID = RELEVE_NR)
names(productivity) %>% str_replace_all("_", ".")


##### filter releves, change long to wide , plot count
selected_plots <- productivity %>% filter(RELEVE_NR == 132)
selected_plots <- productivity %>% filter(RELEVE_NR %in% c(132, 131))
selected_plots <- productivity %>% filter(RELEVE_NR %in% c(130:132))

selected_plots %<>% filter(LAYER %in% c(6))
selected_plots %<>% select(RELEVE_NR, Species, CoverPerc) %>%
  distinct() %>%
  arrange(Species)
selected_plots_wide <- pivot_wider(selected_plots, names_from = "Species", values_from = "CoverPerc")

selected_plots <- productivity %>% filter(RELEVE_NR %in% c(120:132))
selected_plots %<>% mutate(Species.layer = paste(Species, LAYER))
selected_plots %<>% select(RELEVE_NR, Species.layer, CoverPerc) %>%
  distinct() %>%
  arrange(Species.layer)
selected_plots_wide <- pivot_wider(selected_plots, names_from = "Species.layer", values_from = "CoverPerc")

selected_plots <- productivity %>% filter(RELEVE_NR %in% c(10:60))
PlotCount <- selected_plots %>%
  select(RELEVE_NR) %>%
  distinct() %>%
  count() %>%
  print()

#### spp. list/ select, filter, group_by, distinct, count ####
#1 only unique names
spp.list <- productivity %>% select(Species) %>% distinct()

#2 names and layer
spp.list <- productivity %>%
  select(Species, LAYER) %>%
  distinct()
trees <- spp.list %>% filter(LAYER == "1") #only one layer
test <- spp.list %>%
  group_by(Species) %>%
  count() %>%
  filter(n > 1) #duplicate names

#3 names and plot counts
spp.list <- productivity %>%
  select(Species, RELEVE_NR) %>%
  distinct() %>%
  group_by(Species) %>%
  count()
spp.list %<>% arrange(desc(n))
spp.list %<>% rename(freq = n)
write.table(spp.list, file = paste0("clipboard-", 2^12), sep = "\t", row.names = F, col.names = T)

#4 names and layer and plot counts
spp.list <- productivity %>%
  select(Species, LAYER, RELEVE_NR) %>%
  distinct() %>%
  group_by(Species, LAYER) %>%
  count()
spp.list %<>% arrange(desc(n))
spp.list %<>% rename(freq = n)
write.table(spp.list, file = paste0("clipboard-", 2^12), sep = "\t", row.names = F, col.names = T)

#### calculate total cover of all species in the plot / group_by, summarise ####
total.cover <- productivity %>%
  group_by(RELEVE_NR) %>%
  summarise(total.cover = sum(CoverPerc))
E1.cover <- productivity %>%
  filter(LAYER == "6") %>%
  group_by(RELEVE_NR) %>%
  summarise(E1.cover = sum(CoverPerc))

#### calculate relative cover of individual species / mutate ####
productivity %<>% left_join(total.cover)
productivity %<>% mutate(relative.cover = CoverPerc / total.cover * 100)


#### dominants ####
dominants <- productivity %>%
  select(RELEVE_NR, Species, relative.cover) %>%
  distinct() %>%
  filter(Species %in% trees$Species) %>%
  group_by(RELEVE_NR) %>%
  slice_max(order_by = relative.cover)

dominants <- productivity %>%
  select(RELEVE_NR, Species, CoverPerc) %>%
  distinct() %>%
  filter(Species %in% trees$Species) %>%
  group_by(RELEVE_NR) %>%
  slice_max(order_by = CoverPerc)

more.dominants.per.plot <- dominants %>%
  group_by(RELEVE_NR) %>%
  count() %>%
  filter(n > 1)
no.dominant.per.plot <- productivity %>%
  select(RELEVE_NR) %>%
  distinct() %>%
  anti_join(dominants)
  filter(!RELEVE_NR %in% dominants$RELEVE_NR)


#### ggplot basics / see also Cheatsheet #####
ggplot(data = productivity, aes(x = Canopy_E3, y = Sum_Herbs)) +
  geom_point() +

ggplot(data = productivity, aes(x = Canopy_E3, y = Sum_HerbsJuv)) +
  geom_smooth()

library(ggpubr)

ggplot(data = productivity, aes(x = Biomass, y = Sum_Herbs)) +
  geom_smooth(method = 'lm') +
  stat_cor(label.x.npc = 0, label.y.npc = 1) +
  stat_regline_equation(label.x.npc = 0, label.y.npc =  .9) +
  geom_point() +
  scale_x_continuous(trans = 'log10') +
  theme_bw() +
  labs(y = 'Number of species in forest understory',
       x = 'Biomass (g/m^2)')

ggplot(data = productivity, aes(x = Biomass, y = Sum_HerbsJuv)) +
  geom_smooth()

ggplot(data = productivity, aes(x = pH_KCl, y = Sum_Herbs)) +
  geom_smooth()

ggplot(data = productivity, aes(x = pH_KCl, y = Sum_Herbs)) +
  geom_smooth(method = 'lm', formula = 'y ~ poly(x, 2)') +
  stat_cor(label.x.npc = 0, label.y.npc = 1) +
  stat_regline_equation(label.x.npc = 0, label.y.npc =  .9) +
  geom_point() +
  scale_x_continuous(trans = 'log10') +
  theme_bw() +
  labs(y = 'Number of species in forest understory',
       # x = 'Biomass (g/m^2)')
