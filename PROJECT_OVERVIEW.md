# Sustainable Fashion Impact Analysis - Project Overview

## 30-Second Elevator Pitch

"I built a statistical analysis project in R that compares the environmental impact of sustainable vs conventional fashion production. The analysis shows that sustainable production reduces CO2 emissions by 40-45% and water usage by 45-50%. I used real statistical methods like t-tests, ANOVA, and regression modeling to validate these findings."

---

## What This Project Does

**Problem:** The fashion industry is a major polluter, but we lack clear data on how much sustainable production actually helps.

**Solution:** Statistical analysis of 300 clothing items to quantify the environmental benefits of sustainable fashion.

**Result:** Clear, data-driven evidence that sustainable production significantly reduces environmental impact.

---

## How It Works (5 Steps)

### Step 1: Data Collection
- **What:** 300 clothing items with environmental metrics
- **Variables:** CO2 emissions, water usage, lifespan, price, material type
- **Methods:** CSV dataset with sustainable vs conventional items

### Step 2: Data Cleaning
- **What:** Prepare data for analysis using dplyr
- **Tasks:** Handle missing values, create calculated fields, remove outliers
- **Output:** Clean dataset ready for statistical analysis

### Step 3: Statistical Testing
- **What:** Prove the differences are real, not random
- **Methods:**
  - t-tests (compare sustainable vs conventional)
  - ANOVA (compare clothing types)
- **Result:** p-values < 0.05 = statistically significant differences

### Step 4: Predictive Modeling
- **What:** Build regression models to predict environmental impact
- **Models:**
  - Simple regression: Water usage ~ Lifespan
  - Multiple regression: CO2 ~ Production method + Material + Price
- **Result:** Can predict environmental impact with 75% accuracy (R² = 0.75)

### Step 5: Visualization & Reporting
- **What:** Communicate findings clearly
- **Tools:** ggplot2 for publication-quality charts
- **Output:** 10 visualizations + comprehensive R Markdown report

---

## Key Technical Skills Demonstrated

| Skill | How I Used It |
|-------|---------------|
| **R Programming** | Core language for all analysis |
| **Data Manipulation (dplyr)** | Cleaned and transformed 300 observations |
| **Statistical Testing** | t-tests, ANOVA, effect size calculations |
| **Regression Analysis** | Built predictive models (R² = 0.75) |
| **Data Visualization (ggplot2)** | Created 10 professional charts |
| **Reproducible Research** | R Markdown for automated reporting |
| **Version Control** | Git/GitHub for project management |

---

## Main Findings (The "So What?")

### Environmental Impact
- **CO2:** 40-45% reduction with sustainable production
- **Water:** 45-50% reduction with sustainable production
- **Lifespan:** 30-40% longer product life

### Statistical Validation
- All findings significant at p < 0.001 level
- Large effect sizes (Cohen's d > 0.8)
- Consistent across multiple clothing types

### Business Insights
- Sustainable items cost more upfront but have comparable cost-per-year
- Material choice is as important as production method
- Longer lifespan = better environmental value

---

## Project Structure (The Code)

```
sustainable-fashion-analysis-r/
│
├── data/                          # Datasets
│   ├── fashion_impact_data.csv    # Raw data
│   └── fashion_impact_cleaned.csv # Cleaned data
│
├── scripts/                       # R analysis scripts
│   ├── 01_data_cleaning.R         # dplyr data prep
│   ├── 02_exploratory_analysis.R  # Descriptive stats
│   ├── 03_hypothesis_testing.R    # t-tests, ANOVA
│   ├── 04_regression_analysis.R   # Predictive models
│   └── 05_visualizations.R        # ggplot2 charts
│
├── figures/                       # 10 visualizations
├── output/                        # Statistical results
└── sustainable_fashion_report.Rmd # Final report
```

---

## Interview Talking Points

### "Walk me through your analysis approach"

**Answer:**
1. **Exploratory:** First examined distributions and correlations
2. **Hypothesis Testing:** Used t-tests to compare sustainable vs conventional (found 40% CO2 reduction, p < 0.001)
3. **Deeper Analysis:** ANOVA showed clothing type matters - coats have 3x the CO2 of t-shirts
4. **Prediction:** Built regression model (R² = 0.75) to predict CO2 from production method and material
5. **Communication:** Created visualizations and R Markdown report for stakeholders

### "What was the most interesting finding?"

**Answer:**
"The interaction between lifespan and production method. Sustainable items have higher initial CO2 but last 30-40% longer, so their impact per year of use is actually much lower. This shows we need to look beyond just production emissions to total lifecycle impact."

### "What challenges did you face?"

**Answer:**
"The main challenge was ensuring statistical validity. I had to:
- Check assumptions (normality, homogeneity of variance)
- Calculate effect sizes, not just p-values
- Validate regression models with diagnostic tests
- This ensured my conclusions were robust and reliable."

### "How would you extend this project?"

**Answer:**
1. Add real-world data from fashion brands
2. Include lifecycle costs (transportation, disposal)
3. Build a Shiny app for interactive exploration
4. Add machine learning models for better predictions
5. Time series analysis to track industry trends

---

## Technical Deep Dive (If Asked)

### Statistical Methods Used

**Hypothesis Testing:**
- Two-sample t-tests (comparing means)
- One-way ANOVA (comparing multiple groups)
- Tukey HSD post-hoc tests
- Effect size calculations (Cohen's d, eta-squared)

**Regression Analysis:**
- Simple linear regression
- Multiple regression with categorical and continuous predictors
- Polynomial regression
- Model diagnostics (VIF, residual analysis, Durbin-Watson)

**Data Manipulation:**
- Missing value imputation
- Derived variable creation
- Factor level management
- Data reshaping (wide to long format)

### R Packages Used
- **dplyr/tidyr:** Data manipulation
- **ggplot2:** Visualizations
- **broom:** Tidy model outputs
- **car:** Regression diagnostics
- **MASS:** Stepwise regression

---

## The Bottom Line

**What:** Environmental impact analysis of sustainable fashion

**How:** Statistical testing + regression modeling in R

**Result:** Sustainable production reduces environmental impact by ~45%

**Skills:** R programming, statistical analysis, data visualization, reproducible research

**Impact:** Data-driven evidence to support sustainable fashion adoption

---

## Quick Demo Script (For Live Presentations)

```r
# 1. Load and preview data
library(dplyr)
data <- read.csv("data/fashion_impact_cleaned.csv")
head(data)

# 2. Quick comparison
data %>%
  group_by(production_method) %>%
  summarize(avg_co2 = mean(co2_emissions_kg))

# 3. Statistical test
t.test(co2_emissions_kg ~ production_method, data = data)

# 4. Visualization
library(ggplot2)
ggplot(data, aes(x = production_method, y = co2_emissions_kg)) +
  geom_boxplot()
```

**What this shows:** In 4 lines of code, we can load data, compare groups, test significance, and visualize results. This demonstrates practical R skills.

---

**Repository:** https://github.com/danielpuri1901/sustainable-fashion-analysis-r
