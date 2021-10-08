# setup -------------------------------------------------------------------
# library(ggplot2)
# library(survminer)

ff.col <- "steelblue" # good for single groups scale fill/color brewer
ff.pal <- "Paired"    # good for binary groups scale fill/color brewer

# Theme setting (less is more)
theme_set(
  theme_classic()
)
theme_update(
  legend.position = "top"
)

# plots -------------------------------------------------------------------

# gg <- ggplot(analytical, aes(outcome, fill = group)) +
#   geom_density( alpha = .8) +
#   # scale_color_brewer(palette = ff.pal) +
#   scale_fill_brewer(palette = ff.pal) +
#   labs()

 gg.dens <- upa.raw %>%
  select(-cemitery) %>%
  pivot_longer(-upa, names_to = "var", values_to = "val") %>%
  ggplot(aes(val)) +
  geom_density(fill = ff.col) +
  facet_wrap(~ var, scales = "free", ncol = 3) +
  labs(title = "Distribution densities of APU characteristics", x = "")
 
gg.hist <- upa.raw %>%
  select(-cemitery) %>%
  pivot_longer(-upa, names_to = "var", values_to = "val") %>%
  ggplot(aes(val)) +
  geom_histogram(bins = 5, fill = ff.col) +
  facet_wrap(~ var, scales = "free", ncol = 3) +
  labs(title = "Distributions of APU characteristics", x = "")
