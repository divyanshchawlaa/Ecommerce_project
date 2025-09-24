# Load dataset
data <- read_csv("/Users/divyanshchawlaa/Documents/Gisma/Datasets/Ecommerce_project/data/ecommerce-data.csv")

# Clean names
data <- clean_names(data)

# Clean and transform
data_clean <- data %>%
  mutate(
    invoice_date = parse_date_time(invoice_date, orders = c("dmy HM","ymd HMS"), tz="UTC"),
    quantity = as.numeric(quantity),
    unit_price = as.numeric(unit_price),
    invoice_amount = quantity * unit_price,
    cancelled = grepl("^C", invoice_no),
    date = as_date(invoice_date),
    weekday = wday(invoice_date, label=TRUE),
    is_weekend = weekday %in% c("Sat","Sun")
  ) %>%
  filter(!(quantity <= 0 & !cancelled)) %>%
  filter(!(unit_price <= 0 & !cancelled)) %>%
  filter(!is.na(customer_id))

# Summary
data_clean %>%
  summarise(total_rows = n(),
            unique_customers = n_distinct(customer_id),
            total_revenue = sum(invoice_amount, na.rm=TRUE),
            cancellations = sum(cancelled))