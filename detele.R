library(tidyverse)

tibble(f = list.files(r'(C:\Users\krystof\OneDrive - MUNI\Devin\Photos\Fevin\2022\03_named)')) |>
  separate(f, into = c('plot'), sep = '_') |>
  mutate(v1 = str_sub(plot, 3, 4), v2 =
    str_sub(plot, 1, 2)) |>
  select(-1) |>
  mutate(value = 1) |>
  distinct(v1, v2, value) |>
  pivot_wider(names_from = v2) |>
  arrange(v1)