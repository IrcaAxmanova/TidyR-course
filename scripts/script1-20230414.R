library(tidyverse)
library(magrittr)

##### Tidy data IA
# Tidy data makes it easy for an analyst or a computer to extract needed
# variables because it provides a standard way of structuring a dataset.
# A dataset is messy or tidy depending on how rows, columns and tables are
# matched up with observations, variables and types. In tidy data:
# 1.	Every column is a variable.
# 2.	Every row is an observation.
# 3.	Every cell is a single value.
# https://cran.r-project.org/web/packages/tidyr/vignettes/tidy-data.html

#### the five most common problems with messy datasets
# Examples
# Column headers are values, not variable names.
data <- read_csv(r'(data\Tidy-data-IA\Example1.csv)')
# Multiple variables are stored in one column.
data <- read_csv(r'(data\Tidy-data-IA\Example2.csv)')
# Variables are stored in both rows and columns.
data <- read_csv(r'(data\Tidy-data-IA\Example3.csv)')
# Multiple types of observational units are stored in the same table.
# A single observational unit is stored in multiple tables.


#extra reading
# https://davidzeleny.net/wiki/doku.php/recol:clean_and_tidy_script
# https://www.tidyverse.org/blog/2017/12/workflow-vs-script/
# https://r4ds.had.co.nz/tidy-data.html


#### special focus also on names of variables / without spaces

#Tidy data
# easy to handle / arrange, filter, mutate
#
data <- read_csv(r'(data\Tidy-data-IA\ExampleTidy.csv)')
tibble (data)
names (data)
table(data$Selection)

data.selection<- data %>% filter(Selection =="1")

data.selection %<>% arrange(VegType)

data.selection %<>% mutate(HerbsJuv = (Herbs +Juveniles) )

statistics <- data.selection %>% group_by(VegType) %>%
  summarise(Richness = mean(HerbsJuv), Productivity = mean(Biomass))


#' clean version
read_csv('data/Tidy-data-IA/ExampleTidy.csv') |>
  filter(Selection==1) |>
  mutate(HerbsJuv = (Herbs+Juveniles)) |>
  group_by(VegType) |>
  summarise(Richness = mean(HerbsJuv),
            Productivity = mean(Biomass),
            n = n()) |>
  write_csv('output.csv')






