# Tidy R course
hello

## Course structure

### 1 Introduction to tidy code and tidy data
Why is R such a special programming language?

* Projects in RStudio
* GitHub

### 2 How and where to seek for help

* https://stackoverflow.com/
* https://r4ds.had.co.nz/
* https://chat.openai.com/chat
* https://www.google.com/
* your own code from old projects
* Cheat Sheat

#### Data

We will work with following public datasets:
- [`Forest-steppe_KC`](https://zenodo.org/record/4783984#.ZCrK5fZByUk)
  - A vegetation plot data with 3 to 5 samples of different habitats per site
  - Four data frames (long species data, environmental data for plots, environmental data for sites, species traits)
- [`Productivity_IA`](https://and.path)

### 3 Data import and basics of wrangling

Reading the data and subsetting it.
* `read_csv()`, `read_xlsx()`, `write_csv()`, `write_xlsx()`
* `|>` & `%>%`
* `select()`, `filter()`
* regex

Computation of means inside groups.
* `mutate()`, `group_by()`, `summarise()`

Reshaping/pivotting dataframes
* `pivot_longer()`, `pivot_wider()`

Merging tables from different sources
* `left_join()`, `semi_join()`, `anti_join()`

### 4 Plotting

* `ggplot()`

Plot aestetics
* `ggplot(aes(x = x, y = y, colour = group))`

Geometry types
* `geom_point()`, `geom_line()`, `geom_path()`, `geom_bar()`, `geom_boxplot()`...
* [`geom_sf()`](https://ggplot2.tidyverse.org/reference/ggsf.html)
* [`geom_spatraster()`](https://dieghernan.github.io/tidyterra/reference/geom_spatraster.html)

Facetting
* `facet_wrap()`, `facet_grid()` [link](http://zevross.com/blog/2019/04/02/easy-multi-panel-plots-in-r-using-facet_wrap-and-facet_grid-from-ggplot2/)

### 5 Get your code smooth and efficient

* `purrr::map()`, `furrr::map_future()`
* tidymodels
