library(gapminder)
library(tidyverse)

map2(as.list(list.files(r'(data\Gapminder\orig_data)', full.names = T)),
     list('child_mortality', 'children_per_woman', 'life_expectancy'),
     ~read_csv(.x) |>
       pivot_longer(-1, names_to = 'year') |>
       mutate(variable = .y)) |>
  bind_rows() |>
  pivot_wider(names_from = variable) |>
  mutate(year = as.numeric(year)) |>
  left_join(gapminder |> select(country, continent, year, pop, gdpPercap)) |>
  drop_na() |>
  write_csv(r'(data\Gapminder\gapminder_data.csv)')
