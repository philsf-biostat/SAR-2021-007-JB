# setup -------------------------------------------------------------------
height <- 16.5
width <- 16.5
units <- "cm"

# publication ready tables ------------------------------------------------

# Don't need to version these files on git
# tab_inf %>%
#   as_gt() %>%
#   as_rtf() %>%
#   writeLines(con = "report/SAR-yyyy-NNN-XX-v01-T1.rtf")

# save plots --------------------------------------------------------------

ggsave(filename = "figures/density.png", plot = gg.dens, height = height, width = width, units = units)
ggsave(filename = "figures/histogram.png", plot = gg.hist, height = height, width = width, units = units)
