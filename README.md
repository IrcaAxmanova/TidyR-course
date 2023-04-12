# Tidy R course

## Course structure

### 1 Introduction to tidy coding

* Why is R such a special programming language?
* Projects in RStudio
* GitHub

### 2 How and where to seek for help

* Listen to us
* [Programming books](https://r4ds.had.co.nz/)
* [Cheat Sheat](https://posit.co/resources/cheatsheets/)
* [Stack Overflow](https://stackoverflow.com/)
* [Artificial inteligence](https://chat.openai.com/chat)
* [Google](https://www.google.com/)
* Your own code from old projects
* Ask us anytime later

### 3 Pipe and pipelines

* The logic of reverse code (data first, function then)
* native pipe |> 
* traditional pipe %>% 
* compouned pipe %<>%

### 4 Tidy data

* Irča

### 4 Gapminder, basic data visualization

* Dataset: [Gapminder](https://www.gapminder.org/data/)
* [Hans Rosling TED talk introducing the Gapminder project](https://www.youtube.com/watch?v=hVimVzgtD6w&ab_channel=TED)
* read_csv() tibble() versus data.frame()
* ggplot2()

### 5 Forest undestory diversity

* Dataset: [IA](IA.path)
* 



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
