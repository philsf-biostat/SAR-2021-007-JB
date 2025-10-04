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
  mutate(
    var = str_to_upper(var),
    var = factor(var, levels =str_to_upper(c(
      "area",
      "green",
      "hydrography",
      "sewage",
      "rain",
      "square",
      "garbage",
      "recycling_units",
      "burn"
    ))),
  ) %>%
  ggplot(aes(val)) +
  theme_ff() +
  scale_color_brewer(palette = ff.pal) +
  scale_fill_brewer(palette = ff.pal) +
  xlab("") +
  facet_wrap(~ var, scales = "free", ncol = 3)

# plots -------------------------------------------------------------------

gg.dens <- gg.upa +
  # labs(title = "Distribution densities of UPA characteristics") +
  ylab("Density") +
  geom_density(fill = ff.col)

# cool facet trick from https://stackoverflow.com/questions/3695497 by JWilliman
gg.hist <- gg.upa +
  # labs(title = "Distributions of UPA characteristics") +
  scale_y_continuous(labels = scales::label_percent(accuracy = 1)) +
  ylab("") +
  geom_histogram(bins = 5, aes(y = ..count../tapply(..count.., ..PANEL.., sum)[..PANEL..]), fill = ff.col)

gg.pop <- gg +
  labs(
    x = NULL,
    y = "Population",
    color = 'UPA',
    ) +
  scale_x_continuous(breaks = seq(1998, 2018, 5)) +
  scale_y_continuous(labels = style_number) +
  geom_line(aes(year, pop, group = upa, col = upa), lwd = 1)

gg.pop

gg.rate <- gg +
  labs(
    x = NULL,
    y = "Incidence rate (per 10000)",
    color = 'UPA',
    ) +
  scale_y_continuous(limits = c(0, 100)) +
  geom_line(aes(year, pred, group = upa, col = upa), lwd = 1)

# Plot the calculated RRs over time
gg.rr <- gg +
  aes(x = year, y = rr, group = upa, color = upa) +
  geom_line(lwd = 1) +
  geom_hline(yintercept = 1, linetype = "dashed", color = "black") +
  scale_x_continuous(breaks = seq(1998, 2018, 5)) +
  labs(
    # title = "Predicted Risk Ratios (RRs) Over Time",
    # x = "Year",
    x = "",
    y = "Risk Ratio (RR)",
    color = "UPA"
  )

gg.rr

gg.pop <- gg.pop %>% direct.label(method = "right.polygons")
# gg.rate <- gg.rate %>% direct.label(method = "right.polygons")
gg.rr <- gg.rr  %>% direct.label(method = "right.polygons")


gg.totals <- analytical %>%
  group_by(year) %>%
  summarise(accidents=sum(accidents)) %>%
  ggplot(aes(year, accidents)) +
  geom_col(fill="steelblue", ) +
  theme_ff() +
  labs(x="", y="Number of accidents") +
  scale_x_continuous(breaks = 1998:2018) + theme(axis.text.x = element_text(angle = 45, hjust = 1))

gg.totals

# gridExtra::grid.arrange(
#   gg.pop,
#   gg.rr,
#   ncol = 2
# )

# gridExtra::grid.arrange(
#   gg.pop %>% direct.label(method = "right.polygons"),
#   gg.rr  %>% direct.label(method = "right.polygons"),
#   ncol = 2
# )
