Source: https://www.gapminder.org/data/

From Gapminder website:
"
Our mission is to fight devastating ignorance with a fact-based worldview everyone can understand.

Gapminder identifies systematic misconceptions about important global trends and proportions and uses reliable data to develop easy to understand teaching materials to rid people of their misconceptions.

Gapminder is an independent Swedish foundation with no political, religious, or economic affiliations.
"


To prepare the data for our use, KC did following:

```{r}
library(gapminder)
library(tidyverse)

child_mortality <- read_csv(r'(data\Gapminder\orig_data\child_mortality_0_5_year_olds_dying_per_1000_born.csv)') |>
  pivot_longer(-1, names_to = 'year') |>
  mutate(variable = 'child_mortality')

children_per_woman <- read_csv(r'(data\Gapminder\orig_data\children_per_woman_total_fertility.csv)') |>
  pivot_longer(-1, names_to = 'year') |>
  mutate(variable = 'children_per_woman')

life_expectancy <- read_csv(r'(data\Gapminder\orig_data\life_expectancy_years.csv)') |>
  pivot_longer(-1, names_to = 'year') |>
  mutate(variable = 'life_expectancy')

bind_rows(children_per_woman, life_expectancy) |>
  pivot_wider(names_from = variable) |>
  mutate(year = as.numeric(year)) |>
  left_join(gapminder |> select(country, continent, year, pop, gdpPercap)) |>
  drop_na() |> write_csv(r'(data\Gapminder\gapminder_data.csv)')
```
