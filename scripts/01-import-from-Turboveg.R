library(magrittr)
library(tidyverse)


##### TURBOVEG ####
#' the easiest way how to import the data from Turboveg2 is to copy the whole folder which is stored in Turbowin/Data,
#' and to use directly dbf files. I recommend to open them in Excel to see the structure and store them as txt, or csv
#' to the working directory. These files we can directly use as input data to R.

##### FILES #####
#' tvabund - species data in a long format, instead of species names we have species codes, each releve is indicated
#' by RELEVE_NR

#' tvhabita - header data, each releve has RELEVE_NR code, which matches the one in tvabund

#' species - to translate the species codes to species names we further need species list which is stored in
#'' Turbowin/species as species.dbf

#' nomenclature - alternative approach to species - I created a special file where the codes in Turboveg are directly
#' matched to more name variants/ Danihelka, Kaplan, ESy  (file name: nomenclatureCZ-2023-04-02-IA)

#' cover - in the file TVabund we have only original cover codes which we need to translate to %. However, first we
#' need to add the information on the cover-abundance scale from tvhabita and then we can append translation table.
#' This happens during the transport to JUICE automatically, but here we can adjust the final CoverPerc values in the
#' translation table. (file name: coverCZ-2023-04-02-IA)














