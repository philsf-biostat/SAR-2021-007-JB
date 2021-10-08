# setup -------------------------------------------------------------------
height <- 8
width <- 8
units <- "cm"

# publication ready tables ------------------------------------------------

# Don't need to version these files on git
# tab_inf %>%
#   as_gt() %>%
#   as_rtf() %>%
#   writeLines(con = "report/SAR-2021-007-JB-v01-T1.rtf")

tab_mod %>%
    as_gt() %>%
    as_rtf() %>%
    writeLines(con = "report/SAR-2021-007-JB-v01-T2.rtf")

# save plots --------------------------------------------------------------

ggsave(filename = "figures/outcome.png", plot = gg, height = height, width = width, units = units)
