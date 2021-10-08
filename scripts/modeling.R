# setup -------------------------------------------------------------------
# library(gt)
library(gtsummary)
# library(moderndive)
library(broom)
# library(lmerTest)
# library(broom.mixed)

# number of accidents -----------------------------------------------------

model.glm.min <- glm(
  accidents ~ upa,
  analytical, family = "poisson")
model.glm.year <- glm(
  accidents ~ upa + year,
  analytical, family = "poisson")
model.glm.full <- glm(
  accidents ~ upa + year + pop,
  analytical, family = "poisson")

# accidents/pop -----------------------------------------------------------

model.glm.min.offset <- glm(
  accidents ~ upa + offset(log(pop)),
  analytical, family = "poisson")
model.glm.year.offset <- glm(
  accidents ~ upa + year + offset(log(pop)),
  analytical, family = "poisson")
model.glm.full.offset <- glm(
  accidents ~ upa + year + pop + offset(log(pop)),
  analytical, family = "poisson")

# random effects on upa ---------------------------------------------------

# model.glmm.min <- glmer(accidents ~ upa + (1 | upa), analytical, family = "poisson")

# model.glmm.min %>%
#   summary()
# model.glmm.min %>%
#   tidy()
# model.glmm.min %>%
#   glance()

# diagnostics -------------------------------------------------------------

# number of accidents
model.glm.min %>%
  summary()
model.glm.year %>%
  summary()
model.glm.full %>%
  summary()

model.glm.min %>%
  tidy()
model.glm.year %>%
  tidy()
model.glm.full %>%
  tidy()

model.glm.min %>%
  glance()
model.glm.year %>%
  glance()
model.glm.full %>%
  glance()

anova(model.glm.min, model.glm.year, model.glm.full, test = "Chisq")
AIC(model.glm.min, model.glm.year, model.glm.full)

# Accident incidence proportion
model.glm.min.offset %>% summary()
model.glm.year.offset %>% tidy()
model.glm.full.offset %>% glance()
anova(model.glm.min.offset, model.glm.year.offset, model.glm.full.offset, test = "Chisq")
AIC(model.glm.min.offset, model.glm.year.offset, model.glm.full.offset)

# final model -------------------------------------------------------------

tab_mod.crude <- model.glm.min %>%
  tbl_regression(exp = TRUE, include = upa)

tab_mod.year <- model.glm.year %>%
  tbl_regression(exp = TRUE, include = upa)

tab_mod.full <- model.glm.full %>%
  tbl_regression(exp = TRUE, include = upa)

tab_mod <- tbl_merge(
  list(
    tab_mod.crude,
    tab_mod.year,
    tab_mod.full
  ),
  tab_spanner = c("Crude estimate", "Adjusted by Year", "Adjusted by Year and Population")
)
