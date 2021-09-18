# setup -------------------------------------------------------------------
# library(gt)
library(gtsummary)
# library(moderndive)
# library(broom)
library(lmerTest)
library(broom.mixed)

# raw estimate ------------------------------------------------------------

summary(glm(acidentes ~ capturas, analytical, family = "poisson"))

# adjusted ----------------------------------------------------------------

summary(glm(acidentes ~ capturas + local, analytical, family = "poisson"))

modelo <- glmer(acidentes ~ capturas + ano + (1| local), analytical, family = "poisson")
