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
countries <- rnaturalearth::ne_countries(scale = 10, continent = 'Europe', returnclass = 'sf')

sites |>
  st_as_sf(coords = c('LONGITUDE', 'LATITUDE'), crs = 4326) -> sites_sf

bb <- st_bbox(sites_sf) |> as.numeric()
sites_sf |>
  ggplot() +
  geom_sf(data = countries, fill = NA) +
  geom_sf(aes(colour =  PART_2), size = 4) +
  coord_sf(xlim = bb[c(1,3)], ylim = bb[c(2,4)])

sites |> filter(PART_2)

chelsa01 <- rast(r'(C:\Users\krystof\Documents\R-project\2023\CHELSA\CHELSA_bio1_2011-2040_gfdl-esm4_ssp126_V.2.1.tif)')
chelsa12 <- rast(r'(C:\Users\krystof\Documents\R-project\2023\CHELSA\CHELSA_bio12_2011-2040_gfdl-esm4_ssp126_V.2.1.tif)')


writeRaster(crop(chelsa01, st_bbox(st_buffer(sites_sf, 1000))), '../data/Forest-steppe_KC/chelsa01.tif')
writeRaster(crop(chelsa12, st_bbox(st_buffer(sites_sf, 1000))), '../data/Forest-steppe_KC/chelsa12.tif')


env |>
  semi_join(sites |> filter(PART_2), by = 'SITE_ID') |>
  filter(grepl('ST|F', HABITAT)) |>
  select(PLOT_ID, HABITAT) |>
  left_join(spe)


forste_sf |>
  ggplot() +
  geom_sf(data = countries, fill = 'grey90') +
  geom_sf(data = countries, fill = NA, colour = 'red') +
  geom_sf() +
  coord_sf(xlim = c(13, 25), ylim = c(45, 52))




#'

 spe |>
+   filter(LAYER %in% c(1,4)) |>
+   left_join(env |> distinct(PLOT_ID, SITE_ID)) |>
+   distinct(SITE_ID, TAXON) |>
+   left_join(sites |> select(SITE_ID, temperature, precipitation)) |>
+   group_by(TAXON) |>
+   summarise(n = n(),
+             temperature = mean(temperature),
+             precipitation = mean(precipitation)) |>
+   filter(n > 4) |>
+   mutate(TAXON = paste(str_sub(word(TAXON, 1), 1,3), str_sub(word(TAXON, 2), 1,3), sep = '.')) |>
+   ggplot(aes(temperature, precipitation)) +
+   geom_text_repel(aes(label = TAXON), fontface = 'bold.italic')
Joining, by = "PLOT_ID"
Joining, by = "SITE_ID"
> sites |>
+   st_as_sf(coords = c('LONGITUDE', 'LATITUDE'), crs = 4326) |>
+   ggplot() +
+   geom_sf(data = countries, fill = NA) +
+   geom_sf(aes(colour = temperature), size = 2) +
+   coord_sf(xlim = c(13, 24), ylim = c(46, 51))