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

gg <- upa.raw %>%
  select(-cemitery) %>%
  pivot_longer(-upa, names_to = "var", values_to = "val") %>%
  ggplot(aes(val)) +
  scale_color_brewer(palette = ff.pal) +
  scale_fill_brewer(palette = ff.pal) +
  xlab("") + ylab("") +
  facet_wrap(~ var, scales = "free", ncol = 3)

# plots -------------------------------------------------------------------

# gg <- ggplot(analytical, aes(outcome, fill = group)) +
#   geom_density( alpha = .8) +
#   # scale_color_brewer(palette = ff.pal) +
#   scale_fill_brewer(palette = ff.pal) +
#   labs()

gg.dens <- gg +
  geom_density(fill = ff.col) +
  labs(title = "Distribution densities of APU characteristics")

# cool facet trick from https://stackoverflow.com/questions/3695497 by JWilliman
gg.hist <- gg +
  geom_histogram(bins = 5, aes(y = ..count../tapply(..count.., ..PANEL.., sum)[..PANEL..]), fill = ff.col) +
  scale_y_continuous(labels = scales::label_percent(accuracy = 1)) +
  labs(title = "Distributions of APU characteristics")

analytical %>%
  ggplot(aes(year, pop, group = upa, col = upa)) +
  geom_line()
