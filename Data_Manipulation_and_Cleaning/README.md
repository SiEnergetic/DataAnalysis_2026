# Data Manipulation and Cleaning

This is my first practical assignment for the Data Analysis course at IRNITU.
The goal was to deal with missing values and detect outliers in a real biomedical dataset.

## About the Data

The dataset is called "Hormonal and Biochemical Profile in Patients" — 
real patient records from an internal database.
It has 1148 rows and 31 variables (after initial cleanup): 
hormones, lipids, carbohydrate metabolism, lipid peroxidation markers, and antioxidants.

## What I Did

1. Cleaned the data — dropped columns with more than 35% missing values
2. Explored where and how much data was missing — visualized with naniar
3. Ran Little's MCAR Test — checked whether the missing data is random
4. Imputed missing values using two methods — PMM and Random Forest — and compared them
5. Detected outliers using boxplots

## Key Findings

Little's MCAR test returned p = 0, meaning the missing data is **not random** —
it's likely related to other variables in the dataset (MAR or MNAR).

Both imputation methods (PMM and RF) worked well and produced similar results.
PMM was faster, RF took more time but gave comparable distributions.

## Files

- `DataSet_No_Details.csv` — original dataset
- `Data_Manipulation_Process.R` — full R script
- `handle_MD_df.csv` — dataset after removing high-NA columns
- `imputed_handle_MD_df_final_pmm.csv` — imputed dataset using PMM
- `imputed_handle_MD_df_final_rf.csv` — imputed dataset using RF
- `density_pmm_vs_rf.png` — distribution comparison: Original vs PMM vs RF
- `boxplot_outliers.png` — boxplots for outlier detection

## Tools

R 4.5.3 | naniar, mice, ranger, ggplot2, dplyr, tidyr
