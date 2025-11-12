# Sustainable Fashion Impact Analysis in R

A comprehensive statistical analysis of environmental impact in fashion production, comparing sustainable and conventional methods.

## Project Overview

This project analyzes the environmental footprint of 300 clothing items across multiple dimensions including CO2 emissions, water usage, product lifespan, and cost. It demonstrates advanced R programming, statistical analysis, and data visualization techniques relevant to sustainable fashion and environmental impact assessment.

## Key Features

- **Data Analysis:** Exploratory data analysis using dplyr and tidyverse
- **Statistical Testing:** Hypothesis testing with t-tests and ANOVA
- **Regression Models:** Linear and multiple regression analysis
- **Visualizations:** Publication-quality charts using ggplot2
- **Comprehensive Report:** R Markdown document with full analysis

## Technologies Used

- **R** (primary language)
- **ggplot2** - Data visualization
- **dplyr** - Data manipulation
- **tidyverse** - Data science workflow
- **R Markdown** - Reproducible reporting
- **broom** - Statistical model tidying
- **car** - Regression diagnostics

## Project Structure

```
sustainable-fashion-analysis-r/
├── data/
│   ├── fashion_impact_data.csv         # Raw dataset
│   └── fashion_impact_cleaned.csv      # Cleaned dataset
├── scripts/
│   ├── generate_data.R                 # Dataset generation
│   ├── 01_data_cleaning.R              # Data cleaning with dplyr
│   ├── 02_exploratory_analysis.R       # EDA
│   ├── 03_hypothesis_testing.R         # t-tests and ANOVA
│   ├── 04_regression_analysis.R        # Regression models
│   └── 05_visualizations.R             # ggplot2 visualizations
├── output/
│   ├── cleaning_summary.txt
│   ├── eda_summary.txt
│   ├── hypothesis_testing_results.txt
│   └── regression_analysis_results.txt
├── figures/
│   └── (10 publication-quality visualizations)
├── sustainable_fashion_report.Rmd      # Main R Markdown report
└── README.md
```

## Key Findings

### Environmental Impact Reductions (Sustainable vs Conventional)
- **CO2 Emissions:** 40-45% reduction
- **Water Usage:** 45-50% reduction
- **Product Lifespan:** 30-40% longer

### Statistical Significance
- Production method significantly affects CO2 emissions (p < 0.001)
- Clothing type significantly affects environmental impact (ANOVA, p < 0.001)
- Strong correlation between CO2 and water usage (r > 0.7)

### Predictive Models
- Multiple regression model for CO2 emissions (R² ≈ 0.75)
- Linear regression for water usage based on lifespan
- Interaction effects between production method and product characteristics

## Installation & Setup

### Prerequisites

Install R (version 4.0+) and the required packages:

```r
# Install required packages
install.packages(c(
  "dplyr",
  "ggplot2",
  "tidyr",
  "readr",
  "tibble",
  "broom",
  "car",
  "MASS",
  "scales",
  "gridExtra",
  "RColorBrewer",
  "knitr",
  "rmarkdown",
  "lmtest"
))
```

### Running the Analysis

**Note:** The dataset is already included in the repository, so you can skip data generation and go straight to running the analysis scripts.

#### Option 1: Using RStudio (Recommended for Beginners)

1. **Clone the repository:**
```bash
git clone https://github.com/danielpuri1901/sustainable-fashion-analysis-r.git
cd sustainable-fashion-analysis-r
```

2. **Open RStudio** and set working directory:
   - In RStudio: `Session > Set Working Directory > To Project Directory`
   - Or use: `setwd("/path/to/sustainable-fashion-analysis-r")`

3. **Install packages** (if not already installed):
```r
install.packages(c("dplyr", "ggplot2", "tidyr", "readr", "tibble", "broom", "car",
                   "MASS", "scales", "gridExtra", "RColorBrewer",
                   "knitr", "rmarkdown", "lmtest"))
```

4. **Run analysis scripts** (in the R Console):
```r
# Data is already included, but you can regenerate it:
source("scripts/generate_data.R")

# Run analysis scripts in order:
source("scripts/01_data_cleaning.R")
source("scripts/02_exploratory_analysis.R")
source("scripts/03_hypothesis_testing.R")
source("scripts/04_regression_analysis.R")
source("scripts/05_visualizations.R")
```

5. **Generate the full report:**
   - Open `sustainable_fashion_report.Rmd` in RStudio
   - Click the "Knit" button at the top
   - Or run: `rmarkdown::render("sustainable_fashion_report.Rmd")`

#### Option 2: Using Terminal/Command Line

1. **Clone the repository:**
```bash
git clone https://github.com/danielpuri1901/sustainable-fashion-analysis-r.git
cd sustainable-fashion-analysis-r
```

2. **Run scripts using Rscript** (requires R installed):
```bash
# Note: Rscript must be installed and in your PATH
# On Mac, you may need to use the full path, e.g., /usr/local/bin/Rscript

# Run analysis scripts in order:
Rscript scripts/01_data_cleaning.R
Rscript scripts/02_exploratory_analysis.R
Rscript scripts/03_hypothesis_testing.R
Rscript scripts/04_regression_analysis.R
Rscript scripts/05_visualizations.R
```

3. **Generate the report from terminal:**
```bash
Rscript -e "rmarkdown::render('sustainable_fashion_report.Rmd')"
```

#### Option 3: Using R from Terminal

1. **Navigate to project directory:**
```bash
cd sustainable-fashion-analysis-r
```

2. **Start R:**
```bash
R
```

3. **In the R console, run:**
```r
# Run analysis scripts
source("scripts/01_data_cleaning.R")
source("scripts/02_exploratory_analysis.R")
source("scripts/03_hypothesis_testing.R")
source("scripts/04_regression_analysis.R")
source("scripts/05_visualizations.R")

# Generate report
rmarkdown::render("sustainable_fashion_report.Rmd")

# Exit R when done
quit()
```

## Analysis Components

### 1. Data Cleaning (`01_data_cleaning.R`)
- Handling missing values
- Creating derived variables
- Data type conversions
- Outlier detection

### 2. Exploratory Data Analysis (`02_exploratory_analysis.R`)
- Univariate analysis
- Bivariate comparisons
- Correlation analysis
- Group comparisons

### 3. Hypothesis Testing (`03_hypothesis_testing.R`)
- Two-sample t-tests (production methods)
- One-way ANOVA (clothing types, materials)
- Two-way ANOVA (interaction effects)
- Post-hoc tests (Tukey HSD)
- Effect size calculations

### 4. Regression Analysis (`04_regression_analysis.R`)
- Simple linear regression
- Multiple regression models
- Polynomial regression
- Stepwise model selection
- Model diagnostics and validation

### 5. Data Visualizations (`05_visualizations.R`)
Creates 10 publication-quality visualizations:
- Boxplots comparing production methods
- Bar charts by clothing type
- Scatter plots with regression lines
- Correlation heatmaps
- Multi-panel comparisons
- Cost-benefit analysis plots

### 6. Comprehensive Report (`sustainable_fashion_report.Rmd`)
R Markdown document integrating all analyses with:
- Executive summary
- Statistical results
- Visualizations
- Interpretations
- Recommendations

## Dataset Description

The dataset includes the following variables:

| Variable | Description |
|----------|-------------|
| `item_id` | Unique identifier |
| `clothing_type` | Type of garment (T-Shirt, Jeans, etc.) |
| `material` | Material composition |
| `production_method` | Conventional or Sustainable |
| `lifespan_years` | Expected lifespan |
| `co2_emissions_kg` | CO2 emissions in kg |
| `water_usage_liters` | Water consumption in liters |
| `price_usd` | Price in USD |
| `washes_before_disposal` | Number of washes |
| `recycled_content_pct` | Percentage of recycled content |

## Skills Demonstrated

This project demonstrates proficiency in:

✅ **R Programming** - Advanced R syntax and best practices
✅ **Data Manipulation** - dplyr, tidyr for data transformation
✅ **Statistical Analysis** - Hypothesis testing, ANOVA, regression
✅ **Data Visualization** - ggplot2 for publication-quality graphics
✅ **Reproducible Research** - R Markdown for reproducible reporting
✅ **Domain Knowledge** - Sustainable fashion and environmental impact

## Use Cases

This analysis is relevant for:
- **Fashion Brands:** Assess and optimize environmental impact
- **Consumers:** Make informed sustainable fashion choices
- **Policy Makers:** Data-driven sustainability regulations
- **Researchers:** Methodology for environmental impact analysis
- **Students:** Example of comprehensive statistical analysis in R

## Future Enhancements

Potential extensions of this project:
- Incorporate real-world data from fashion brands
- Add lifecycle assessment (LCA) components
- Include transportation and packaging impacts
- Develop Shiny app for interactive exploration
- Time series analysis of trends
- Machine learning models for impact prediction

## Author

**Daniel Puri**
Master's Student - Data Science
Project: Sustainable Fashion Impact Analysis

## License

This project is available for educational and research purposes.

## Acknowledgments

- Data inspired by sustainable fashion research
- Statistical methods from standard statistical texts
- Visualization techniques from R graphics community

## Contact

For questions or collaboration opportunities, please reach out via GitHub.

---

**Last Updated:** 2025
**Status:** Complete
