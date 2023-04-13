library(tidyverse)
library(sf)

sites <- read_csv(r'(data\Forest-steppe_KC\Chytry-Krystof_forest-steppe-v1_2021-05-24_SITES.csv)')
countries <- rnaturalearth::ne_countries(scale = 10, continent = 'Europe', returnclass = 'sf')

sites |>
  st_as_sf(coords = c('LONGITUDE', 'LATITUDE'), crs = 4326) -> sites_sf

bb <- st_bbox(sites_sf) |> as.numeric()
sites_sf |>
  ggplot() +
  geom_sf(data = countries, fill = NA) +
  geom_sf(aes(colour = PART_2), size = 4) +
  coord_sf(xlim = bb[c(1, 3)], ylim = bb[c(2, 4)])
