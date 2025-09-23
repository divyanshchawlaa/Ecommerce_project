# Load required packages
library(tidyverse)
library(lubridate)
library(janitor)

# 1️⃣ Load dataset (full path)
data <- read_csv("/Users/divyanshchawlaa/Documents/Gisma/Datasets/Ecommerce_project/data/ecommerce-data.csv")

# 2️⃣ Inspect initial structure
glimpse(data)
skimr::skim(data)

# 3️⃣ Clean column names
data <- clean_names(data)

# 4️⃣ Parse invoice_date into proper datetime
data <- data %>%
  mutate(invoice_date = parse_date_time(invoice_date, orders = c("dmy HM","ymd HMS"), tz="UTC"))

# 5️⃣ Create new columns
data_clean <- data %>%
  # Convert numeric columns
  mutate(quantity = as.numeric(quantity),
         unit_price = as.numeric(unit_price),
         invoice_amount = quantity * unit_price,
         # Flag cancelled invoices
         cancelled = grepl("^C", invoice_no),
         # Extract date and weekday info
         date = as_date(invoice_date),
         weekday = wday(invoice_date, label = TRUE),
         is_weekend = weekday %in% c("Sat","Sun")
  ) %>%
  # Remove invalid rows: negative quantity/unit_price only if not cancelled
  filter(!(quantity <= 0 & !cancelled)) %>%
  filter(!(unit_price <= 0 & !cancelled)) %>%
  filter(!is.na(customer_id))

# 6️⃣ Quick summary of cleaned data
data_clean %>%
  summarise(
    total_rows = n(),
    unique_customers = n_distinct(customer_id),
    total_revenue = sum(invoice_amount, na.rm=TRUE),
    cancellations = sum(cancelled)
  )

# 7️⃣ Invoice-level aggregation (AOV)
invoice_summary <- data_clean %>%
  group_by(invoice_no, date, is_weekend, cancelled) %>%
  summarise(aov = sum(invoice_amount, na.rm=TRUE), .groups="drop")

# 8️⃣ Customer-level RFM metrics
today <- max(data_clean$date, na.rm=TRUE) + 1
rfm <- data_clean %>%
  group_by(customer_id) %>%
  summarise(
    recency_days = as.numeric(today - max(date)),
    frequency = n_distinct(invoice_no),
    monetary = sum(invoice_amount, na.rm=TRUE),
    .groups = "drop"
  )

# 9️⃣ Verify outputs
head(invoice_summary)
head(rfm)
