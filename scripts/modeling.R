# setup -------------------------------------------------------------------
# library(gt)
library(gtsummary)
# library(moderndive)
library(broom)
# library(lmerTest)
# library(broom.mixed)

# raw estimate ------------------------------------------------------------

model.glm.min <- glm(
  accidents ~ upa,
  analytical, family = "poisson")
model.glm.year <- glm(
  accidents ~ upa + year,
  analytical, family = "poisson")
model.glm.full <- glm(
  accidents ~ upa + year + pop,
  analytical, family = "poisson")

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

# adjusted ----------------------------------------------------------------

# modelo.glmm.min <- 
# glmer(accidents ~ upa  + year + (1 | upa), analytical, family = "poisson")

# modelo.glmm.min %>%
#   summary()
# 
# modelo.glmm.min %>%
#   tidy()
# 
# modelo.glmm.min %>%
#   glance()
# 
# data.raw %>%
#   glmer(formula = capturas  ~ femeas_c_filhotes + temp_max_int + u_r_ext_percent + ( 1 | quadra), family = "poisson")
