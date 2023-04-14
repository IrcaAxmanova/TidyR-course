library(tidyverse)
library(plotly)

read_csv(r'(data\Gapminder\gapminder_data.csv)') |>
  filter(year == 2007) |>
  ggplot(aes(children_per_woman, life_expectancy, text = country)) +
  geom_point(aes(fill = continent, size = pop), shape = 21) +
  scale_size_continuous(range = c(1, 15)) -> p

ggplotly(p, tooltip = 'text')