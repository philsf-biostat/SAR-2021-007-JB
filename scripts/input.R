# setup -------------------------------------------------------------------
# library(data.table)
library(tidyverse)
library(readxl)
library(lubridate)
library(labelled)

# data loading ------------------------------------------------------------
set.seed(42)
# data.raw <- tibble(id=gl(2, 10), group = gl(2, 10), outcome = rnorm(20))
data.raw <- read_excel("dataset/APAsAno.xlsx") %>%
  janitor::clean_names()


# data cleaning -----------------------------------------------------------

data.raw <- data.raw %>%
# filter() %>%
  # select()
  rename(
    pop = number_of_inhabitants,
    area = urban_territorial_area_km2,
    hydrography = hydrography_m2,
    railway = railway_lines_meters,
    recycling_no = municipal_recycling_centers_units,
  )

# data wrangling ----------------------------------------------------------

data.raw <- data.raw %>%
  mutate(
    upa = factor(upa),
    accidents = as.integer(accidents),
    pop = as.integer(pop),
    year = factor(year),
    )

# labels ------------------------------------------------------------------

data.raw <- data.raw %>%
  set_variable_labels(
    year = "Year",
    upa = "Urban Planning Area",
    accidents = "Number of accidents",
    pop = "Population",
    area = "Area (km²)",
    hydrography = "Hydrography area (m²)",
    railway = "Railway lines (m)",
    recycling_no = "Number of recycling units",
  )

# analytical dataset ------------------------------------------------------

analytical <- data.raw # %>%

# mockup of analytical dataset for SAP and public SAR
analytical_mockup <- tibble( upa = c( 1:3, "...", nrow(analytical) ) ) %>%
  left_join(analytical %>% head(0) %>% mutate(upa=as.character(upa)), by = "upa") %>%
  mutate_all(as.character) %>%
  replace(is.na(.), "")
