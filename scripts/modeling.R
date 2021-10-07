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
  accidents ~ upa + as.factor(year),
  analytical, family = "poisson")
model.glm.full <- glm(
  accidents ~ upa + as.factor(year) + pop,
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

model.glm.min %>%
  tbl_regression(exp = TRUE)

model.glm.year %>%
  tbl_regression(exp = TRUE)

model.glm.full %>%
  tbl_regression(exp = TRUE)

# adjusted ----------------------------------------------------------------

# modelo.glmm.min <- 
# glmer(accidents ~ upa  + as.factor(year) + (1 | upa), analytical, family = "poisson")

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
