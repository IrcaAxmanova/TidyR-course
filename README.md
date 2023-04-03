# Tidy R course

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

#### Data

We will work with following public datasets:
- [`Forest-steppe`](https://zenodo.org/record/4783984#.ZCrK5fZByUk)
  - A vegetation plot data with 3 to 5 samples of different habitats per site
  - Four data frames (long species data, environmental data for plots, environmental data for sites, species traits)
- [`Irco add name`](https://and.path)

### 3 Data import and basics of wrangling

* `read_csv()`, `read_xlsx()`, `write_csv()`, `write_xlsx()`
* `|>` & `%>%`
* `select()`, `filter()`
* regex
* `mutate()`, `group_by()`, `summarise()`
* `pivot_longer()`, `pivot_wider()`
* `left_join()`, `semi_join()`, `anti_join()`

### 4 Plotting

* `ggplot()`

### 5 Get your code smooth and efficient

* `purrr::map()`, `furrr::map_future()`
