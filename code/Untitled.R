# Install if missing
install.packages(c("tidyverse","lubridate","skimr","janitor","rstatix","broom","ggpubr","caret","pROC","car","gridExtra"))

# Load packages
library(readr)
library(tidyverse)
library(lubridate)
library(skimr)
library(janitor)
library(rstatix)
library(broom)
library(ggpubr)
library(caret)
library(pROC)
library(car)
library(gridExtra)


# Load the dataset from your path
data <- read_csv("/Users/divyanshchawlaa/Documents/Gisma/Datasets/Ecommerce_project/data/ecommerce-data.csv")

# Inspect
glimpse(data)
skimr::skim(data)

data <- clean_names(data)

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

# Summary of cleaned data
data_clean %>%
  summarise(total_rows = n(),
            unique_customers = n_distinct(customer_id),
            total_revenue = sum(invoice_amount, na.rm=TRUE),
            cancellations = sum(cancelled))

invoice_summary <- data_clean %>%
  group_by(invoice_no, date, is_weekend, cancelled) %>%
  summarise(aov = sum(invoice_amount, na.rm=TRUE), .groups="drop")

today <- max(data_clean$date, na.rm=TRUE) + 1
rfm <- data_clean %>%
  group_by(customer_id) %>%
  summarise(
    recency_days = as.numeric(today - max(date)),
    frequency = n_distinct(invoice_no),
    monetary = sum(invoice_amount, na.rm=TRUE),
    .groups="drop"
  )

# AOV distribution
p1 <- ggplot(invoice_summary, aes(x=aov)) + 
  geom_histogram(bins=60) + 
  scale_x_log10() + 
  labs(title="AOV Distribution (Log Scale)")
ggsave("/Users/divyanshchawlaa/Documents/Gisma/Datasets/Ecommerce_project/figures/aov_hist.png", plot=p1, width=7, height=5)

# Weekend vs Weekday AOV
p2 <- ggplot(invoice_summary, aes(x=is_weekend, y=aov)) +
  geom_boxplot() +
  scale_y_continuous(trans='log10') +
  labs(title="AOV: Weekend vs Weekday")
ggsave("/Users/divyanshchawlaa/Documents/Gisma/Datasets/Ecommerce_project/figures/aov_weekend_box.png", plot=p2, width=7, height=5)

# Top 10 countries by cancellations
top_cancel <- data_clean %>% filter(cancelled) %>%
  count(country, sort=TRUE) %>% top_n(10)

p3 <- ggplot(top_cancel, aes(x=reorder(country,n), y=n)) +
  geom_col() + coord_flip() +
  labs(title="Top 10 Countries by Cancellations")
ggsave("/Users/divyanshchawlaa/Documents/Gisma/Datasets/Ecommerce_project/figures/top10_countries_cancel.png", plot=p3, width=7, height=5)

