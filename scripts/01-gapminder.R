library(tidyverse)
library(plotly)

# =========================================
#' task 1: between us and Tintin
#'
#' compare world in 1950s with world nowdays
#' we will use gapminder data
# =========================================

data <- read_csv(r'(data\Gapminder\gapminder_data.csv)')

data |>
  filter(year == 1952) |>
  ggplot(aes(children_per_woman, life_expectancy, text = country)) +
  geom_point(aes(size = pop, fill = continent, group = country), shape = 21) +
  scale_size_continuous(range = c(1, 15)) -> p
ggplotly(p, tooltip = 'text')

data |>
  filter(year %in% c(1952, 2007)) |>
  ggplot(aes(children_per_woman, life_expectancy)) +
  geom_point(aes(size = pop, fill = continent, group = country), shape = 21) +
  scale_size_continuous(range = c(1, 15)) +
  facet_wrap(~year, scales = 'free')

data |>
  arrange(year) |>
  filter(country %in% c('Czech Republic', 'China')) |>
  ggplot(aes(children_per_woman, life_expectancy)) +
  geom_path(aes(colour = country), size = 2)

data |>
  mutate(child_survival = (1000-child_mortality)/1000) |>
  arrange(year) |>
  filter(country %in% c('Czech Republic', 'China')) |>
  ggplot(aes(log10(gdpPercap), child_survival)) +
  geom_path(aes(colour = country), size = 2)