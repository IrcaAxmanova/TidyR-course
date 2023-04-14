library(ggpubr)
library(broom)
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
sites$precipitation <- terra::extract(rast(r'(data\Forest-steppe_KC\chelsa12.tif)'), vect(sites_sf))[, 2]

#' plotting the extent of the dataset
sites_sf |>
  ggplot() +
  geom_sf(data = countries) +
  geom_sf(size = 3, aes(colour = PART_2)) +
  coord_sf(xlim = st_bbox(sites_sf)[c(1, 3)],
           ylim = st_bbox(sites_sf)[c(2, 4)])

#' presence absence species data
spe |>
  left_join(env |> select(PLOT_ID, SITE_ID)) |>
  distinct(SITE_ID, name = TAXON, value = 1) |>
  pivot_wider(values_fill = 0) |>
  pivot_longer(-1) |>
  left_join(sites |> select(SITE_ID, precipitation)) |>
  select(-SITE_ID) |>
  group_by(name) |>
  nest() |>
  mutate(no_occ = map_dbl(data, function(df){sum(df$value)})) |>
  filter(no_occ > 5) |>
  mutate(models = map(data, function(df) {
    glm(value ~ precipitation, data = df, family = binomial())
  }
  )) |>
  mutate(model_out = map(models, tidy)) |>
  unnest(model_out) |>
  filter(term == 'precipitation') |>
  left_join(traits |> select(name = TAXON, PLANT_HEIGHT)) |>
  filter(p.value < .1) |>
  ggplot(aes(estimate, PLANT_HEIGHT)) +
  geom_point() +
  geom_smooth(method = 'lm') +
  stat_cor()