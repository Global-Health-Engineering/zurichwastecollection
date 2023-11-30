# description -------------------------------------------------------------


# load packages -----------------------------------------------------------

library(readxl)
library(tidyverse)

# import data -------------------------------------------------------------

read_excel("data-raw/Waste Analysis.xlsx", sheet = 1)

## waste analysis data ------------

wk1 <- read_excel("data-raw/Waste Analysis.xlsx", range = "B2:E7") |>
  mutate(week = 1)

wk2 <- read_excel("data-raw/Waste Analysis.xlsx", range = "B13:E18") |>
  mutate(week = 2)

## time motion study

time_motion <- read_excel("data-raw/Time-Motion Study.xlsx", sheet = 1, skip = 1, range = "B2:L48") |>
  pivot_longer(cols = !`Collection Site`,
               names_to = "activity",
               values_to = "time") |>
  rename(collection_site = `Collection Site`)

# data manipulation -------------------------------------------------------

## waste analysis data ------------

weights <- bind_rows(wk1, wk2) |>
  janitor::clean_names() |>
  pivot_longer(cols = measured_weight_1_kg:measured_weight_3_kg,
               names_to = "measurement",
               values_to = "weight")


# export data -------------------------------------------------------------

usethis::use_data(weights, time_motion, overwrite = TRUE)

write_csv(weights, here::here("inst", "extdata", "weights.csv"))
write_csv(time_motion, here::here("inst", "extdata", "time_motion.csv"))

#Çopenxlsx::write.xlsx(locations, here::here("inst", "extdata", "locations.xlsx"))
#Çopenxlsx::write.xlsx(plastic_types, here::here("inst", "extdata", "plastic_types.xlsx"))
