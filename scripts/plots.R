# setup -------------------------------------------------------------------
# library(ggplot2)
# library(survminer)

ff.col <- "steelblue" # good for single groups scale fill/color brewer
ff.pal <- "Paired"    # good for binary groups scale fill/color brewer

scale_color_discrete <- function(...) scale_color_brewer(palette = ff.pal, ...)
scale_fill_discrete <- function(...) scale_fill_brewer(palette = ff.pal, ...)

gg <- analytical %>%
  ggplot() +
  scale_color_brewer(palette = ff.pal) +
  scale_fill_brewer(palette = ff.pal) +
  theme_ff()

gg.upa <- upa.raw %>%
  select(-cemitery) %>%
  pivot_longer(-upa, names_to = "var", values_to = "val") %>%
  ggplot(aes(val)) +
  theme_ff() +
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

gg.dens <- gg.upa +
  geom_density(fill = ff.col) +
  labs(title = "Distribution densities of APU characteristics")

# cool facet trick from https://stackoverflow.com/questions/3695497 by JWilliman
gg.hist <- gg.upa +
  geom_histogram(bins = 5, aes(y = ..count../tapply(..count.., ..PANEL.., sum)[..PANEL..]), fill = ff.col) +
  scale_y_continuous(labels = scales::label_percent(accuracy = 1)) +
  labs(title = "Distributions of APU characteristics")

gg.pop <- gg +
  labs(
    x = NULL,
    y = "Population (per 10000)",
    color = 'UPA',
    ) +
  geom_line(aes(year, pop, group = upa, col = upa), size = .7)

gg.rate <- gg +
  labs(
    x = NULL,
    y = "Observed incidence rate (per 10000)",
    color = 'UPA',
    ) +
  geom_line(aes(year, accidents/pop, group = upa, col = upa), size = .7, alpha = .8)
