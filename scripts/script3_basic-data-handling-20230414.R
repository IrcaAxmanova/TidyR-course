library(ggpubr)
library(readxl)
library(tidyverse)
library(magrittr)


############### Basic data handling ------------------------------------------

# import data and check structure -----------------------------------------

####import spp data in long format
forest <- read_xlsx('data/Forest-understory-diversity_IA/Forest-understory-diversity-long.xlsx') %>%
  rename (PlotID = RELEVE_NR, Layer= LAYER)
# check the structure 
names(forest)
table(forest$Layer)


### select some plots / different filtering functions
selected_plots <- forest %>% filter (PlotID == 132) 
#forest %>% filter (PlotID == 132) -> selected_plots
selected_plots <- forest %>% filter (PlotID %in% c(130, 131)) %>%
  arrange(PlotID)
selected_plots <- forest %>% filter (PlotID %in% c(10:100)) 

#### change the selected plots from long to wide format, only herb layer
forest %>% filter(PlotID %in% c(10:100)) %>%
  filter(Layer == 6) %>%
  select(PlotID, name = Species, value = CoverPerc) %>%
  pivot_wider() ->selected_plots_wide

##### prepare name where we combine Species and Layer info to be used for wide 
forest %>% filter(PlotID %in% c(10:100)) %>%
  mutate(SpeciesLayer = paste(Species,Layer)) %>%
  select(PlotID, name = SpeciesLayer, value = CoverPerc) %>%
  pivot_wider() ->selected_plots_wide

##### prepare name where we combine Species and Layer info to be used for wide, change spaces into _ 
# between sp and layer insert something specific, like OMGSEPARATOR
forest %>% filter(PlotID %in% c(10:100)) %>%
  mutate(SpeciesLayer = paste(str_replace_all(Species, ' ', '_'), Layer, sep = 'OMGSEPARATOR')) %>% #combine the names
  select(PlotID, name = SpeciesLayer, value = CoverPerc) %>%
  pivot_wider(values_fill = 0) |> #insert 0 insteda of NAs
  pivot_longer(-1, values_to = 'cover', names_to = 'species') |> #from here we go back to long format
  separate(species, c('species', 'layer'), sep = 'OMGSEPARATOR') |> #here we separate the names
  group_by(species) |> 
  count()

#### calculate a plot count
selected_plots <- forest %>% filter (PlotID %in% c(10:100)) 
selected_plots %>% 
  distinct(PlotID) %>% 
  count() |> pull() -> plotcount # saves plot number as one number, not vector or anything else

##### prepare species list 
  sppList <- forest %>% select (Species) %>% distinct() # only unique names, in contrast to unique function, it is a dataframe
  
  sppList <- forest %>% select (Species, Layer) %>% distinct() # species and layer
  
  forest %>% filter(Layer==1) %>%
    select (Species) %>% distinct() ->trees ### list of trees in our dataset
  
  sppList <- forest %>% select(Species, PlotID) %>%
    group_by(Species) %>%
    count(name = 'species_occurences') %>% arrange(desc(species_occurences)) ### species list with plotcounts

#### calculate total cover   
total_cover <- forest %>% 
  group_by(PlotID)%>%
  summarise(total_cover= sum(CoverPerc))

forest %<>%              # check duplicate rows 
  left_join(total_cover) # by = PlotID

#or herb layer cover
E1_cover <- forest %>%
  filter(Layer == "6") %>%
  group_by(PlotID) %>%
  summarise(E1_cover = sum(CoverPerc))

#### calculate relative cover of individual species / mutate ####
forest %<>% left_join(total_cover)
forest %<>% mutate(relative_cover = CoverPerc / total_cover * 100)


#### dominants ######### was not in the lecture in the end
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




##### visualisation with ggplot
names(forest) 
ggplot(forest, aes(Canopy_E3, Sum_Herbs))+
  geom_point()

ggplot(forest, aes(Canopy_E3, Sum_Herbs))+
  geom_smooth()

forest |> 
  #mutate(Biomass = log10(Biomass)) |> 
  ggplot(aes(Biomass, Sum_Herbs)) +
  geom_smooth(method = 'lm') + 
  # stat_cor() + 
  stat_regline_equation() + 
  geom_point() + 
  scale_x_continuous(trans = 'log10')

# Productivity
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



  
