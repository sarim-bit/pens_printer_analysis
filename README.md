# Sales Strategy Efficiency Analysis

This project evaluates the performance of three sales outreach methods — Email, Call, and Email + Call — using sales data from a new product launch.

## Objectives

- Explore sales outcomes across methods
- Define and compute a business-relevant efficiency metric
- Recommend which method to scale based on data-driven insights

## Key Metric

**Revenue per Minute of Sales Effort**  
A composite metric that considers both revenue and team time investment.

## Key Findings

- **Email** is the most efficient method ($97.10/min), with strong revenue and zero team time.
- **Email + Call** yields the highest total revenue per customer, but with moderate effort.
- **Call-only** is the least efficient strategy.

## Project Structure

- `scripts/`: Data cleaning, EDA, and metric analysis
- `data/`: Input + cleaned CSVs
- `outputs/plots/`: All ggplot2 visualizations
- `Sales-Method-Review.pdf`:  Summary in RMarkdown

## Tools

- Language: R
- Libraries: `tidyverse`, `ggplot2`, `dplyr`, `readr`, `ggthemes`

## Getting Started

```r
# Clone the repo
# Run scripts in order
source("scripts/01_data_preprocessing.R")
source("scripts/02_exploratory_analysis.R")
source("scripts/03_metrics.R")
```