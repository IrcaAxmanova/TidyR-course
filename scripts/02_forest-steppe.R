library(tidyverse)
library(sf)
library(rnaturalearth)

# ====================================================================================
countries <- rnaturalearth::ne_countries(scale = 10, continent = 'Europe', returnclass = 'sf')

read_csv(r'(data\Forest-steppe_KC\Chytry-Krystof_forest-steppe-v1_2021-05-24_SITES.csv)') |>
  st_as_sf(coords = c('LONGITUDE', 'LATITUDE'), crs = 4326) -> forste_sf

forste_sf |>
  ggplot() +
  geom_sf(data = countries, fill = 'grey90') +
  geom_sf(data = countries, fill = NA, colour = 'red') +
  geom_sf() +
  coord_sf(xlim = c(13, 25), ylim = c(45, 52))
