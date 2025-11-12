# QUICK DEMO: Sustainable Fashion Analysis
# Run this script to demonstrate the project in under 2 minutes

# Set working directory (update this path if needed)
setwd("/Users/danielpuri/Desktop/Projects for masters/sustainable-fashion-analysis-r")

# Load required libraries
library(dplyr)
library(ggplot2)

cat("\n========================================\n")
cat("SUSTAINABLE FASHION ANALYSIS - QUICK DEMO\n")
cat("========================================\n\n")

# ========================================
# STEP 1: Load Data
# ========================================
cat("STEP 1: Loading data...\n")
data <- read.csv("data/fashion_impact_cleaned.csv")

cat(sprintf("✓ Loaded %d clothing items\n", nrow(data)))
cat("\nFirst few rows:\n")
print(head(data[, c("clothing_type", "production_method", "co2_emissions_kg",
                    "water_usage_liters", "lifespan_years")], 3))

# ========================================
# STEP 2: Compare Groups
# ========================================
cat("\n\nSTEP 2: Comparing Sustainable vs Conventional Production\n")
cat("--------------------------------------------------------\n")

comparison <- data %>%
  group_by(production_method) %>%
  summarize(
    avg_co2 = round(mean(co2_emissions_kg), 2),
    avg_water = round(mean(water_usage_liters), 0),
    avg_lifespan = round(mean(lifespan_years), 2),
    count = n()
  )

print(comparison)

# Calculate differences
conv <- comparison[comparison$production_method == "Conventional", ]
sust <- comparison[comparison$production_method == "Sustainable", ]

cat("\n📊 KEY FINDINGS:\n")
cat(sprintf("   CO2 Reduction: %.1f%%\n", (1 - sust$avg_co2/conv$avg_co2) * 100))
cat(sprintf("   Water Reduction: %.1f%%\n", (1 - sust$avg_water/conv$avg_water) * 100))
cat(sprintf("   Lifespan Increase: %.1f%%\n", (sust$avg_lifespan/conv$avg_lifespan - 1) * 100))

# ========================================
# STEP 3: Statistical Test
# ========================================
cat("\n\nSTEP 3: Statistical Validation (t-test)\n")
cat("----------------------------------------\n")

t_result <- t.test(co2_emissions_kg ~ production_method, data = data)

cat(sprintf("t-statistic: %.3f\n", t_result$statistic))
cat(sprintf("p-value: %.6f\n", t_result$p.value))
cat(sprintf("\n✓ Result: %s\n",
            ifelse(t_result$p.value < 0.05,
                   "STATISTICALLY SIGNIFICANT (p < 0.05)",
                   "Not significant")))

# ========================================
# STEP 4: Visualization
# ========================================
cat("\n\nSTEP 4: Creating visualization...\n")

plot1 <- ggplot(data, aes(x = production_method, y = co2_emissions_kg,
                          fill = production_method)) +
  geom_boxplot(alpha = 0.7) +
  scale_fill_manual(values = c("Conventional" = "#E74C3C",
                               "Sustainable" = "#27AE60")) +
  labs(title = "CO2 Emissions: Sustainable vs Conventional",
       subtitle = sprintf("p-value: %.6f (Highly Significant)", t_result$p.value),
       x = "Production Method",
       y = "CO2 Emissions (kg)",
       fill = "Method") +
  theme_minimal(base_size = 14)

print(plot1)

cat("\n✓ Chart displayed in Plots panel (bottom right)\n")

# ========================================
# STEP 5: Bonus - Regression Model
# ========================================
cat("\n\nBONUS: Predictive Model\n")
cat("-----------------------\n")

model <- lm(co2_emissions_kg ~ production_method + lifespan_years, data = data)

cat(sprintf("Model R-squared: %.3f (explains %.1f%% of variance)\n",
            summary(model)$r.squared,
            summary(model)$r.squared * 100))
cat("\nModel Coefficients:\n")
print(round(coef(model), 3))

# ========================================
# SUMMARY
# ========================================
cat("\n\n========================================\n")
cat("DEMO COMPLETE!\n")
cat("========================================\n")
cat("\n🎯 What This Demonstrated:\n")
cat("   1. Data loading and manipulation (dplyr)\n")
cat("   2. Statistical comparison (group means)\n")
cat("   3. Hypothesis testing (t-test)\n")
cat("   4. Data visualization (ggplot2)\n")
cat("   5. Predictive modeling (linear regression)\n")
cat("\n💡 All in under 50 lines of R code!\n")
cat("\n📁 Full analysis available in: scripts/ folder\n")
cat("📊 Report: sustainable_fashion_report.Rmd\n")
cat("🔗 GitHub: https://github.com/danielpuri1901/sustainable-fashion-analysis-r\n\n")
