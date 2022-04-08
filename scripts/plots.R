# setup -------------------------------------------------------------------
# library(survminer)
library(directlabels)

ff.col <- "steelblue" # good for single groups scale fill/color brewer
ff.pal <- "Paired"    # good for binary groups scale fill/color brewer

scale_color_discrete <- function(...) scale_color_brewer(palette = ff.pal, ...)
scale_fill_discrete <- function(...) scale_fill_brewer(palette = ff.pal, ...)

analytical <- analytical %>%
  # restore factor levels for plotting
  mutate(upa = fct_relevel(upa, as.character(1:10)))

gg <- analytical %>%
  ggplot() +
  # scale_color_viridis_d() +
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

gg.dens <- gg.upa +
  # labs(title = "Distribution densities of UPA characteristics") +
  geom_density(fill = ff.col)

# cool facet trick from https://stackoverflow.com/questions/3695497 by JWilliman
gg.hist <- gg.upa +
  # labs(title = "Distributions of UPA characteristics") +
  scale_y_continuous(labels = scales::label_percent(accuracy = 1)) +
  geom_histogram(bins = 5, aes(y = ..count../tapply(..count.., ..PANEL.., sum)[..PANEL..]), fill = ff.col)

gg.pop <- gg +
  labs(
    x = NULL,
    y = "Population (per 10000)",
    color = 'UPA',
    ) +
  geom_line(aes(year, pop, group = upa, col = upa), size = 1)

gg.rate <- gg +
  labs(
    x = NULL,
    y = "Incidence rate (per 10000)",
    color = 'UPA',
    ) +
  scale_y_continuous(limits = c(0, 100)) +
  geom_line(aes(year, pred, group = upa, col = upa), size = 1)

# gg.pop <- gg.pop %>% direct.label(method = "right.polygons")
# gg.rate <- gg.rate %>% direct.label(method = "right.polygons")

# gridExtra::grid.arrange(
#   gg.pop,
#   gg.rate,
#   ncol = 2
# )

# gridExtra::grid.arrange(
#   gg.pop %>% direct.label(method = "right.polygons"),
#   gg.rate %>% direct.label(method = "right.polygons"),
#   ncol = 2
# )
