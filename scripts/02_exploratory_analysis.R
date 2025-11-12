# Exploratory Data Analysis for Sustainable Fashion Impact
# This script performs comprehensive EDA on the cleaned dataset

# Load required libraries
library(dplyr)
library(ggplot2)
library(tidyr)
library(readr)
library(scales)

# Load cleaned data
cat("Loading cleaned data...\n")
fashion_data <- read_csv("data/fashion_impact_cleaned.csv")

# Convert to factors
fashion_data <- fashion_data %>%
  mutate(
    clothing_type = as.factor(clothing_type),
    material = as.factor(material),
    production_method = as.factor(production_method),
    sustainability_category = factor(sustainability_category,
                                    levels = c("Low Impact", "Medium Impact", "High Impact"))
  )

cat(sprintf("Loaded %d observations\n\n", nrow(fashion_data)))

# ========================================
# 1. UNIVARIATE ANALYSIS
# ========================================

cat("=== UNIVARIATE ANALYSIS ===\n\n")

# Descriptive statistics for continuous variables
continuous_vars <- c("co2_emissions_kg", "water_usage_liters",
                    "lifespan_years", "price_usd", "recycled_content_pct")

cat("Descriptive Statistics:\n")
desc_stats <- fashion_data %>%
  select(all_of(continuous_vars)) %>%
  summarise(across(everything(), list(
    mean = ~mean(.x, na.rm = TRUE),
    median = ~median(.x, na.rm = TRUE),
    sd = ~sd(.x, na.rm = TRUE),
    min = ~min(.x, na.rm = TRUE),
    max = ~max(.x, na.rm = TRUE)
  ))) %>%
  pivot_longer(everything(),
               names_to = c("variable", "statistic"),
               names_pattern = "(.+)_(.+)") %>%
  pivot_wider(names_from = statistic, values_from = value)

print(desc_stats)

# Frequency distributions for categorical variables
cat("\n\nCategorical Variable Distributions:\n\n")

cat("Production Method:\n")
prod_table <- table(fashion_data$production_method)
print(prop.table(prod_table))

cat("\nClothing Type:\n")
clothing_table <- table(fashion_data$clothing_type)
print(sort(clothing_table, decreasing = TRUE))

cat("\nMaterial:\n")
material_table <- table(fashion_data$material)
print(sort(material_table, decreasing = TRUE))

cat("\nSustainability Category:\n")
sust_table <- table(fashion_data$sustainability_category)
print(prop.table(sust_table))

# ========================================
# 2. BIVARIATE ANALYSIS
# ========================================

cat("\n\n=== BIVARIATE ANALYSIS ===\n\n")

# CO2 emissions by production method
cat("CO2 Emissions by Production Method:\n")
co2_by_prod <- fashion_data %>%
  group_by(production_method) %>%
  summarise(
    mean_co2 = mean(co2_emissions_kg),
    median_co2 = median(co2_emissions_kg),
    sd_co2 = sd(co2_emissions_kg),
    n = n()
  )
print(co2_by_prod)

# Water usage by production method
cat("\nWater Usage by Production Method:\n")
water_by_prod <- fashion_data %>%
  group_by(production_method) %>%
  summarise(
    mean_water = mean(water_usage_liters),
    median_water = median(water_usage_liters),
    sd_water = sd(water_usage_liters),
    n = n()
  )
print(water_by_prod)

# Lifespan by production method
cat("\nLifespan by Production Method:\n")
lifespan_by_prod <- fashion_data %>%
  group_by(production_method) %>%
  summarise(
    mean_lifespan = mean(lifespan_years),
    median_lifespan = median(lifespan_years),
    sd_lifespan = sd(lifespan_years),
    n = n()
  )
print(lifespan_by_prod)

# Environmental impact by clothing type
cat("\n\nEnvironmental Impact by Clothing Type:\n")
impact_by_type <- fashion_data %>%
  group_by(clothing_type) %>%
  summarise(
    mean_co2 = mean(co2_emissions_kg),
    mean_water = mean(water_usage_liters),
    mean_lifespan = mean(lifespan_years),
    mean_impact_score = mean(env_impact_score),
    n = n()
  ) %>%
  arrange(desc(mean_impact_score))
print(impact_by_type)

# ========================================
# 3. CORRELATION ANALYSIS
# ========================================

cat("\n\n=== CORRELATION ANALYSIS ===\n\n")

# Calculate correlation matrix for numeric variables
numeric_vars <- fashion_data %>%
  select(co2_emissions_kg, water_usage_liters, lifespan_years,
         price_usd, recycled_content_pct, washes_before_disposal)

cor_matrix <- cor(numeric_vars, use = "complete.obs")
cat("Correlation Matrix:\n")
print(round(cor_matrix, 3))

# Key correlations
cat("\n\nKey Insights from Correlations:\n")
cat(sprintf("- CO2 and Water: %.3f (strong positive)\n",
            cor_matrix["co2_emissions_kg", "water_usage_liters"]))
cat(sprintf("- Lifespan and CO2: %.3f\n",
            cor_matrix["lifespan_years", "co2_emissions_kg"]))
cat(sprintf("- Lifespan and Water: %.3f\n",
            cor_matrix["lifespan_years", "water_usage_liters"]))
cat(sprintf("- Price and Lifespan: %.3f\n",
            cor_matrix["price_usd", "lifespan_years"]))

# ========================================
# 4. GROUP COMPARISONS
# ========================================

cat("\n\n=== GROUP COMPARISONS ===\n\n")

# Sustainable vs Conventional comparison
cat("Sustainable vs Conventional Production:\n")
comparison <- fashion_data %>%
  group_by(production_method) %>%
  summarise(
    avg_co2 = mean(co2_emissions_kg),
    avg_water = mean(water_usage_liters),
    avg_lifespan = mean(lifespan_years),
    avg_price = mean(price_usd),
    avg_recycled_content = mean(recycled_content_pct)
  )
print(comparison)

# Calculate percentage differences
conventional <- comparison %>% filter(production_method == "Conventional")
sustainable <- comparison %>% filter(production_method == "Sustainable")

cat("\n\nPercentage Differences (Sustainable vs Conventional):\n")
cat(sprintf("CO2 Reduction: %.1f%%\n",
            (1 - sustainable$avg_co2/conventional$avg_co2) * 100))
cat(sprintf("Water Reduction: %.1f%%\n",
            (1 - sustainable$avg_water/conventional$avg_water) * 100))
cat(sprintf("Lifespan Increase: %.1f%%\n",
            (sustainable$avg_lifespan/conventional$avg_lifespan - 1) * 100))

# ========================================
# 5. SUSTAINABILITY ANALYSIS
# ========================================

cat("\n\n=== SUSTAINABILITY ANALYSIS ===\n\n")

# Items with best and worst environmental impact
cat("Top 5 Most Sustainable Items (by impact score):\n")
top_sustainable <- fashion_data %>%
  arrange(env_impact_score) %>%
  select(item_id, clothing_type, material, production_method,
         co2_emissions_kg, water_usage_liters, lifespan_years,
         env_impact_score) %>%
  head(5)
print(top_sustainable)

cat("\n\nTop 5 Least Sustainable Items (by impact score):\n")
least_sustainable <- fashion_data %>%
  arrange(desc(env_impact_score)) %>%
  select(item_id, clothing_type, material, production_method,
         co2_emissions_kg, water_usage_liters, lifespan_years,
         env_impact_score) %>%
  head(5)
print(least_sustainable)

# Material sustainability analysis
cat("\n\nEnvironmental Impact by Material:\n")
material_impact <- fashion_data %>%
  group_by(material) %>%
  summarise(
    avg_co2 = mean(co2_emissions_kg),
    avg_water = mean(water_usage_liters),
    avg_lifespan = mean(lifespan_years),
    avg_impact_score = mean(env_impact_score),
    n = n()
  ) %>%
  arrange(avg_impact_score)
print(material_impact)

# ========================================
# 6. SAVE RESULTS
# ========================================

# Save EDA results
sink("output/eda_summary.txt")
cat("=== SUSTAINABLE FASHION EXPLORATORY DATA ANALYSIS ===\n\n")
cat(sprintf("Analysis Date: %s\n\n", Sys.Date()))
cat(sprintf("Total Observations: %d\n\n", nrow(fashion_data)))

cat("KEY FINDINGS:\n\n")
cat("1. Production Method Comparison:\n")
cat(sprintf("   - Sustainable production reduces CO2 by %.1f%%\n",
            (1 - sustainable$avg_co2/conventional$avg_co2) * 100))
cat(sprintf("   - Sustainable production reduces water usage by %.1f%%\n",
            (1 - sustainable$avg_water/conventional$avg_water) * 100))
cat(sprintf("   - Sustainable items last %.1f%% longer\n",
            (sustainable$avg_lifespan/conventional$avg_lifespan - 1) * 100))

cat("\n2. Most Impactful Clothing Types:\n")
print(head(impact_by_type, 3))

cat("\n3. Material Analysis:\n")
print(head(material_impact, 3))

cat("\n4. Correlation Insights:\n")
cat(sprintf("   - CO2 and Water are highly correlated (r = %.3f)\n",
            cor_matrix["co2_emissions_kg", "water_usage_liters"]))
cat(sprintf("   - Longer lifespan correlates with higher initial CO2 (r = %.3f)\n",
            cor_matrix["lifespan_years", "co2_emissions_kg"]))

sink()

cat("\n✓ EDA completed! Results saved to output/eda_summary.txt\n")
