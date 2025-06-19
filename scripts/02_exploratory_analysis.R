library(tidyverse)
library(ggthemes)
library(corrgram)

# Loading the data
sales_clean <- read.csv("data/product_sales_clean.csv")
summary(sales_clean)
str(sales_clean)
nrow(sales_clean)

plots_dir <- "output/plots"

#EDA
## Week
summary(sales_clean$week)

### Sales per week plot
ggplot(sales_clean, aes(x = factor(week))) +
  geom_bar(fill = "steelblue") +
  labs(title = "Number of Sales Per Week", x = "Week Since Launch", y = "Count") +
  theme_minimal() 

## sales_method
table(sales_clean$sales_method)

### Sales method distribution
ggplot(sales_clean, aes(x = sales_method)) +
  geom_bar(fill = "steelblue") +
  labs(title = "Distribution of Sales Methods", x = "Sales Method", y = "Count") +
  theme_minimal()

## customer_id
length(sales_clean$customer_id)

## nb_sold
summary(sales_clean$nb_sold)

### Quantity sold plot
ggplot(sales_clean, aes(x = nb_sold)) +
  geom_histogram(binwidth = 1, fill = "steelblue", color = "black") +
  labs(title = "Distribution of Number of Products Sold", x = "Products Sold", y = "Frequency") +
  theme_minimal()

## revenue
summary(sales_clean$revenue)

### Revenue distribution plot
ggplot(sales_clean, aes(x = revenue)) +
  geom_histogram(binwidth = 10, fill = "steelblue", color = "black") +
  labs(title = "Distribution of Revenue", x = "Revenue ($)", y = "Frequency") +
  theme_minimal()

## years_as_customer 
summary(sales_clean$years_as_customer)

### Customer Retention plot
ggplot(sales_clean, aes(x = years_as_customer)) +
  geom_histogram(binwidth = 1, fill = "steelblue", color = "black") +
  labs(title = "Years as Customer", x = "Years", y = "Frequency") +
  theme_minimal()

## nb_site_visits
summary(sales_clean$nb_site_visits)

### Site visits (last 6 months) distribution plot 
ggplot(sales_clean, aes(x = nb_site_visits)) +
  geom_histogram(binwidth = 1, fill = "steelblue", color = "black") +
  labs(title = "Site Visits in Last 6 Months", x = "Visits", y = "Frequency") +
  theme_minimal()

## state
summary(sales_clean$state)

### Top 10 states by customer count plot
sales_clean %>%
  count(state, sort = TRUE) %>%
  top_n(10) %>%
  ggplot(aes(x = reorder(state, n), y = n)) +
  geom_col(fill = "steelblue") +
  coord_flip() +
  labs(title = "Top 10 States by Customer Count", x = "State", y = "Count") +
  theme_minimal()

## Correlation
corrgram(sales_clean)
cor(sales_clean %>% select(-state, -sales_method, -customer_id))

## Revenue by sales method
ggplot(sales_clean, aes(x = sales_method, y = revenue, fill = sales_method)) +
  geom_boxplot() +
  labs(title = "Revenue Spread by Sales Method", x = "Sales Method", y = "Revenue ($)") +
  theme_minimal() +
  theme(legend.position = "none")

ggplot(sales_clean, aes(x = revenue)) + 
  geom_histogram(binwidth = 10, fill = "steelblue") + 
  labs(title = 'Revenue Distribution Across Sales Method', x = 'Revenue', y= 'Frequency') +
  facet_wrap(~sales_method) +
  theme_minimal()

## Revenue across weeks
ggplot(sales_clean, aes(x = week, y = revenue)) +
  stat_summary(fun = mean, geom = "line", linewidth = 1) +
  labs(title = "Average Revenue Over Time", x = "Week", y = "Average Revenue ($)") +
  theme_minimal()

## Revenue across weeks by sales method
ggplot(sales_clean, aes(x = week, y = revenue, color = sales_method)) +
  stat_summary(fun = mean, geom = "line", linewidth = 1) +
  labs(title = "Average Revenue Over Time by Sales Method", x = "Week", y = "Average Revenue ($)", color ='Sales Method') +
  theme_minimal()

## Products sold by sales method
ggplot(sales_clean, aes(x = sales_method, y = nb_sold, fill = sales_method)) +
  geom_boxplot() +
  labs(title = "Products Sold by Sales Method", x = "Sales Method", y = "Products Sold") +
  theme_minimal() +
  theme(legend.position = "none")

## Products sold vs revenue
ggplot(sales_clean, aes(x = nb_sold, y = revenue)) +
  geom_point(alpha = 0.3) +
  geom_smooth(method = "lm") +
  labs(title = "Relationship Between Products Sold and Revenue", x = "Number of Products Sold", y = "Revenue ($)") +
  theme_minimal()

## Sales Method Comparison Stats
summary_table <- sales_clean %>%
  group_by(sales_method) %>%
  summarise(
    customers = n(),
    avg_revenue = mean(revenue),
    sd_revenue = sd(revenue),
    avg_nb_sold = mean(nb_sold),
    avg_nb_sold = mean(nb_site_visits),
    .groups = "drop"
  )
write_csv(summary_table, "output/tables/overall_summary_stats.csv")

## Weekly Comparison
weekly_table <- sales_clean %>% group_by(week, sales_method) %>% 
  summarise(avg_rev = mean(revenue), .groups="drop")

write_csv(weekly_table, "output/tables/weekly_revenue_summary.csv")
