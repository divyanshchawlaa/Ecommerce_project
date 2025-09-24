# Invoice summary
invoice_summary <- data_clean %>%
  group_by(invoice_no, date, is_weekend, cancelled) %>%
  summarise(aov = sum(invoice_amount, na.rm=TRUE), .groups="drop")

# Plot 1: AOV distribution
p1 <- ggplot(invoice_summary, aes(x=aov)) + 
  geom_histogram(bins=60, fill="steelblue", color="black") + 
  scale_x_log10() + 
  labs(title="AOV Distribution (Log Scale)", x="AOV (log scale)", y="Count")
p1

# Plot 2: Weekend vs Weekday AOV
p2 <- ggplot(invoice_summary, aes(x=is_weekend, y=aov)) +
  geom_boxplot(fill="lightgreen") +
  scale_y_continuous(trans='log10') +
  labs(title="AOV: Weekend vs Weekday", x="Weekend", y="AOV (log scale)")
p2

# Plot 3: Top 10 countries by cancellations
top_cancel <- data_clean %>% filter(cancelled) %>%
  count(country, sort=TRUE) %>% top_n(10)
p3 <- ggplot(top_cancel, aes(x=reorder(country,n), y=n)) +
  geom_col(fill="coral") + coord_flip() +
  labs(title="Top 10 Countries by Cancellations", x="Country", y="Cancellations")
p3
