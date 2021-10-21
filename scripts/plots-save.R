# setup -------------------------------------------------------------------
height <- 8
width <- 8
units <- "cm"

# publication ready tables ------------------------------------------------

# Don't need to version these files on git
# tab_inf %>%
#   as_gt() %>%
#   as_rtf() %>%
#   writeLines(con = "report/SAR-yyyy-NNN-XX-v01-T1.rtf")

# save plots --------------------------------------------------------------

ggsave(filename = "figures/density.png", plot = gg.dens, height = 16, width = 16, units = units)
ggsave(filename = "figures/histogram.png", plot = gg.hist, height = 16, width = 16, units = units)
ggsave(filename = "figures/pop.png", plot = gg.pop, height = height, width = width, units = units)
ggsave(filename = "figures/rate.png", plot = gg.rate, height = height, width = width, units = units)
