#Weekend vs Weekday AOV (t-test, keep for numeric)
invoice_summary <- invoice_summary %>% mutate(log_aov = log1p(aov))
ttest_weekend <- t.test(log_aov ~ is_weekend, data=invoice_summary)

#Top 20% monetary customers frequency (t-test, keep for numeric)
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
ttest_top20 <- t.test(frequency ~ top20, data=rfm)

#Chi-square: Cancellations by Country
top_countries <- data_clean %>% 
  count(country, sort=TRUE) %>% top_n(10) %>% pull(country)

# Make a table of cancellations (Yes/No) by top 10 countries
chi_table <- table(data_clean$country %in% top_countries, data_clean$cancelled)
chi_country <- chisq.test(chi_table)

#Chi-square: Weekend vs Weekday cancellations ---
chi_weekend <- table(data_clean$is_weekend, data_clean$cancelled)
chi_weekend_test <- chisq.test(chi_weekend)
