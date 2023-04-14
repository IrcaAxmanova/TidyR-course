library(terra)
library(tidyverse)
library(sf)
library(rnaturalearth)

sites <- read_csv(r'(data\Forest-steppe_KC\Chytry-Krystof_forest-steppe-v1_2021-05-24_SITES.csv)')
env <- read_csv(r'(data\Forest-steppe_KC\Chytry-Krystof_forest-steppe-v1_2021-05-24_ENV.csv)')
spe <- read_csv(r'(data\Forest-steppe_KC\Chytry-Krystof_forest-steppe-v1_2021-05-24_SPE.csv)')
traits <- read_csv(r'(data\Forest-steppe_KC\Chytry-Krystof_forest-steppe-v1_2021-05-24_TRAITS.csv)')
sites_sf <- sites |> st_as_sf(coords = c('LONGITUDE', 'LATITUDE'), crs = 4326)
countries <- ne_countries(returnclass = 'sf', scale = 'large')

sites_sf |>
  ggplot() +
  geom_sf(data = countries) +
  geom_sf(size = 3, aes(colour = PART_2)) +
  coord_sf(xlim = st_bbox(sites_sf)[c(1,3)],
           ylim = st_bbox(sites_sf)[c(2,4)])

rast(r'(data\Forest-steppe_KC\chelsa12.tif)')

spe |>
  distinct(PLOT_ID, name = TAXON, value = 1) |>
  pivot_wider(values_fill = 0) |>
  pivot_longer(-1)


#' env |>
 #' select(PLOT_ID, SITE_ID, LONGITUDE, LATITUDE) |>
  #' semi_join(sites |> filter(PART_2), by = 'SITE_ID')