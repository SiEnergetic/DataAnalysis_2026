# Data Manipulation and Cleaning

## Assignment
Practical class 1: Missing Data & Outliers

## Dataset
- Name: Hormonal and Biochemical Profile in Patients
- Source: Internal company database
- Size: 1148 rows × 31 columns (after preprocessing)
- Format: CSV

## R Version
R 4.5.3

## Procedures Used
1. Little's MCAR Test (naniar) — result: p=0, data is NOT MCAR (MAR/MNAR)
2. Missing data imputation via MICE — method: PMM (Predictive Mean Matching)
3. Outlier detection via boxplots (ggplot2)

## Packages
naniar, mice, ggplot2, dplyr, tidyr
