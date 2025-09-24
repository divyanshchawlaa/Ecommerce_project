library(dplyr)
library(readr)

# RFM scoring
rfm <- rfm %>%
  mutate(
    r_score = ntile(-recency_days, 5),   # Recency: lower recency -> higher score
    f_score = ntile(frequency, 5),       # Frequency: higher frequency -> higher score
    m_score = ntile(monetary, 5),        # Monetary: higher spending -> higher score
    rfm_score = paste0(r_score, f_score, m_score)  # Combine into RFM score
  )

# Top 20 customers by monetary value
top_segments <- rfm %>% arrange(desc(monetary)) %>% head(20)

# Save full RFM summary to CSV
write_csv(rfm, "outputs/rfm_summary.csv")

# Display top customers for RMarkdown
top_customers <- top_segments
top_customers
