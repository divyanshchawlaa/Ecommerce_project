library(dplyr)

# 1. Weekend vs Weekday AOV (t-test)
if(length(unique(invoice_summary$is_weekend)) == 2){
  invoice_summary <- invoice_summary %>% mutate(log_aov = log1p(aov))
  ttest_weekend <- t.test(log_aov ~ is_weekend, data=invoice_summary)
} else {
  ttest_weekend <- "T-test skipped: 'is_weekend' does not have 2 levels in the data."
}
ttest_weekend

# 2. Top 20% monetary customers frequency (t-test)
today <- max(data_clean$date, na.rm=TRUE) + 1
rfm <- data_clean %>%
  group_by(customer_id) %>%
  summarise(
    recency_days = as.numeric(today - max(date)),
    frequency = n_distinct(invoice_no),
    monetary = sum(invoice_amount, na.rm=TRUE),
    .groups="drop"
  )

threshold <- quantile(rfm$monetary, 0.8)
rfm <- rfm %>% mutate(top20 = monetary >= threshold)

if(length(unique(rfm$top20)) == 2){
  ttest_top20 <- t.test(frequency ~ top20, data=rfm)
} else {
  ttest_top20 <- "T-test skipped: 'top20' does not have 2 levels."
}
ttest_top20

# 3. Chi-square: Cancellations by Top 10 Countries
top_countries <- data_clean %>% 
  count(country, sort=TRUE) %>% 
  slice_head(n=10) %>% 
  pull(country)

chi_table <- table(data_clean$country %in% top_countries, data_clean$cancelled)

if(all(dim(chi_table) >= 2)){
  chi_country <- chisq.test(chi_table)
} else {
  chi_country <- "Chi-square test skipped: Table does not have 2x2 dimensions."
}
chi_country

# 4. Chi-square: Weekend vs Weekday Cancellations
chi_weekend_table <- table(data_clean$is_weekend, data_clean$cancelled)

if(all(dim(chi_weekend_table) >= 2)){
  chi_weekend_test <- chisq.test(chi_weekend_table)
} else {
  chi_weekend_test <- "Chi-square test skipped: Table does not have 2x2 dimensions."
}
chi_weekend_test
