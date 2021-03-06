# setup -------------------------------------------------------------------
# library(infer)

# tables ------------------------------------------------------------------

analytical$pred <- model.full %>% predict %>% exp # model predictions

pred_2018 <- analytical %>%
  filter(year == 2018)

# template p-value table
# tab_inf <- analytical %>%
#   # select
#   select(-year, ) %>%
#   tbl_summary(
#     by = upa,
#     type = list(
#       recyling_no = "continuous",
#       railway = "continuous"
#     ),
#   ) %>%
#   # include study N
#   add_overall() %>%
#   # pretty format categorical variables
#   bold_labels() %>%
#   # bring home the bacon!
#   add_p(
#     # use Fisher test (defaults to chi-square)
#     test = all_categorical() ~ "fisher.test",
#     # test.args = all_tests("fisher.test") ~ list(simulate.p.value=TRUE),
#     # use 3 digits in pvalue
#     pvalue_fun = function(x) style_pvalue(x, digits = 3)
#   ) %>%
#   # bold significant p values
#   bold_p()

# Template Cohen's D table (obs: does NOT compute p)
# tab_inf <- analytical %>%
#   # select
#   select(
#     -id,
#   ) %>%
#   tbl_summary(
#     by = group,
#   ) %>%
#   add_difference(
#     test = all_continuous() ~ "cohens_d",
#     # ANCOVA
#     adj.vars = c(sex, age, bmi),
#   ) %>%
#   modify_header(estimate ~ '**d**') %>%
#   bold_labels()
