library(tidyverse)

# Loading the data
sales_raw <- read.csv("data/product_sales.csv")
summary(sales_raw)
str(sales_raw)
nrow(sales_raw)

# Data Cleaning 
sales_clean <- sales_raw

## Week
table(sales_clean$week) # No issues
summary(sales_clean$week) 

## Sales Method
table(sales_clean$sales_method)
sales_clean$sales_method[sales_clean$sales_method == 'em + call'] <- 'Email + Call'
sales_clean$sales_method[sales_clean$sales_method == 'email'] <- 'Email'
sales_clean$sales_method <- factor(sales_clean$sales_method,
                                      levels = c("Email", "Call", "Email + Call"))

## State
table(sales_clean$state) # No issues
sales_clean$state <- as.factor(sales_clean$state)
summary(sales_clean$state)

## Years as Customer
sales_clean %>% filter(years_as_customer > 41) %>% arrange(by = years_as_customer) # Filtering rows that have year_as_customer greater than 41, considering it is 2025
sales_clean <- sales_clean %>% filter(years_as_customer <= 41) %>% arrange(by = years_as_customer) # Removing the two rows
nrow(sales_clean)

## Customer ID
any(duplicated(sales_clean$customer_id)) # Checking duplicate values, no issues
any(is.na(sales_clean$customer_id)) # Checking NA values, no issues

## New products sold
table(sales_clean$nb_sold)
summary(sales_clean$nb_sold) # No issues

## Site visits in last 6 months
summary(sales_clean$nb_site_visits) # No issues

## Revenue
summary(sales_clean$revenue) #1074 missing values

sales_clean %>% filter(is.na(revenue)) %>% count(sales_method)
sales_clean %>% filter(is.na(revenue)) %>% count(state)

sales_clean %>%
  filter(is.na(revenue)) %>%
  summarise(
    min_nb_sold = min(nb_sold),
    max_nb_sold = max(nb_sold),
    avg_years_as_customer = mean(years_as_customer),
    avg_site_visits = mean(nb_site_visits)
  )

### There is no apparent bias in missing values of revenue, and <8% values are missing so removing the rows.
sales_clean <- sales_clean %>% filter(!is.na(revenue))

summary(sales_clean)
nrow(sales_clean)
str(sales_clean)

# Saving Clean Data
write_csv(sales_clean, "data/product_sales_clean.csv")
