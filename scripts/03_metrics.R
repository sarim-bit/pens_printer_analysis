library(tidyverse)

# Loading the data
sales_clean <- read.csv("data/product_sales_clean.csv")
summary(sales_clean)
str(sales_clean)
nrow(sales_clean)

sales_metrics <- sales_clean

# Revenue per unit
sales_metrics <- sales_metrics %>%
  mutate(revenue_per_unit = revenue / nb_sold)

# Revenue per minute
sales_metrics <- sales_metrics %>%
  mutate(estimated_minutes = case_when(
    sales_method == "Email" ~ 1,
    sales_method == "Call" ~ 30,
    sales_method == "Email + Call" ~ 11
  ),
  revenue_per_minute = revenue / estimated_minutes)

# Summary
metric_summary <- sales_metrics %>%
  group_by(sales_method) %>%
  summarise(
    customers = n(),
    avg_revenue = mean(revenue),
    avg_nb_sold = mean(nb_sold),
    avg_revenue_per_unit = mean(revenue_per_unit),
    avg_revenue_per_min = mean(revenue_per_minute, na.rm = TRUE),
    avg_effort_min = mean(estimated_minutes),
    .groups = "drop"
  )

print(metric_summary)
write_csv(metric_summary, "output/tables/metric_summary_by_method.csv")

# Revenue per Unit by Sales Method Plot
ggplot(sales_metrics, aes(x = sales_method, y = revenue_per_unit, fill = sales_method)) +
  geom_boxplot() +
  labs(title = "Revenue per Unit by Sales Method", x = "Sales Method", y = "Revenue per Unit ($)") +
  theme_minimal() +
  theme(legend.position = "none")

# Revenue per Minute by Sales method 
ggplot(sales_clean %>% filter(!is.na(revenue_per_minute)), 
       aes(x = sales_method, y = revenue_per_minute, fill = sales_method)) +
  geom_boxplot() +
  labs(title = "Revenue per Minute of Sales Effort", x = "Sales Method", y = "Revenue per Minute ($/min)") +
  theme_minimal() +
  theme(legend.position = "none")



