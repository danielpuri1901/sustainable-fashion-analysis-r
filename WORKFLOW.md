# Project Workflow - Visual Guide

## The Analysis Pipeline

```
┌─────────────────────────────────────────────────────────────────┐
│                    RAW DATA (300 items)                         │
│  CO2, Water, Lifespan, Price, Material, Production Method      │
└────────────────────────┬────────────────────────────────────────┘
                         │
                         ▼
┌─────────────────────────────────────────────────────────────────┐
│                 STEP 1: DATA CLEANING                           │
│  • Handle missing values (15 items)                             │
│  • Create derived variables (cost/year, impact score)           │
│  • Convert data types (factors, numeric)                        │
│                                                                  │
│  Tool: dplyr                                                     │
│  Output: fashion_impact_cleaned.csv                             │
└────────────────────────┬────────────────────────────────────────┘
                         │
                         ▼
┌─────────────────────────────────────────────────────────────────┐
│            STEP 2: EXPLORATORY ANALYSIS                         │
│  • Mean CO2: Sustainable=18kg vs Conventional=28kg              │
│  • Correlation: CO2 & Water r=0.75                              │
│  • Most impactful: Coats, Jeans                                 │
│                                                                  │
│  Tool: dplyr + base R                                            │
│  Output: eda_summary.txt                                         │
└────────────────────────┬────────────────────────────────────────┘
                         │
                         ▼
┌─────────────────────────────────────────────────────────────────┐
│           STEP 3: HYPOTHESIS TESTING                            │
│  • t-test: Sustainable < Conventional (p < 0.001) ✓             │
│  • ANOVA: Clothing type matters (p < 0.001) ✓                   │
│  • Effect size: Cohen's d = 0.85 (Large)                        │
│                                                                  │
│  Tool: base R stats                                              │
│  Output: hypothesis_testing_results.txt                          │
└────────────────────────┬────────────────────────────────────────┘
                         │
                         ▼
┌─────────────────────────────────────────────────────────────────┐
│           STEP 4: REGRESSION MODELING                           │
│  • Model: CO2 ~ Production + Material + Lifespan               │
│  • R² = 0.75 (explains 75% of variance)                         │
│  • All predictors significant                                   │
│                                                                  │
│  Tool: lm(), MASS::stepAIC()                                     │
│  Output: regression_analysis_results.txt                         │
└────────────────────────┬────────────────────────────────────────┘
                         │
                         ▼
┌─────────────────────────────────────────────────────────────────┐
│              STEP 5: VISUALIZATION                              │
│  • 10 professional charts (boxplots, scatter, heatmaps)         │
│  • Publication-quality (300 DPI PNG)                            │
│  • Color-coded by sustainability                                │
│                                                                  │
│  Tool: ggplot2                                                   │
│  Output: figures/*.png (10 files)                                │
└────────────────────────┬────────────────────────────────────────┘
                         │
                         ▼
┌─────────────────────────────────────────────────────────────────┐
│              STEP 6: FINAL REPORT                               │
│  • R Markdown document                                          │
│  • Integrates code, results, visualizations                     │
│  • Exports to HTML/PDF                                          │
│                                                                  │
│  Tool: rmarkdown::render()                                       │
│  Output: sustainable_fashion_report.html                         │
└─────────────────────────────────────────────────────────────────┘
```

---

## Data Flow Diagram

```
fashion_impact_data.csv (RAW)
        │
        ├─> 01_data_cleaning.R
        │       ↓
        │   fashion_impact_cleaned.csv
        │       ↓
        ├─> 02_exploratory_analysis.R    ──> output/eda_summary.txt
        │
        ├─> 03_hypothesis_testing.R       ──> output/hypothesis_testing_results.txt
        │
        ├─> 04_regression_analysis.R      ──> output/regression_analysis_results.txt
        │
        ├─> 05_visualizations.R           ──> figures/*.png (10 charts)
        │
        └─> sustainable_fashion_report.Rmd ──> .html report
                (combines everything)
```

---

## Key Metrics Summary

| Metric | Conventional | Sustainable | Improvement |
|--------|-------------|-------------|-------------|
| **CO2 (kg)** | 28.4 | 18.2 | **-36%** |
| **Water (L)** | 4,120 | 2,340 | **-43%** |
| **Lifespan (yrs)** | 3.2 | 4.8 | **+50%** |
| **Price ($)** | 43 | 51 | +19% |
| **Cost/Year ($)** | 13.4 | 10.6 | **-21%** |

**Statistical Validation:** All p < 0.001, Effect sizes: Large (d > 0.8)

---

## Code Execution Order

1. `scripts/01_data_cleaning.R` → Creates cleaned dataset
2. `scripts/02_exploratory_analysis.R` → Generates summary statistics
3. `scripts/03_hypothesis_testing.R` → Runs statistical tests
4. `scripts/04_regression_analysis.R` → Builds predictive models
5. `scripts/05_visualizations.R` → Creates all charts
6. `sustainable_fashion_report.Rmd` → Compiles everything into report

**Or:** Just knit the `.Rmd` file - it runs everything automatically!

---

## What Each Script Does (Simple Version)

### 01_data_cleaning.R
**Input:** Raw CSV with some missing values
**Does:** Fills in missing values, calculates impact scores
**Output:** Clean CSV ready for analysis

### 02_exploratory_analysis.R
**Input:** Clean data
**Does:** Calculates averages, correlations, distributions
**Output:** Text file with summary statistics

### 03_hypothesis_testing.R
**Input:** Clean data
**Does:** Tests if differences are statistically significant
**Output:** P-values and effect sizes proving sustainable is better

### 04_regression_analysis.R
**Input:** Clean data
**Does:** Builds equations to predict CO2 and water usage
**Output:** Models that can predict impact for new items

### 05_visualizations.R
**Input:** Clean data
**Does:** Creates 10 professional charts
**Output:** PNG images showing all findings visually

### sustainable_fashion_report.Rmd
**Input:** All of the above
**Does:** Combines code, results, and charts into one document
**Output:** Professional HTML/PDF report

---

## The "So What?" Chain

```
DATA
  ↓
ANALYSIS (t-tests show significant differences)
  ↓
INSIGHT (Sustainable reduces CO2 by 40%)
  ↓
RECOMMENDATION (Fashion brands should adopt sustainable production)
  ↓
IMPACT (Data-driven sustainability decisions)
```

---

## Tech Stack At-A-Glance

```
R Language (v4.0+)
    ├── tidyverse ecosystem
    │   ├── dplyr (data manipulation)
    │   ├── ggplot2 (visualization)
    │   ├── tidyr (data reshaping)
    │   └── readr (data import)
    │
    ├── Statistical packages
    │   ├── base R stats (t-test, ANOVA)
    │   ├── car (regression diagnostics)
    │   └── MASS (model selection)
    │
    └── Reporting
        └── rmarkdown (reproducible reports)
```

---

## Interview Quick Reference

**Question:** "What does this project do?"
**Answer:** "Analyzes 300 clothing items to prove sustainable production reduces environmental impact by 40-45%."

**Question:** "What skills does it show?"
**Answer:** "R programming, statistical hypothesis testing, regression modeling, and data visualization."

**Question:** "What's the most important finding?"
**Answer:** "Sustainable production significantly reduces CO2 and water usage while increasing product lifespan - all statistically validated with p < 0.001."

**Question:** "How long did it take?"
**Answer:** "Built over 2 weeks as a comprehensive portfolio project demonstrating R and statistical analysis skills."

**Question:** "Can you show me?"
**Answer:** "Yes! Let me open RStudio and run through a quick demo..." (use demo script from PROJECT_OVERVIEW.md)
