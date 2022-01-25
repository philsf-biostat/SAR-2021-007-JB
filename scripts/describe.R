# setup -------------------------------------------------------------------

# library(Hmisc) # describe
# library(skimr) # skim
# library(tableone)
# library(gmodels) # CrossTable
library(gtsummary)
library(gt)
# library(effectsize)
# library(finalfit) # missing_compare

# setup gtsummary theme
theme_gtsummary_journal("nejm")
theme_gtsummary_compact()
theme_gtsummary_mean_sd() # mean/sd
# theme_gtsummary_language(language = "pt") # traduzir

# exploratory -------------------------------------------------------------

# overall description
analytical %>%
  skimr::skim()

# checar condicoes de poisson/quasi-poisson
analytical %>%
  group_by(upa) %>%
  summarise(
    ac_m = mean(accidents),
    ac_sd = sd(accidents),
    cv = ac_sd/ac_m,
    # cap_m = mean(capturas, na.rm = TRUE),
    # cap_sd = sd(capturas, na.rm = TRUE),
    )

# minimum detectable effect size
# interpret_d(0.5)

# tables ------------------------------------------------------------------

tab_desc <- upa.raw %>%
  # select
  select(-upa, ) %>%
  tbl_summary(
    # by = upa,
    type = list(where(is.numeric) ~ "continuous2", cemitery ~ "dichotomous"),
    statistic = all_continuous() ~ c("{mean} ({sd})", "{median} ({p25}, {p75})", "{min}, {max}")
  ) %>%
  # modify_caption(caption = "**Tabela 1** Características demográficas") %>%
  # modify_header(label ~ "**Características dos pacientes**") %>%
  bold_labels() %>%
  modify_table_styling(columns = "label", align = "c")
