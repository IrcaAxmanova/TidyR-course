# Tidy R course

## Course structure

### 1 Introduction to tidy coding

* Why is R such a special programming language?
* [Projects in RStudio or Pycharm](https://www.tidyverse.org/blog/2017/12/workflow-vs-script/)
* GitHub

### 2 How and where to seek help

* Listen to us / ask around
* Look up your own code from old projects
* [Cheat Sheat](https://posit.co/resources/cheatsheets/)
* [Artificial inteligence](https://chat.openai.com/chat)
* [Google](https://www.google.com/)
* [Stack Overflow](https://stackoverflow.com/)
* [Programming books](https://r4ds.had.co.nz/)
* Ask us anytime later

### 3 Tidy data & tidy code

* Tidy and untidy data
* select(), filter(), mutate(), arrange ()
* The logic of reverse code (data first, function then)
* native pipe |> 
* traditional pipe %>% 
* compouned pipe %<>%

### 4 Gapminder, basic data visualization

* Dataset: [Gapminder](https://www.gapminder.org/data/)
* [Hans Rosling TED talk introducing the Gapminder project](https://www.youtube.com/watch?v=hVimVzgtD6w&ab_channel=TED)
* read_csv() tibble() versus data.frame()
* ggplot2()

### 5 Forest undestory diversity
* Dataset: [Forest-understory-diversity](https://doi.org/10.1111/j.1466-8238.2011.00707.x)
  - vegetation plot data of deciduous forest in CZ (oak, oak-hornbeam, ravine, alluvial), sampled in 10x10m2, 
  - long format of individual species data, with additional environmental variables to be used for explanation of understory diversity (pH, biomass...)
* dplyr basics: select(), filter(), left_join(), group_by(), summarise(), mutate(), count(), distinct()
* ggplot2()
* simple map with sf


### 6 Trees and shrubs in forest-steppe, dplyr advanced
* [`Forest-steppe_KC`](https://zenodo.org/record/4783984#.ZCrK5fZByUk)
  - A vegetation plot data with 3 to 5 samples of different habitats per site
  - Four data frames (long species data, environmental data for plots, environmental data for sites, species traits)

### 7 Real world data from a database - challenge to prepare tidy data
* data from a database export (Turboveg, Czech species list) [`Real-worl-data_IA`]
  - tvabund – species data in a long format, opened as dbf file from Turbowin/data/xx , species names as codes, cover as codes
  - tvhabita - header data,each releve has RELEVE_NR code, which matches the one in tvabund
  - species - species list, to translate the species codes to species names, stored in the Turbowin/species as species.dbf
  - nomenclature - alternative, file where the Turboveg codes are matched to more name variants/ Danihelka, Kaplan, ESy (file name: nomenclatureCZ-2023-04-02-IA)
  - cover - translation of cover codes to %, requires info on the cover-abundance scale (tvhabita) (file name: coverCZ-2023-04-07-IA)

### 8 Back to Gapminder, simple use of map
* `purrr::map()`, `furrr::map_future()`
* tidymodels

### 9 Moisture in Forest-steppe
* advanced usage of map 
* nested dataframes
