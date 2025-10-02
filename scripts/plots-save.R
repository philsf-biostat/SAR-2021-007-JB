# setup -------------------------------------------------------------------
height <- 12
width <- 12
units <- "cm"

# publication ready tables ------------------------------------------------

# Don't need to version these files on git
# tab_inf %>%
#   as_gt() %>%
#   as_rtf() %>%
#   writeLines(con = "report/SAR-2021-007-JB-v01-T2.rtf")

# tab_mod %>%
#     as_gt() %>%
#     as_rtf() %>%
#     writeLines(con = "report/SAR-2021-007-JB-v01-T2.rtf")

# save plots --------------------------------------------------------------

# ggsave(filename = "figures/density.png", plot = gg.dens, height = 16, width = 16, units = units)
# ggsave(filename = "figures/histogram.png", plot = gg.hist, height = 16, width = 16, units = units)
ggsave(filename = "figures/pop.png", plot = gg.pop, height = height, width = width, units = units)
ggsave(filename = "figures/rr.png", plot = gg.rr, height = height, width = width, units = units)
ggsave(filename = "figures/total_accidents.png", plot = gg.totals, height = height, width = width, units = units)
ggsave(filename = "figures/exposure_incidence.png", plot = gridExtra::arrangeGrob(gg.pop, gg.rr, ncol = 2), h = 18, w = 24, units = units)
