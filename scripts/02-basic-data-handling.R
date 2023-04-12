library(magrittr) # %<>% pipes
library(tidyverse)
library(readxl)

####import data and check their structure#####
### import spp data in long format
forest <- read_xlsx(r'(data\Forest-understory-diversity_IA\Forest-understory-diversity-long.xlsx)') #2278rows

#### check the structure
names(forest)
# [1] "RELEVE_NR"    "Species"      "LAYER"        "CoverPerc"    "Sum_Herbs"    "Sum_HerbsJuv"
# [7] "Biomass"      "Biomass_log"  "pH_KCl"       "Canopy_E3"    "Radiation"    "Heat"        
# [13] "TWI"          "LONGITUDE"    "LATITUDE"    
tibble(forest)

sort(unique(forest$LAYER))
table(forest$LAYER)

#### rename names ####
forest %<>% rename(PlotID = RELEVE_NR) %>%
  rename(Layer = LAYER)

#names(forest) %>% str_replace_all("_", ".")


##### filter releves, change long to wide , plot count
selected_plots <- forest %>% filter(PlotID == 132)
selected_plots <- forest %>% filter(PlotID %in% c(132, 131))
selected_plots <- forest %>% filter(PlotID %in% c(130:132))

#filtering within plots
selected_plots %<>% filter(Layer %in% c(6))
selected_plots %<>% select(PlotID, Species, CoverPerc) %>%
  distinct() %>%
  arrange(Species)
selected_plots_wide <- pivot_wider(selected_plots, names_from = "Species", values_from = "CoverPerc")

selected_plots <- forest %>% filter(PlotID %in% c(120:132))
selected_plots %<>% mutate(SpeciesLayer = paste(Species, Layer))
selected_plots %<>% select(PlotID, SpeciesLayer, CoverPerc) %>%
  distinct() %>%
  arrange(SpeciesLayer)
selected_plots_wide <- pivot_wider(selected_plots, names_from = "SpeciesLayer", values_from = "CoverPerc")

selected_plots <- forest %>% filter(PlotID %in% c(10:60))
plotCount <- selected_plots %>%
  select(PlotID) %>%
  distinct() %>%
  count() %>%
  print()

#### spp. list/ select, filter, group_by, distinct, count ####
#1 only unique names
sppList <- forest %>% select(Species) %>% distinct()
write.table(sppList, file = paste0("clipboard-", 2^12), sep = "\t", row.names = F, col.names = T)

#2 names and Layer
sppList <- forest %>%
  select(Species, Layer) %>%
  distinct()
trees <- sppList %>% filter(Layer == "1") #only one Layer
test <- sppList %>%
  group_by(Species) %>%
  count() %>%
  filter(n > 1) #duplicate names

#3 names and plot counts
sppList <- forest %>%
  select(Species, PlotID) %>%
  distinct() %>%
  group_by(Species) %>%
  count()
sppList %<>% arrange(desc(n))
sppList %<>% rename(freq = n)



#4 names and Layer and plot counts
sppList <- forest %>%
  select(Species, Layer, PlotID) %>%
  distinct() %>%
  group_by(Species, Layer) %>%
  count()
sppList %<>% arrange(desc(n))
sppList %<>% rename(freq = n)
write.table(sppList, file = paste0("clipboard-", 2^12), sep = "\t", row.names = F, col.names = T)

#### calculate total cover of all species in the plot / group_by, summarise ####
total_cover <- forest %>%
  group_by(PlotID) %>%
  summarise(total_cover = sum(CoverPerc))
E1_cover <- forest %>%
  filter(Layer == "6") %>%
  group_by(PlotID) %>%
  summarise(E1_cover = sum(CoverPerc))

#### calculate relative cover of individual species / mutate ####
forest %<>% left_join(total_cover)
forest %<>% mutate(relative_cover = CoverPerc / total_cover * 100)


#### dominants ####
dominants <- forest %>%
  select(PlotID, Species, relative_cover) %>%
  distinct() %>%
  filter(Species %in% trees$Species) %>%
  group_by(PlotID) %>%
  slice_max(order_by = relative_cover)

dominants <- forest %>%
  select(PlotID, Species, CoverPerc) %>%
  distinct() %>%
  filter(Species %in% trees$Species) %>%
  group_by(PlotID) %>%
  slice_max(order_by = CoverPerc)

more_dominants_per_plot <- dominants %>%
  group_by(PlotID) %>%
  count() %>%
  filter(n > 1)
no_dominant_per_plot <- forest %>%
  select(PlotID) %>%
  distinct() %>%
  anti_join(dominants)
  #filter(!PlotID %in% dominants$PlotID)

# dplyr:: filter (!Releve.area.m2<1 | is.na (Releve.area.m2)) #keep NAs


#### Diversity relationships ####
#see also Cheatsheet for ggplot
names (forest)
#canopy shading
ggplot(data = forest, aes(x = Canopy_E3, y = Sum_Herbs)) +
  geom_point()

ggplot(data = forest, aes(x = Canopy_E3, y = Sum_HerbsJuv)) +
  geom_smooth()


# Productivity
library(ggpubr)
ggplot(data = forest, aes(x = Biomass, y = Sum_Herbs)) +
  geom_point()

ggplot(data = forest, aes(x = Biomass, y = Sum_HerbsJuv)) +
  geom_smooth()

ggplot(data = forest, aes(x = Biomass, y = Sum_Herbs)) +
  geom_smooth(method = 'lm') +
  stat_cor(label.x.npc = 0, label.y.npc = 1) +
  stat_regline_equation(label.x.npc = 0, label.y.npc =  .9) +
  geom_point() +
  scale_x_continuous(trans = 'log10') +
  theme_bw() +
  labs(y = 'Number of species in forest understory',
       x = 'Biomass (g/m^2)')

#soil reaction
ggplot(data = forest, aes(x = pH_KCl, y = Sum_Herbs)) +
  geom_smooth()

ggplot(data = forest, aes(x = pH_KCl, y = Sum_Herbs)) +
  geom_smooth(method = 'lm', formula = 'y ~ poly(x, 2)') +
  stat_cor(label.x.npc = 0, label.y.npc = 1) +
  stat_regline_equation(label.x.npc = 0, label.y.npc =  .9) +
  geom_point() +
  scale_x_continuous(trans = 'log10') +
  theme_bw() +
  labs(y = 'Number of species in forest understory',
       x = 'Biomass (g/m^2)')

       
##### maps ####
library(sf)
library(rnaturalearth)

world <- ne_countries(scale = "medium", returnclass = "sf") # rnaturalearth data

forest_map  <- forest %>%
  select(PlotID,  deg_lon, deg_lat, Sum_Herbs) %>%
  st_as_sf(coords = c("deg_lon", "deg_lat"), crs = 4326)

forest_map %>% st_transform(32633)

map<- ggplot() +
  geom_sf(data = world) +
  geom_sf(data = forest_map, aes(colour = Sum_Herbs), size = 2) +
  scale_colour_viridis_c(option = 'A') + 
  coord_sf(xlim = c(10, 20), ylim = c(47, 52), expand = FALSE) +
  theme_bw()

map



