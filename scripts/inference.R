# setup -------------------------------------------------------------------
# library(infer)

# tables ------------------------------------------------------------------

library(tidyverse)

# Calculate predicted accident counts for the full dataset
analytical$pred <- predict(model.final, type = "response")

# Identify the baseline year and its predicted counts
baseline_year <- 1998

# Calculate the predicted RR for each UPA over time
analytical <- analytical %>%
  group_by(upa) %>%
  mutate(
    baseline_pred = pred[year == baseline_year],
    rr = pred / baseline_pred
  ) %>%
  ungroup()

pred_2018 <- analytical %>%
  filter(year == 2018)
pred_2018$pred_2018 <- model.final %>% predict(newdata=pred_2018, type = "response")

pred_2018 <- pred_2018 %>% mutate(
  rr_2018 = pred_2018 / baseline_pred,
)

# pred_2018 %>% select(-pred,-rr) %>% writexl::write_xlsx("incidencias_2018.xlsx")

tab.rr <- model.final %>%
  tbl_regression(exp=TRUE) %>%
  remove_abbreviation("IRR = Incidence Rate Ratio") %>%
  modify_header(estimate ~ "**RR**") %>%
  modify_abbreviation("RR = Risk Ratio")

tab.rr

# tab.rr %>% as_flex_table() %>% flextable::save_as_image(path = "figures/rr_table.png" )
# tab.rr %>% as_flex_table() %>% flextable::save_as_docx( path = "figures/rr_table.docx")

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
