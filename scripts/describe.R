# setup -------------------------------------------------------------------

# library(Hmisc) # describe
# library(skimr) # skim
# library(tableone)
# library(gmodels) # CrossTable
library(gtsummary)
library(gt)
# library(effectsize)

# setup gtsummary theme
theme_gtsummary_mean_sd() # mean/sd
# theme_gtsummary_language(language = "pt") # traduzir

# exploratory -------------------------------------------------------------

# overall description
analytical %>%
  skimr::skim()

# checar condicoes de poisson/quasi-poisson
analytical %>%
  group_by(local) %>%
  summarise(
    ac_m = mean(acidentes),
    ac_sd = sd(acidentes),
    cap_m = mean(capturas, na.rm = TRUE),
    cap_sd = sd(capturas, na.rm = TRUE),
    )

# minimum detectable effect size
# interpret_d(0.5)


# tables ------------------------------------------------------------------

tab_desc <- analytical %>%
  # select
  select(-ano, ) %>%
  tbl_summary(
    # by = group
  ) %>%
  # modify_caption(caption = "**Tabela 1** Características demográficas") %>%
  # modify_header(label ~ "**Características dos pacientes**") %>%
  bold_labels() %>%
  modify_table_styling(columns = "label", align = "c")

