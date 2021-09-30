# setup -------------------------------------------------------------------
# library(gt)
library(gtsummary)
# library(moderndive)
# library(broom)
library(lmerTest)
library(broom.mixed)

# raw estimate ------------------------------------------------------------

modelo.glm <- glm(capturas ~ date_time:id, analytical, family = "poisson")
modelo.glm %>%
  summary()

modelo.glm %>%
  tidy()

modelo.glm %>%
  glance()

# adjusted ----------------------------------------------------------------

modelo.glmm.min <- glmer(capturas ~  (1 | quadra / sepultura), analytical, family = "poisson")

modelo.glmm.min %>%
  summary()

modelo.glmm.min %>%
  tidy()

modelo.glmm.min %>%
  glance()

data.raw %>%
  glmer(formula = capturas  ~ femeas_c_filhotes + temp_max_int + u_r_ext_percent + ( 1 | quadra), family = "poisson")
