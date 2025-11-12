# Hypothesis Testing for Sustainable Fashion Impact Analysis
# This script performs statistical hypothesis tests

# Load required libraries
library(dplyr)
library(readr)
library(broom)
library(car)  # For Levene's test

# Load cleaned data
cat("Loading cleaned data...\n")
fashion_data <- read_csv("data/fashion_impact_cleaned.csv")

# Convert to factors
fashion_data <- fashion_data %>%
  mutate(
    clothing_type = as.factor(clothing_type),
    material = as.factor(material),
    production_method = as.factor(production_method)
  )

cat(sprintf("Loaded %d observations\n\n", nrow(fashion_data)))

# ========================================
# HYPOTHESIS 1: Production Method Impact
# ========================================

cat("========================================\n")
cat("HYPOTHESIS 1: Production Method Impact on Environmental Metrics\n")
cat("========================================\n\n")

# H1a: Does production method significantly affect CO2 emissions?
cat("H1a: Sustainable vs Conventional Production - CO2 Emissions\n")
cat("H0: No difference in mean CO2 emissions between production methods\n")
cat("Ha: Sustainable production has lower CO2 emissions\n\n")

# Check assumptions
cat("Checking assumptions:\n")

# Normality test (Shapiro-Wilk)
by_prod_co2 <- split(fashion_data$co2_emissions_kg, fashion_data$production_method)
shapiro_conv <- shapiro.test(by_prod_co2$Conventional)
shapiro_sust <- shapiro.test(by_prod_co2$Sustainable)
cat(sprintf("Shapiro-Wilk (Conventional): p = %.4f\n", shapiro_conv$p.value))
cat(sprintf("Shapiro-Wilk (Sustainable): p = %.4f\n", shapiro_sust$p.value))

# Variance equality test (Levene's test would go here, using var.test as alternative)
var_test_co2 <- var.test(co2_emissions_kg ~ production_method, data = fashion_data)
cat(sprintf("F-test for equal variances: p = %.4f\n\n", var_test_co2$p.value))

# Perform two-sample t-test (one-tailed)
t_test_co2 <- t.test(co2_emissions_kg ~ production_method,
                     data = fashion_data,
                     alternative = "less",  # Conventional < Sustainable (reversed order)
                     var.equal = (var_test_co2$p.value > 0.05))

cat("T-test Results:\n")
print(t_test_co2)

# Effect size (Cohen's d)
mean_conv <- mean(by_prod_co2$Conventional)
mean_sust <- mean(by_prod_co2$Sustainable)
sd_pooled <- sqrt(((length(by_prod_co2$Conventional)-1)*var(by_prod_co2$Conventional) +
                   (length(by_prod_co2$Sustainable)-1)*var(by_prod_co2$Sustainable)) /
                  (length(by_prod_co2$Conventional) + length(by_prod_co2$Sustainable) - 2))
cohens_d_co2 <- (mean_conv - mean_sust) / sd_pooled
cat(sprintf("\nCohen's d effect size: %.3f\n", cohens_d_co2))
cat(sprintf("Interpretation: %s\n",
            ifelse(abs(cohens_d_co2) < 0.2, "Small",
                   ifelse(abs(cohens_d_co2) < 0.5, "Medium", "Large"))))

# H1b: Does production method significantly affect water usage?
cat("\n\n")
cat("H1b: Sustainable vs Conventional Production - Water Usage\n")
cat("H0: No difference in mean water usage between production methods\n")
cat("Ha: Sustainable production has lower water usage\n\n")

t_test_water <- t.test(water_usage_liters ~ production_method,
                       data = fashion_data,
                       alternative = "less")

cat("T-test Results:\n")
print(t_test_water)

by_prod_water <- split(fashion_data$water_usage_liters, fashion_data$production_method)
mean_conv_w <- mean(by_prod_water$Conventional)
mean_sust_w <- mean(by_prod_water$Sustainable)
sd_pooled_w <- sqrt(((length(by_prod_water$Conventional)-1)*var(by_prod_water$Conventional) +
                     (length(by_prod_water$Sustainable)-1)*var(by_prod_water$Sustainable)) /
                    (length(by_prod_water$Conventional) + length(by_prod_water$Sustainable) - 2))
cohens_d_water <- (mean_conv_w - mean_sust_w) / sd_pooled_w
cat(sprintf("\nCohen's d effect size: %.3f\n", cohens_d_water))

# H1c: Does production method significantly affect lifespan?
cat("\n\n")
cat("H1c: Sustainable vs Conventional Production - Lifespan\n")
cat("H0: No difference in mean lifespan between production methods\n")
cat("Ha: Sustainable production has longer lifespan\n\n")

t_test_lifespan <- t.test(lifespan_years ~ production_method,
                          data = fashion_data,
                          alternative = "greater")

cat("T-test Results:\n")
print(t_test_lifespan)

# ========================================
# HYPOTHESIS 2: Clothing Type Impact (ANOVA)
# ========================================

cat("\n\n========================================\n")
cat("HYPOTHESIS 2: Clothing Type Impact on CO2 Emissions\n")
cat("========================================\n\n")
cat("H0: All clothing types have the same mean CO2 emissions\n")
cat("Ha: At least one clothing type has different mean CO2 emissions\n\n")

# Check ANOVA assumptions
cat("Checking ANOVA assumptions:\n")

# Normality of residuals
anova_model_co2 <- aov(co2_emissions_kg ~ clothing_type, data = fashion_data)
residuals_co2 <- residuals(anova_model_co2)
shapiro_resid <- shapiro.test(sample(residuals_co2, min(5000, length(residuals_co2))))
cat(sprintf("Shapiro-Wilk test on residuals: p = %.4f\n", shapiro_resid$p.value))

# Homogeneity of variances (Levene's test - using Fligner-Killeen as alternative)
fligner_test <- fligner.test(co2_emissions_kg ~ clothing_type, data = fashion_data)
cat(sprintf("Fligner-Killeen test for homogeneity: p = %.4f\n\n", fligner_test$p.value))

# Perform one-way ANOVA
cat("ANOVA Results:\n")
anova_results <- summary(anova_model_co2)
print(anova_results)

# Effect size (Eta-squared)
ss_treatment <- anova_results[[1]]["clothing_type", "Sum Sq"]
ss_total <- sum(anova_results[[1]][, "Sum Sq"])
eta_squared <- ss_treatment / ss_total
cat(sprintf("\nEta-squared: %.3f\n", eta_squared))
cat(sprintf("Interpretation: %.1f%% of variance explained by clothing type\n",
            eta_squared * 100))

# Post-hoc test (Tukey HSD)
if (anova_results[[1]]["clothing_type", "Pr(>F)"] < 0.05) {
  cat("\n\nPost-hoc Tukey HSD Test (showing significant differences):\n")
  tukey_results <- TukeyHSD(anova_model_co2)
  significant_pairs <- tukey_results$clothing_type[tukey_results$clothing_type[, "p adj"] < 0.05, ]
  print(head(significant_pairs, 10))
}

# ========================================
# HYPOTHESIS 3: Material Type Impact (ANOVA)
# ========================================

cat("\n\n========================================\n")
cat("HYPOTHESIS 3: Material Type Impact on Water Usage\n")
cat("========================================\n\n")
cat("H0: All material types have the same mean water usage\n")
cat("Ha: At least one material type has different mean water usage\n\n")

# Perform one-way ANOVA
anova_model_water <- aov(water_usage_liters ~ material, data = fashion_data)
cat("ANOVA Results:\n")
anova_results_water <- summary(anova_model_water)
print(anova_results_water)

# Effect size
ss_treatment_w <- anova_results_water[[1]]["material", "Sum Sq"]
ss_total_w <- sum(anova_results_water[[1]][, "Sum Sq"])
eta_squared_w <- ss_treatment_w / ss_total_w
cat(sprintf("\nEta-squared: %.3f\n", eta_squared_w))

# Post-hoc test
if (anova_results_water[[1]]["material", "Pr(>F)"] < 0.05) {
  cat("\n\nPost-hoc Tukey HSD Test (showing top significant differences):\n")
  tukey_results_water <- TukeyHSD(anova_model_water)
  significant_pairs_w <- tukey_results_water$material[tukey_results_water$material[, "p adj"] < 0.05, ]
  print(head(significant_pairs_w, 10))
}

# ========================================
# HYPOTHESIS 4: Two-way ANOVA
# ========================================

cat("\n\n========================================\n")
cat("HYPOTHESIS 4: Interaction Effect - Clothing Type & Production Method\n")
cat("========================================\n\n")
cat("H0: No interaction effect between clothing type and production method on CO2\n")
cat("Ha: There is a significant interaction effect\n\n")

# Two-way ANOVA
anova_model_2way <- aov(co2_emissions_kg ~ clothing_type * production_method,
                        data = fashion_data)
cat("Two-way ANOVA Results:\n")
anova_results_2way <- summary(anova_model_2way)
print(anova_results_2way)

# ========================================
# HYPOTHESIS 5: Material Sustainability Impact
# ========================================

cat("\n\n========================================\n")
cat("HYPOTHESIS 5: Sustainable Materials Impact\n")
cat("========================================\n\n")

# Add material sustainability flag if not present
if (!"material_sustainable" %in% names(fashion_data)) {
  fashion_data <- fashion_data %>%
    mutate(material_sustainable = material %in% c("Organic Cotton", "Recycled Cotton",
                                                   "Hemp", "Linen"))
}

cat("H5a: Sustainable materials vs Others - Environmental Impact Score\n")
cat("H0: No difference in environmental impact score\n")
cat("Ha: Sustainable materials have lower impact scores\n\n")

t_test_material <- t.test(env_impact_score ~ material_sustainable,
                          data = fashion_data,
                          alternative = "greater")  # non-sustainable > sustainable

cat("T-test Results:\n")
print(t_test_material)

# ========================================
# SAVE RESULTS
# ========================================

# Save all hypothesis testing results
sink("output/hypothesis_testing_results.txt")
cat("=== SUSTAINABLE FASHION HYPOTHESIS TESTING RESULTS ===\n\n")
cat(sprintf("Analysis Date: %s\n\n", Sys.Date()))

cat("SUMMARY OF KEY FINDINGS:\n\n")

cat("1. PRODUCTION METHOD IMPACT:\n")
cat(sprintf("   CO2 Emissions: t = %.3f, p = %.4f %s\n",
            t_test_co2$statistic, t_test_co2$p.value,
            ifelse(t_test_co2$p.value < 0.05, "***", "")))
cat(sprintf("   Effect size (Cohen's d): %.3f\n", cohens_d_co2))
cat(sprintf("   Water Usage: t = %.3f, p = %.4f %s\n",
            t_test_water$statistic, t_test_water$p.value,
            ifelse(t_test_water$p.value < 0.05, "***", "")))
cat(sprintf("   Effect size (Cohen's d): %.3f\n", cohens_d_water))
cat(sprintf("   Lifespan: t = %.3f, p = %.4f %s\n",
            t_test_lifespan$statistic, t_test_lifespan$p.value,
            ifelse(t_test_lifespan$p.value < 0.05, "***", "")))

cat("\n2. CLOTHING TYPE IMPACT (ANOVA):\n")
cat(sprintf("   F = %.3f, p = %.4f %s\n",
            anova_results[[1]]["clothing_type", "F value"],
            anova_results[[1]]["clothing_type", "Pr(>F)"],
            ifelse(anova_results[[1]]["clothing_type", "Pr(>F)"] < 0.05, "***", "")))
cat(sprintf("   Eta-squared: %.3f (%.1f%% variance explained)\n",
            eta_squared, eta_squared * 100))

cat("\n3. MATERIAL TYPE IMPACT (ANOVA):\n")
cat(sprintf("   F = %.3f, p = %.4f %s\n",
            anova_results_water[[1]]["material", "F value"],
            anova_results_water[[1]]["material", "Pr(>F)"],
            ifelse(anova_results_water[[1]]["material", "Pr(>F)"] < 0.05, "***", "")))
cat(sprintf("   Eta-squared: %.3f\n", eta_squared_w))

cat("\n4. INTERACTION EFFECT:\n")
cat(sprintf("   F = %.3f, p = %.4f %s\n",
            anova_results_2way[[1]]["clothing_type:production_method", "F value"],
            anova_results_2way[[1]]["clothing_type:production_method", "Pr(>F)"],
            ifelse(anova_results_2way[[1]]["clothing_type:production_method", "Pr(>F)"] < 0.05,
                   "***", "")))

cat("\n5. SUSTAINABLE MATERIALS:\n")
cat(sprintf("   t = %.3f, p = %.4f %s\n",
            t_test_material$statistic, t_test_material$p.value,
            ifelse(t_test_material$p.value < 0.05, "***", "")))

cat("\n\nSignificance codes: *** p < 0.05\n")

sink()

cat("\n✓ Hypothesis testing completed! Results saved to output/hypothesis_testing_results.txt\n")
