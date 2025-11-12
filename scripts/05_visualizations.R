# Data Visualizations for Sustainable Fashion Impact Analysis
# This script creates publication-quality visualizations using ggplot2

# Load required libraries
library(dplyr)
library(ggplot2)
library(readr)
library(tidyr)
library(tibble)
library(scales)
library(gridExtra)
library(RColorBrewer)

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

# Set theme for all plots
theme_set(theme_minimal(base_size = 12))

# Custom color palettes
sustainable_colors <- c("Conventional" = "#E74C3C", "Sustainable" = "#27AE60")
impact_colors <- c("Low Impact" = "#27AE60", "Medium Impact" = "#F39C12",
                  "High Impact" = "#E74C3C")

cat("Creating visualizations...\n\n")

# ========================================
# PLOT 1: CO2 Emissions by Production Method
# ========================================

cat("1. Creating CO2 emissions comparison plot...\n")

plot1 <- ggplot(fashion_data, aes(x = production_method, y = co2_emissions_kg,
                                  fill = production_method)) +
  geom_boxplot(alpha = 0.7) +
  geom_jitter(width = 0.2, alpha = 0.2, size = 0.8) +
  scale_fill_manual(values = sustainable_colors) +
  labs(title = "CO2 Emissions: Sustainable vs Conventional Production",
       subtitle = "Distribution of carbon footprint by production method",
       x = "Production Method",
       y = "CO2 Emissions (kg)",
       fill = "Production Method") +
  theme(legend.position = "none",
        plot.title = element_text(face = "bold", size = 14),
        plot.subtitle = element_text(size = 10, color = "gray40"))

ggsave("figures/01_co2_by_production.png", plot1, width = 8, height = 6, dpi = 300)

# ========================================
# PLOT 2: Water Usage by Production Method
# ========================================

cat("2. Creating water usage comparison plot...\n")

plot2 <- ggplot(fashion_data, aes(x = production_method, y = water_usage_liters,
                                  fill = production_method)) +
  geom_violin(alpha = 0.7, trim = FALSE) +
  geom_boxplot(width = 0.2, alpha = 0.5, outlier.shape = NA) +
  scale_fill_manual(values = sustainable_colors) +
  scale_y_continuous(labels = comma) +
  labs(title = "Water Usage: Sustainable vs Conventional Production",
       subtitle = "Distribution of water consumption across production methods",
       x = "Production Method",
       y = "Water Usage (liters)",
       fill = "Production Method") +
  theme(legend.position = "none",
        plot.title = element_text(face = "bold", size = 14))

ggsave("figures/02_water_by_production.png", plot2, width = 8, height = 6, dpi = 300)

# ========================================
# PLOT 3: Environmental Impact by Clothing Type
# ========================================

cat("3. Creating environmental impact by clothing type...\n")

impact_by_type <- fashion_data %>%
  group_by(clothing_type) %>%
  summarise(
    mean_co2 = mean(co2_emissions_kg),
    mean_water = mean(water_usage_liters) / 1000,  # Convert to thousands
    .groups = 'drop'
  ) %>%
  arrange(desc(mean_co2))

plot3 <- ggplot(impact_by_type, aes(x = reorder(clothing_type, mean_co2),
                                    y = mean_co2)) +
  geom_bar(stat = "identity", fill = "#3498DB", alpha = 0.8) +
  geom_text(aes(label = sprintf("%.1f", mean_co2)), hjust = -0.2, size = 3) +
  coord_flip() +
  labs(title = "Average CO2 Emissions by Clothing Type",
       subtitle = "Carbon footprint varies significantly across garment categories",
       x = "Clothing Type",
       y = "Average CO2 Emissions (kg)") +
  theme(plot.title = element_text(face = "bold", size = 14),
        panel.grid.major.y = element_blank())

ggsave("figures/03_co2_by_clothing_type.png", plot3, width = 10, height = 6, dpi = 300)

# ========================================
# PLOT 4: Lifespan vs CO2 (Scatter Plot with Regression)
# ========================================

cat("4. Creating lifespan vs CO2 scatter plot...\n")

plot4 <- ggplot(fashion_data, aes(x = lifespan_years, y = co2_emissions_kg,
                                  color = production_method)) +
  geom_point(alpha = 0.5, size = 2) +
  geom_smooth(method = "lm", se = TRUE, linewidth = 1.2) +
  scale_color_manual(values = sustainable_colors) +
  labs(title = "Relationship Between Lifespan and CO2 Emissions",
       subtitle = "Longer-lasting items may have higher initial emissions but better long-term impact",
       x = "Lifespan (years)",
       y = "CO2 Emissions (kg)",
       color = "Production Method") +
  theme(plot.title = element_text(face = "bold", size = 14),
        legend.position = "bottom")

ggsave("figures/04_lifespan_vs_co2.png", plot4, width = 10, height = 7, dpi = 300)

# ========================================
# PLOT 5: Water Usage by Material Type
# ========================================

cat("5. Creating water usage by material plot...\n")

water_by_material <- fashion_data %>%
  group_by(material) %>%
  summarise(
    mean_water = mean(water_usage_liters),
    n = n(),
    .groups = 'drop'
  ) %>%
  arrange(desc(mean_water))

plot5 <- ggplot(water_by_material, aes(x = reorder(material, mean_water),
                                       y = mean_water, fill = mean_water)) +
  geom_bar(stat = "identity", alpha = 0.8) +
  scale_fill_gradient(low = "#27AE60", high = "#E74C3C") +
  scale_y_continuous(labels = comma) +
  geom_text(aes(label = comma(round(mean_water))), hjust = -0.1, size = 3) +
  coord_flip() +
  labs(title = "Water Usage by Material Type",
       subtitle = "Some materials are significantly more water-intensive than others",
       x = "Material",
       y = "Average Water Usage (liters)",
       fill = "Water Usage") +
  theme(plot.title = element_text(face = "bold", size = 14),
        legend.position = "none")

ggsave("figures/05_water_by_material.png", plot5, width = 10, height = 6, dpi = 300)

# ========================================
# PLOT 6: Environmental Impact Score Distribution
# ========================================

cat("6. Creating environmental impact score distribution...\n")

plot6 <- ggplot(fashion_data, aes(x = env_impact_score,
                                  fill = sustainability_category)) +
  geom_histogram(bins = 30, alpha = 0.7, color = "white") +
  scale_fill_manual(values = impact_colors) +
  facet_wrap(~production_method, ncol = 1) +
  labs(title = "Distribution of Environmental Impact Scores",
       subtitle = "Comparing impact across production methods",
       x = "Environmental Impact Score (lower is better)",
       y = "Count",
       fill = "Impact Category") +
  theme(plot.title = element_text(face = "bold", size = 14),
        legend.position = "bottom",
        strip.text = element_text(face = "bold"))

ggsave("figures/06_impact_score_distribution.png", plot6, width = 10, height = 8, dpi = 300)

# ========================================
# PLOT 7: Multi-panel Comparison
# ========================================

cat("7. Creating multi-panel comparison plot...\n")

# Prepare summary data
summary_data <- fashion_data %>%
  group_by(production_method) %>%
  summarise(
    CO2 = mean(co2_emissions_kg),
    Water = mean(water_usage_liters) / 1000,
    Lifespan = mean(lifespan_years),
    Price = mean(price_usd),
    .groups = 'drop'
  ) %>%
  pivot_longer(cols = c(CO2, Water, Lifespan, Price),
               names_to = "Metric",
               values_to = "Value")

plot7a <- ggplot(summary_data %>% filter(Metric == "CO2"),
                aes(x = production_method, y = Value, fill = production_method)) +
  geom_bar(stat = "identity", alpha = 0.8) +
  scale_fill_manual(values = sustainable_colors) +
  labs(title = "CO2 (kg)", x = "", y = "") +
  theme(legend.position = "none")

plot7b <- ggplot(summary_data %>% filter(Metric == "Water"),
                aes(x = production_method, y = Value, fill = production_method)) +
  geom_bar(stat = "identity", alpha = 0.8) +
  scale_fill_manual(values = sustainable_colors) +
  labs(title = "Water (1000s L)", x = "", y = "") +
  theme(legend.position = "none")

plot7c <- ggplot(summary_data %>% filter(Metric == "Lifespan"),
                aes(x = production_method, y = Value, fill = production_method)) +
  geom_bar(stat = "identity", alpha = 0.8) +
  scale_fill_manual(values = sustainable_colors) +
  labs(title = "Lifespan (years)", x = "", y = "") +
  theme(legend.position = "none")

plot7d <- ggplot(summary_data %>% filter(Metric == "Price"),
                aes(x = production_method, y = Value, fill = production_method)) +
  geom_bar(stat = "identity", alpha = 0.8) +
  scale_fill_manual(values = sustainable_colors) +
  labs(title = "Price (USD)", x = "", y = "") +
  theme(legend.position = "none")

plot7 <- grid.arrange(plot7a, plot7b, plot7c, plot7d, ncol = 2,
                     top = "Comprehensive Comparison: Sustainable vs Conventional")

ggsave("figures/07_multi_panel_comparison.png", plot7, width = 10, height = 8, dpi = 300)

# ========================================
# PLOT 8: Correlation Heatmap
# ========================================

cat("8. Creating correlation heatmap...\n")

# Prepare correlation data
cor_data <- fashion_data %>%
  select(co2_emissions_kg, water_usage_liters, lifespan_years,
         price_usd, recycled_content_pct, washes_before_disposal) %>%
  cor(use = "complete.obs") %>%
  as.data.frame() %>%
  rownames_to_column("Variable1") %>%
  pivot_longer(cols = -Variable1, names_to = "Variable2", values_to = "Correlation")

# Shorten variable names for better display
cor_data <- cor_data %>%
  mutate(
    Variable1 = case_when(
      Variable1 == "co2_emissions_kg" ~ "CO2",
      Variable1 == "water_usage_liters" ~ "Water",
      Variable1 == "lifespan_years" ~ "Lifespan",
      Variable1 == "price_usd" ~ "Price",
      Variable1 == "recycled_content_pct" ~ "Recycled %",
      Variable1 == "washes_before_disposal" ~ "Washes",
      TRUE ~ Variable1
    ),
    Variable2 = case_when(
      Variable2 == "co2_emissions_kg" ~ "CO2",
      Variable2 == "water_usage_liters" ~ "Water",
      Variable2 == "lifespan_years" ~ "Lifespan",
      Variable2 == "price_usd" ~ "Price",
      Variable2 == "recycled_content_pct" ~ "Recycled %",
      Variable2 == "washes_before_disposal" ~ "Washes",
      TRUE ~ Variable2
    )
  )

plot8 <- ggplot(cor_data, aes(x = Variable1, y = Variable2, fill = Correlation)) +
  geom_tile(color = "white") +
  geom_text(aes(label = sprintf("%.2f", Correlation)), size = 3) +
  scale_fill_gradient2(low = "#3498DB", mid = "white", high = "#E74C3C",
                      midpoint = 0, limits = c(-1, 1)) +
  labs(title = "Correlation Matrix of Environmental Variables",
       subtitle = "Understanding relationships between key metrics",
       x = "", y = "") +
  theme(plot.title = element_text(face = "bold", size = 14),
        axis.text.x = element_text(angle = 45, hjust = 1))

ggsave("figures/08_correlation_heatmap.png", plot8, width = 9, height = 7, dpi = 300)

# ========================================
# PLOT 9: Cost-Benefit Analysis
# ========================================

cat("9. Creating cost-benefit analysis plot...\n")

plot9 <- ggplot(fashion_data, aes(x = cost_per_year, y = env_impact_score,
                                  color = production_method, size = lifespan_years)) +
  geom_point(alpha = 0.6) +
  scale_color_manual(values = sustainable_colors) +
  scale_size_continuous(range = c(1, 5)) +
  labs(title = "Cost-Benefit Analysis: Economic vs Environmental Impact",
       subtitle = "Lower right quadrant represents best value (low cost, low impact)",
       x = "Cost per Year (USD)",
       y = "Environmental Impact Score",
       color = "Production Method",
       size = "Lifespan (years)") +
  theme(plot.title = element_text(face = "bold", size = 14),
        legend.position = "right") +
  geom_hline(yintercept = median(fashion_data$env_impact_score),
             linetype = "dashed", alpha = 0.5) +
  geom_vline(xintercept = median(fashion_data$cost_per_year),
             linetype = "dashed", alpha = 0.5)

ggsave("figures/09_cost_benefit_analysis.png", plot9, width = 12, height = 7, dpi = 300)

# ========================================
# PLOT 10: Sustainability by Category
# ========================================

cat("10. Creating sustainability category summary...\n")

sustainability_counts <- fashion_data %>%
  group_by(production_method, sustainability_category) %>%
  summarise(count = n(), .groups = 'drop') %>%
  group_by(production_method) %>%
  mutate(percentage = count / sum(count) * 100)

plot10 <- ggplot(sustainability_counts,
                aes(x = production_method, y = percentage,
                    fill = sustainability_category)) +
  geom_bar(stat = "identity", position = "fill", alpha = 0.8) +
  scale_fill_manual(values = impact_colors) +
  scale_y_continuous(labels = percent) +
  geom_text(aes(label = sprintf("%.0f%%", percentage)),
            position = position_fill(vjust = 0.5), size = 4) +
  labs(title = "Sustainability Distribution by Production Method",
       subtitle = "Percentage of items in each impact category",
       x = "Production Method",
       y = "Percentage",
       fill = "Impact Category") +
  theme(plot.title = element_text(face = "bold", size = 14),
        legend.position = "bottom")

ggsave("figures/10_sustainability_categories.png", plot10, width = 10, height = 7, dpi = 300)

# ========================================
# SUMMARY REPORT
# ========================================

cat("\n\n✓ All visualizations created successfully!\n")
cat("\nVisualization files saved in figures/ directory:\n")
cat("  1. 01_co2_by_production.png\n")
cat("  2. 02_water_by_production.png\n")
cat("  3. 03_co2_by_clothing_type.png\n")
cat("  4. 04_lifespan_vs_co2.png\n")
cat("  5. 05_water_by_material.png\n")
cat("  6. 06_impact_score_distribution.png\n")
cat("  7. 07_multi_panel_comparison.png\n")
cat("  8. 08_correlation_heatmap.png\n")
cat("  9. 09_cost_benefit_analysis.png\n")
cat(" 10. 10_sustainability_categories.png\n")

# Save visualization summary
sink("output/visualization_summary.txt")
cat("=== SUSTAINABLE FASHION VISUALIZATION SUMMARY ===\n\n")
cat(sprintf("Generated: %s\n\n", Sys.Date()))
cat("Total visualizations created: 10\n\n")
cat("Key Visualizations:\n")
cat("- Production method comparisons (CO2, water)\n")
cat("- Clothing type environmental impact\n")
cat("- Material water usage analysis\n")
cat("- Lifespan vs emissions relationship\n")
cat("- Impact score distributions\n")
cat("- Correlation analysis\n")
cat("- Cost-benefit analysis\n")
cat("- Sustainability category breakdown\n")
sink()

cat("\nVisualization summary saved to: output/visualization_summary.txt\n")
