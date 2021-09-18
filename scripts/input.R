# setup -------------------------------------------------------------------
# library(data.table)
library(tidyverse)
library(readxl)
# library(lubridate)
library(labelled)

# data loading ------------------------------------------------------------
set.seed(42)
# data.raw <- tibble(id=gl(2, 10), group = gl(2, 10), outcome = rnorm(20))
data.raw <- read_excel("dataset/correlação escorpiões.xlsx") %>%
  janitor::clean_names()


# data cleaning -----------------------------------------------------------

# data.raw <- data.raw %>%
#   filter() %>%
#   select()

# data wrangling ----------------------------------------------------------

data.raw <- data.raw %>%
  # Passo 1: pivotar para tabela longa
  pivot_longer(
    -ano,
    names_to = c("tipo", "local"),
    values_to = "eventos",
    names_sep = "_",
    ) %>%
  # passo 2: pivotar de volta para ter as duas variáveis de interesse
  pivot_wider(
    names_from = tipo,
    values_from = eventos,
  )

# labels ------------------------------------------------------------------

data.raw <- data.raw %>%
  set_variable_labels(
    ano = "Ano",
    capturas = "Captura Noturna",
    acidentes = "Acidentes escorpiônicos",
  )

# analytical dataset ------------------------------------------------------

analytical <- data.raw %>%
  # select analytic variables
  select(
    ano,
    local,
    capturas,
    acidentes,
  )

# mockup of analytical dataset for SAP and public SAR
analytical_mockup <- tibble( ano = c( 1:3, "...", nrow(analytical) ) ) %>%
  left_join(analytical %>% head(0) %>% mutate(ano=as.character(ano)), by = "ano") %>%
  mutate_all(as.character) %>%
  replace(is.na(.), "")
