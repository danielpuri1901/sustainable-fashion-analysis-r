# Data Cleaning Script for Sustainable Fashion Analysis
# This script loads and cleans the fashion impact dataset

# Load required libraries
library(dplyr)
library(tidyr)
library(readr)

# Load the dataset
cat("Loading fashion impact data...\n")
fashion_data <- read_csv("data/fashion_impact_data.csv")

cat(sprintf("Original dataset: %d rows, %d columns\n",
            nrow(fashion_data), ncol(fashion_data)))

# Display initial data summary
cat("\n=== Initial Data Summary ===\n")
print(summary(fashion_data))

cat("\n=== Missing Values ===\n")
missing_counts <- colSums(is.na(fashion_data))
print(missing_counts[missing_counts > 0])

# Data Cleaning Steps

# 1. Remove duplicates (if any)
fashion_data <- fashion_data %>%
  distinct()

# 2. Handle missing values
# For recycled content, impute with median by production method
fashion_data <- fashion_data %>%
  group_by(production_method) %>%
  mutate(recycled_content_pct = ifelse(
    is.na(recycled_content_pct),
    median(recycled_content_pct, na.rm = TRUE),
    recycled_content_pct
  )) %>%
  ungroup()

# For washes_before_disposal, impute with mean by clothing type
fashion_data <- fashion_data %>%
  group_by(clothing_type) %>%
  mutate(washes_before_disposal = ifelse(
    is.na(washes_before_disposal),
    round(mean(washes_before_disposal, na.rm = TRUE)),
    washes_before_disposal
  )) %>%
  ungroup()

# For price, impute with median by clothing type
fashion_data <- fashion_data %>%
  group_by(clothing_type) %>%
  mutate(price_usd = ifelse(
    is.na(price_usd),
    median(price_usd, na.rm = TRUE),
    price_usd
  )) %>%
  ungroup()

# 3. Create derived variables

# Calculate environmental impact score (normalized)
fashion_data <- fashion_data %>%
  mutate(
    # CO2 per year of use
    co2_per_year = co2_emissions_kg / lifespan_years,

    # Water per year of use
    water_per_year = water_usage_liters / lifespan_years,

    # Environmental efficiency score (lower is better)
    env_impact_score = (co2_per_year / max(co2_per_year) +
                       water_per_year / max(water_per_year)) / 2,

    # Cost per year
    cost_per_year = price_usd / lifespan_years,

    # Sustainability category
    sustainability_category = case_when(
      env_impact_score <= 0.3 ~ "Low Impact",
      env_impact_score <= 0.6 ~ "Medium Impact",
      TRUE ~ "High Impact"
    ),

    # Material sustainability
    material_sustainable = material %in% c("Organic Cotton", "Recycled Cotton",
                                          "Hemp", "Linen")
  )

# 4. Data type conversions and factor ordering
fashion_data <- fashion_data %>%
  mutate(
    clothing_type = as.factor(clothing_type),
    material = as.factor(material),
    production_method = as.factor(production_method),
    sustainability_category = factor(sustainability_category,
                                    levels = c("Low Impact", "Medium Impact", "High Impact")),
    material_sustainable = as.logical(material_sustainable)
  )

# 5. Remove outliers (optional - using IQR method for continuous variables)
remove_outliers <- function(x, k = 3) {
  qnt <- quantile(x, probs = c(0.25, 0.75), na.rm = TRUE)
  H <- k * IQR(x, na.rm = TRUE)
  x[x < (qnt[1] - H) | x > (qnt[2] + H)] <- NA
  x
}

# Apply outlier removal (keeping all data but flagging extreme outliers)
fashion_data <- fashion_data %>%
  mutate(
    outlier_flag = (co2_emissions_kg > quantile(co2_emissions_kg, 0.99) |
                   water_usage_liters > quantile(water_usage_liters, 0.99) |
                   lifespan_years > quantile(lifespan_years, 0.99))
  )

# Final summary after cleaning
cat("\n=== Cleaned Data Summary ===\n")
cat(sprintf("Final dataset: %d rows, %d columns\n",
            nrow(fashion_data), ncol(fashion_data)))
cat(sprintf("Missing values remaining: %d\n", sum(is.na(fashion_data))))
cat(sprintf("Outliers flagged: %d\n", sum(fashion_data$outlier_flag)))

# Display structure
cat("\n=== Data Structure ===\n")
str(fashion_data)

# Save cleaned dataset
write_csv(fashion_data, "data/fashion_impact_cleaned.csv")
cat("\nCleaned data saved to: data/fashion_impact_cleaned.csv\n")

# Save summary statistics
sink("output/cleaning_summary.txt")
cat("=== SUSTAINABLE FASHION DATA CLEANING SUMMARY ===\n\n")
cat(sprintf("Date: %s\n\n", Sys.Date()))
cat(sprintf("Original records: %d\n", nrow(fashion_data)))
cat(sprintf("Final records: %d\n", nrow(fashion_data)))
cat(sprintf("Variables: %d\n\n", ncol(fashion_data)))

cat("=== Production Method Distribution ===\n")
print(table(fashion_data$production_method))

cat("\n=== Clothing Type Distribution ===\n")
print(table(fashion_data$clothing_type))

cat("\n=== Sustainability Category Distribution ===\n")
print(table(fashion_data$sustainability_category))

cat("\n=== Key Statistics ===\n")
print(summary(fashion_data %>% select(co2_emissions_kg, water_usage_liters,
                                     lifespan_years, price_usd)))
sink()

cat("\nCleaning summary saved to: output/cleaning_summary.txt\n")
cat("\n✓ Data cleaning completed successfully!\n")
