# setup -------------------------------------------------------------------
library(VGAM)
# library(MASS)
# library(moderndive)
library(broom)
# library(lmerTest)
# library(broom.mixed)
# library(simputation)
# library(mice)

reset_gtsummary_theme()
theme_gtsummary_journal("nejm") # separate CI column for tab_mod
theme_gtsummary_compact()

# accident rate -----------------------------------------------------------

model.min <- glm(
  accidents ~ upa + offset(log(pop)),
  # offset = log(pop),
  analytical, family = "poisson")
# model.year <- glm(
#   accidents ~ upa + time,
#   offset = log(pop),
#   analytical, family = "poisson")
model.full <- glm(
  accidents ~ upa * time + offset(log(pop)),
  # offset = log(pop),
  analytical, family = "poisson")

# accident rate (positive poisson)

# model.min <- vglm(
#   accidents ~ upa -1,
#   offset = log(pop),
#   analytical, family = "pospoisson")
# model.year <- vglm(
#   accidents ~ upa + time -1,
#   offset = log(pop),
#   analytical, family = "pospoisson")
# # to include interaction, consider using dummy variables for upa
# model.full <- vglm(
#   accidents ~ upa * time -1,
#   offset = log(pop),
#   analytical, family = "pospoisson")

# random effects on upa ---------------------------------------------------

# model.min <- glmer(
#   accidents ~ upa + ( time + pop -1| upa) -1,
#   offset = log(pop),
#   analytical, family = poisson)
# model.year <- glmer(
#   accidents ~ upa + time + ( time + pop -1| upa) -1,
#   offset = log(pop),
#   analytical, family = poisson)
# model.full <- glmer(
#   accidents ~ upa + time + pop + ( time + pop -1| upa) -1,
#   offset = log(pop),
#   analytical, family = poisson)

# model.min <- glmer(accidents ~ upa + (1|upa) + offset(log(pop)), analytical, family = poisson)

# model.full <- glmer(accidents ~ upa*time + (1|upa) + offset(log(pop)), analytical, family = poisson)
# 
# model.full %>% summary()

# library(AER)
AER::dispersiontest(model.full)

# model.final <- glmer.nb(accidents ~ upa*time + (1|upa) + offset(log(pop)), data.raw, family = nbinom2)
# 
# model.final %>% summary()

# Negative Binomial -------------------------------------------------------


# glm.nb(accidents ~ upa + offset(log(pop)), analytical) %>% summary()

model.final <- MASS::glm.nb(accidents ~ upa*time + offset(log(pop)), analytical)

model.final %>% summary()

tab <- model.final %>%
  tbl_regression(exp=TRUE, pvalue_fun = label_style_pvalue(digits=3)) %>%
  remove_abbreviation("IRR = Incidence Rate Ratio") %>%
  modify_header(estimate ~ "**RR**") %>%
  modify_abbreviation("RR = Risk Ratio")

tab %>% bold_p()

# Binomial log link -------------------------------------------------------

# analytical <- analytical %>% mutate(safes = pop-accidents)

# should we use offset/risk instead of counts for this approach?

# glm(cbind(accidents, pop-accidents) ~ upa*time, family = binomial("log"), data = analytical) %>% summary()

# glm(cbind(accidents, pop-accidents) ~ upa*time, family = binomial("log"), data = analytical) %>% tbl_regression(exp=TRUE) %>% bold_p()

# glm(cbind(accidents, pop-accidents) ~ upa*time + offset(log(pop)), family = binomial("log"), data = analytical) %>% summary()

# glm(cbind(accidents, pop-accidents) ~ upa*time + offset(log(pop)), family = binomial("log"), data = analytical) %>% tbl_regression(exp=TRUE) %>% bold_p()

# diagnostics -------------------------------------------------------------

# number of accidents
model.min %>%
  summary()
# model.year %>%
#   summary()
model.full %>%
  summary()

# model.min %>%
#   tidy()
# model.year %>%
#   tidy()
# model.full %>%
#   tidy()
# 
# model.min %>%
#   glance()
# model.year %>%
#   glance()
# model.full %>%
#   glance()
# 
# anova(model.min, model.year, model.full, test = "Chisq")
# AIC(model.min, model.year, model.full)

# final model -------------------------------------------------------------

tab_mod.crude <- model.min %>%
  tbl_regression(exp = TRUE,
                 # include = upa,
                 add_estimate_to_reference_rows = TRUE,
                 ) %>% bold_labels()
# tab_mod.year <- model.year %>%
#   tbl_regression(exp = TRUE,
#                  # include = upa,
#                  add_estimate_to_reference_rows = TRUE,
#                  ) %>% bold_labels()
tab_mod.full <- model.full %>%
  tbl_regression(exp = TRUE,
                 # include = upa,
                 add_estimate_to_reference_rows = TRUE,
                 ) %>% bold_labels()

tab_headers <- c("Crude estimate",
                 # "**Adjusted by Year**",
                 "Fully adjusted")

tab_mod <- tbl_merge(
  list(
    tab_mod.crude,
    # tab_mod.year,
    tab_mod.full
  ),
  tab_spanner = paste0("**", tab_headers, "**")
)

## reduce table 2, and save complete table for A1
tab_mod2 <- tab_mod
tab_mod$table_body %>% filter(variable == "upa")
tab_mod$table_body <- tab_mod$table_body %>% filter(variable == "upa")
