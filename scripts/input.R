# setup -------------------------------------------------------------------
library(philsfmisc)
# library(data.table)
library(tidyverse)
library(readxl)
library(lubridate)
# library(haven)
# library(foreign)
# library(naniar)
library(labelled)
library(units)

# data loading ------------------------------------------------------------
set.seed(42)
# data.raw <- tibble(id=gl(2, 10), group = gl(2, 10), outcome = rnorm(20))
data.raw <- read_excel("dataset/APAsAno.xlsx") %>%
  janitor::clean_names()
upa.raw <- read_excel("dataset/UPA.xlsx") %>%
  janitor::clean_names()

# data cleaning -----------------------------------------------------------

data.raw <- data.raw %>%
# filter() %>%
  # select()
  rename(
    pop = number_of_inhabitants,
  )

upa.raw <- upa.raw %>%
  rename(
    upa = urban_planning_areas_upa,
    sewage = sewage_system_km,
    rain = rainwater_network_km,
    green = green_areas_km2,
    garbage = irregular_garbage_disposal_areas,
    # junk = junkyards_units,
    burn = burned_out_areas_foci,
    # recycling_inf = informal_recycling_units,
    area = urban_territorial_area_km2,
    hydrography = hydrography_km2,
    # railway = railway_lines_meters,
    # recycling_mun = municipal_recycling_centers_units,
    square = squares_and_leisure_areas_km2,
  ) %>%
  mutate(upa = as.numeric(str_remove(upa, "UPA-"))) %>%
  # identify UPAs with a cemitery
  mutate(
    cemitery = case_when(
      upa %in% c(4, 6) ~ 1,
      TRUE ~ 0
    )
  )

# data wrangling ----------------------------------------------------------

data.raw <- data.raw %>%
  mutate(
    upa = factor(upa),
    # set 10 as reference level
    upa = relevel(upa, 10),
    accidents = as.integer(accidents),
    pop = pop/10000,
    time = year - min(year) + 1, # recenter to start at 1
    # year = factor(year),
  )

upa.raw <- upa.raw %>%
  # Unit conversion
  mutate(
    # set current unit
    green = set_units(green, "km^2"),
    hydrography = set_units(hydrography, "km^2"),
    square = set_units(square, "km^2"),
    # railway = set_units(railway, "m"),
    # convert to new unit
    green = as.numeric(set_units(green, "km^2")),
    hydrography = as.numeric(set_units(hydrography, "km^2")),
    square = as.numeric(set_units(square, "km^2")),
    # railway = as.numeric(set_units(railway, "km")),
  ) %>%
  mutate(
    upa = factor(upa),
  )

# labels ------------------------------------------------------------------

data.raw <- data.raw %>%
  set_variable_labels(
    year = "Year",
    time = "Year",
    upa = "Urban Planning Area",
    accidents = "Number of accidents",
    pop = "Population",
  )

upa.raw <- upa.raw %>%
  set_variable_labels(
    upa = "Urban Planning Area",
    sewage = "Sewage network (km)",
    rain = "Rainwater network (km)",
    green = "Green areas (km²)",
    garbage = "Irregular garbage disposal areas",
    # recycling_inf = "Informal recycling units",
    # junk = "Junkyard units",
    burn = "Burned-out areas (foci)",
    area = "Area (km²)",
    hydrography = "Hydrography area (km²)",
    # railway = "Railway lines (km)",
    # recycling_mun = "Municipal recycling units",
    square = "Squares and leisure areas (m²)",
    recycling_units = "Recycling units",
    cemitery = "Presence of a cemitery",
  )

# analytical dataset ------------------------------------------------------

analytical <- data.raw # %>%

# mockup of analytical dataset for SAP and public SAR
analytical_mockup <- tibble( upa = c( 1:3, "...", nrow(analytical) ) ) %>%
  left_join(analytical %>% head(0) %>% mutate(upa=as.character(upa)), by = "upa") %>%
  mutate_all(as.character) %>%
  replace(is.na(.), "")
