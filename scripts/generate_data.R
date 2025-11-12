# Generate Synthetic Sustainable Fashion Dataset
# This script creates a realistic dataset for fashion impact analysis

set.seed(42)

# Number of samples
n <- 300

# Create dataset
fashion_data <- data.frame(
  item_id = 1:n,

  # Clothing categories
  clothing_type = sample(c("T-Shirt", "Jeans", "Dress", "Jacket", "Sweater",
                          "Shoes", "Shirt", "Skirt", "Pants", "Coat"),
                        n, replace = TRUE),

  # Material types
  material = sample(c("Cotton", "Polyester", "Wool", "Linen", "Silk",
                     "Recycled Cotton", "Organic Cotton", "Hemp"),
                   n, replace = TRUE,
                   prob = c(0.20, 0.25, 0.10, 0.08, 0.05, 0.12, 0.15, 0.05)),

  # Production method
  production_method = sample(c("Conventional", "Sustainable"),
                            n, replace = TRUE, prob = c(0.6, 0.4)),

  # Lifespan in years (sustainable items last longer)
  lifespan_years = round(rnorm(n, mean = 3.5, sd = 1.5), 1),

  # CO2 emissions in kg (varies by type and method)
  co2_emissions_kg = round(rnorm(n, mean = 15, sd = 8), 2),

  # Water usage in liters
  water_usage_liters = round(rnorm(n, mean = 2500, sd = 1200), 0),

  # Price in USD
  price_usd = round(rnorm(n, mean = 45, sd = 25), 2),

  # Number of washes before disposal
  washes_before_disposal = round(rnorm(n, mean = 50, sd = 20), 0),

  # Recycled content percentage
  recycled_content_pct = round(runif(n, 0, 60), 1)
)

# Adjust values based on production method
fashion_data$co2_emissions_kg <- ifelse(
  fashion_data$production_method == "Sustainable",
  fashion_data$co2_emissions_kg * 0.7,
  fashion_data$co2_emissions_kg * 1.2
)

fashion_data$water_usage_liters <- ifelse(
  fashion_data$production_method == "Sustainable",
  fashion_data$water_usage_liters * 0.6,
  fashion_data$water_usage_liters * 1.1
)

fashion_data$lifespan_years <- ifelse(
  fashion_data$production_method == "Sustainable",
  fashion_data$lifespan_years + rnorm(n, 1.5, 0.5),
  fashion_data$lifespan_years + rnorm(n, 0, 0.3)
)

# Adjust based on clothing type
clothing_multipliers <- data.frame(
  clothing_type = c("T-Shirt", "Jeans", "Dress", "Jacket", "Sweater",
                   "Shoes", "Shirt", "Skirt", "Pants", "Coat"),
  co2_mult = c(0.6, 1.8, 1.0, 2.0, 1.2, 1.5, 0.7, 0.8, 1.4, 2.2),
  water_mult = c(0.8, 2.5, 1.2, 1.8, 1.0, 0.9, 0.9, 0.9, 2.0, 1.6)
)

fashion_data <- merge(fashion_data, clothing_multipliers, by = "clothing_type")
fashion_data$co2_emissions_kg <- fashion_data$co2_emissions_kg * fashion_data$co2_mult
fashion_data$water_usage_liters <- fashion_data$water_usage_liters * fashion_data$water_mult

# Remove multiplier columns
fashion_data$co2_mult <- NULL
fashion_data$water_mult <- NULL

# Ensure positive values and realistic ranges
fashion_data$lifespan_years <- pmax(0.5, fashion_data$lifespan_years)
fashion_data$co2_emissions_kg <- pmax(2, round(fashion_data$co2_emissions_kg, 2))
fashion_data$water_usage_liters <- pmax(500, round(fashion_data$water_usage_liters, 0))
fashion_data$washes_before_disposal <- pmax(10, fashion_data$washes_before_disposal)
fashion_data$price_usd <- pmax(5, round(fashion_data$price_usd, 2))

# Add some missing values (realistic data cleaning scenario)
missing_indices <- sample(1:n, size = 15)
fashion_data$recycled_content_pct[missing_indices[1:5]] <- NA
fashion_data$washes_before_disposal[missing_indices[6:10]] <- NA
fashion_data$price_usd[missing_indices[11:15]] <- NA

# Save dataset
write.csv(fashion_data,
          "sustainable-fashion-analysis-r/data/fashion_impact_data.csv",
          row.names = FALSE)

cat("Dataset generated successfully!\n")
cat(sprintf("Total samples: %d\n", nrow(fashion_data)))
cat(sprintf("Variables: %d\n", ncol(fashion_data)))
cat("\nFirst few rows:\n")
print(head(fashion_data))
