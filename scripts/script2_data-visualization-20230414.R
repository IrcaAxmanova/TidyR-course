library(tidyverse)
library(plotly)

read_csv(r'(data\Gapminder\gapminder_data.csv)') |>
  filter(year == 2007) |>
  ggplot(aes(children_per_woman, life_expectancy, text = country)) +
  geom_point(aes(fill = continent, size = pop), shape = 21) +
  scale_size_continuous(range = c(1, 15)) -> p
ggplotly(p, tooltip = 'text')

# 1:10 == c(5, 7)

read_csv(r'(data\Gapminder\gapminder_data.csv)') |>
  filter(year %in% c(1952, 2007)) |>
  ggplot(aes(children_per_woman, life_expectancy, text = country)) +
  geom_point(aes(fill = continent, size = pop), shape = 21) +
  scale_size_continuous(range = c(1, 15)) +
  facet_wrap(~year)

hist(read_csv(r'(data\Gapminder\gapminder_data.csv)') $pop)

read_csv(r'(data\Gapminder\gapminder_data.csv)') |>
  filter(pop > 10000000) |>
  mutate(child_survival = (1000-child_mortality)/1000) |>
  select(country, continent, year, child_survival, gdpPercap) |>
  mutate(gdpPercap = log10(gdpPercap)) |>
  arrange(year) |>
  ggplot(aes(gdpPercap, child_survival)) +
  geom_path(aes(group = country, colour = continent), arrow = arrow()) +
  facet_wrap(~continent)

