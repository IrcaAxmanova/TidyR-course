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
sites$precipitation <- terra::extract(rast(r'(data\Forest-steppe_KC\chelsa12.tif)'), vect(sites_sf))[,2]

#' plotting the extent of the dataset
sites_sf |>
  ggplot() +
  geom_sf(data = countries) +
  geom_sf(size = 3, aes(colour = PART_2)) +
  coord_sf(xlim = st_bbox(sites_sf)[c(1,3)],
           ylim = st_bbox(sites_sf)[c(2,4)])

#' presence absence species data
spe |>
  left_join(env |> select(PLOT_ID, SITE_ID)) |>
  distinct(SITE_ID, name = TAXON, value = 1) |>
  pivot_wider(values_fill = 0) |>
  pivot_longer(-1) |>
  left_join(sites |> select(SITE_ID, precipitation)) |>
  select(-SITE_ID) |>
  group_by(name) |>
  nest() -> df

df$data[[2]]