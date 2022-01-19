# setup -------------------------------------------------------------------
library(VGAM)
# library(moderndive)
library(broom)
# library(lmerTest)
# library(broom.mixed)
# library(simputation)
# library(mice)

# accident count ----------------------------------------------------------

# model.min <- glm(
#   accidents ~ upa,
#   analytical, family = "poisson")
# model.year <- glm(
#   accidents ~ upa + year,
#   analytical, family = "poisson")
# model.full <- glm(
#   accidents ~ upa + year + pop,
#   analytical, family = "poisson")

# accident rate -----------------------------------------------------------

model.min <- vglm(
  accidents ~ upa -1,
  offset = log(pop),
  analytical, family = "pospoisson")
model.year <- vglm(
  accidents ~ upa + time -1,
  offset = log(pop),
  analytical, family = "pospoisson")
# to include interaction, consider using dummy variables for upa
model.full <- vglm(
  accidents ~ upa + time + pop -1,
  offset = log(pop),
  analytical, family = "pospoisson")

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

# diagnostics -------------------------------------------------------------

# number of accidents
model.min %>%
  summary()
model.year %>%
  summary()
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
                 include = upa,
                 )
tab_mod.year <- model.year %>%
  tbl_regression(exp = TRUE,
                 include = upa,
                 )
tab_mod.full <- model.full %>%
  tbl_regression(exp = TRUE,
                 include = upa,
                 )

tab_mod <- tbl_merge(
  list(
    tab_mod.crude,
    tab_mod.year,
    tab_mod.full
  ),
  tab_spanner = c("**Crude estimate**", "**Adjusted by Year**", "**Fully adjusted**")
)
