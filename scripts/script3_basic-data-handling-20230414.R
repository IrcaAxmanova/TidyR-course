library(ggpubr)
library(readxl)
library(tidyverse)
library(magrittr)


############### Basic data handling ------------------------------------------

# import data and check structure -----------------------------------------


forest <- read_xlsx('data/Forest-understory-diversity_IA/Forest-understory-diversity-long.xlsx') %>%
  rename (PlotID = RELEVE_NR, Layer= LAYER)

selected_plots <- forest %>% filter (PlotID == 132) 
#forest %>% filter (PlotID == 132) -> selected_plots
selected_plots <- forest %>% filter (PlotID %in% c(130, 131)) %>%
  arrange(PlotID)
selected_plots <- forest %>% filter (PlotID %in% c(10:100)) 




forest %>% filter(PlotID %in% c(10:100)) %>%
  filter(Layer == 6) %>%
  select(PlotID, name = Species, value = CoverPerc) %>%
  pivot_wider() ->selected_plots_wide


forest %>% filter(PlotID %in% c(10:100)) %>%
  mutate(SpeciesLayer = paste(Species,Layer)) %>%
  select(PlotID, name = SpeciesLayer, value = CoverPerc) %>%
  pivot_wider() ->selected_plots_wide


forest %>% filter(PlotID %in% c(10:100)) %>%
  mutate(SpeciesLayer = paste(str_replace_all(Species, ' ', '_'), Layer, sep = 'OMGSEPARATOR')) %>%
  select(PlotID, name = SpeciesLayer, value = CoverPerc) %>%
  pivot_wider(values_fill = 0) |> 
  pivot_longer(-1, values_to = 'cover', names_to = 'species') |> 
  separate(species, c('species', 'layer'), sep = 'OMGSEPARATOR') |> 
  group_by(species) |> 
  count()


selected_plots <- forest %>% filter (PlotID %in% c(10:100)) 
selected_plots %>% 
  distinct(PlotID) %>% 
  count() |> pull() -> plotcount

# sort (unique(forest$Species))

  sppList <- forest %>% select (Species) %>% distinct()
  
  sppList <- forest %>% select (Species, Layer) %>% distinct()
  
  forest %>% filter(Layer==1) %>%
    select (Species) %>% distinct() ->trees
  
  sppList <- forest %>% select(Species, PlotID) %>%
    group_by(Species) %>%
    count(name = 'species_occurences') %>% arrange(desc(species_occurences))

####   
total_cover <- forest %>% 
  group_by(PlotID)%>%
  summarise(total_cover= sum(CoverPerc))

forest |>
  select(PlotID, Species) |> 
  left_join(total_cover)


##### 
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



  
