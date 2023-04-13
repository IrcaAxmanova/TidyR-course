library(ggpubr)
library(broom)
library(ggrepel)
library(terra)
library(tidyverse)
library(sf)
library(rnaturalearth)

# ====================================================================================
#' data
# ====================================================================================
env <- read_csv(r'(data\Forest-steppe_KC\Chytry-Krystof_forest-steppe-v1_2021-05-24_ENV.csv)')
spe <- read_csv(r'(data\Forest-steppe_KC\Chytry-Krystof_forest-steppe-v1_2021-05-24_SPE.csv)')
traits <- read_csv(r'(data\Forest-steppe_KC\Chytry-Krystof_forest-steppe-v1_2021-05-24_TRAITS.csv)')
sites <- read_csv(r'(data\Forest-steppe_KC\Chytry-Krystof_forest-steppe-v1_2021-05-24_SITES.csv)')

sites |>
  st_as_sf(coords = c('LONGITUDE', 'LATITUDE'), crs = 4326) -> sites_sf

chelsa01 <- rast(r'(data\Forest-steppe_KC\chelsa01.tif)')
chelsa12 <- rast(r'(data\Forest-steppe_KC\chelsa12.tif)')

sites$temperature <- terra::extract(chelsa01, vect(sites_sf))[, 2]
sites$precipitation <- terra::extract(chelsa12, vect(sites_sf))[, 2]

spe |>
  #filter(LAYER %in% c(1, 4)) |>
  distinct(PLOT_ID, name = TAXON) |>
  mutate(value = 1) |>
  pivot_wider(values_fill = 0) |>
  pivot_longer(-1) |>
  left_join(env |>
              select(PLOT_ID, SITE_ID, HABITAT) |>
              left_join(sites |>
                          select(SITE_ID,
                                 BEDROCK,
                                 temperature,
                                 precipitation,
                                 ALTITUDE))) |>
  filter(HABITAT == 'ST') |>
  select(name, value, BEDROCK, temperature, precipitation, ALTITUDE) |>
  group_by(name) |>
  nest() |>
  mutate(no_occ = map_dbl(data, function(df) {
    sum(df$value) })) |>
  filter(no_occ > 5) |>
  mutate(
    m = map(data, function(df) {
      glm(value ~ precipitation,
          data = df, family = binomial())
    })
  ) |>
  mutate(m_out = map(m, tidy)) |>
  unnest(m_out) |>
  filter(term == 'precipitation') |>
  left_join(traits |> select(name = TAXON, PLANT_HEIGHT)) |>
  drop_na() |>
  ggplot(aes(estimate, PLANT_HEIGHT)) +
  geom_point() +
  geom_smooth(method = 'lm') +
  stat_cor()