# setup -------------------------------------------------------------------
# library(data.table)
library(tidyverse)
library(readxl)
# library(lubridate)
library(labelled)

# data loading ------------------------------------------------------------
set.seed(42)
# data.raw <- tibble(id=gl(2, 10), group = gl(2, 10), outcome = rnorm(20))
data.raw <- read_excel("dataset/capturas 2006 a 2013 Saudade.xls") %>%
  janitor::clean_names()


# data cleaning -----------------------------------------------------------

data.raw <- data.raw %>%
  # drop sepulturas não identificadas
  # filter(!is.na(sepultura)) %>%
  # adicionar id de cada sepultura/quadra
  group_by(quadra, sepultura) %>%
  mutate(id = cur_group_id(), .before = everything())
  # select()

# data wrangling ----------------------------------------------------------

# data.raw <- data.raw %>%
  

# labels ------------------------------------------------------------------

data.raw <- data.raw %>%
  set_variable_labels(
    capturas = "Captura Noturna",
  )

# analytical dataset ------------------------------------------------------

analytical <- data.raw %>%
  # select analytic variables
  select(
    id,
    quadra,
    sepultura,
    data,
    hora,
    capturas,
    femeas_c_filhotes,
  )

# mockup of analytical dataset for SAP and public SAR
analytical_mockup <- tibble( id = c( 1:3, "...", nrow(analytical) ) ) %>%
  left_join(analytical %>% head(0) %>% mutate(id=as.character(id)), by = "id") %>%
  mutate_all(as.character) %>%
  replace(is.na(.), "")
