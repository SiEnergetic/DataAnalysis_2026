
# -------Data Manipulation and Cleaning-------

# Working directory
getwd()

# Load dataset
data_path <- "DataSet_No_Details.csv"
df <- read.csv(data_path)

# Data inspection
str(df)
library(skimr)
skim(df)
summary(df)

# -------Data set preparation-------
library(dplyr)

cols_to_remove <- c("h_index_34", "h_index_56", "hormone10_1", "hormone10_2",
                    "an_index_23", "outcome", "factor_eth", "factor_h",
                    "factor_pcos", "factor_prl")

MD_df <- df %>% select(-any_of(cols_to_remove))
factor_df <- df %>% select(record_id, outcome, factor_eth, factor_h, factor_pcos, factor_prl)

str(MD_df)
summary(factor_df)

# -------Identify Missing Values-------
sum(is.na(MD_df))
colSums(is.na(MD_df))

na_stats <- colMeans(is.na(MD_df)) * 100
na_stats_filtered <- na_stats[na_stats <= 35]

handle_MD_df <- MD_df %>% select(any_of(names(na_stats_filtered)))

# Visualize missing data
library(visdat)
vis_miss(handle_MD_df)

library(naniar)
gg_miss_var(handle_MD_df)

# -------Little MCAR Test-------
library(naniar)
mcar_result <- mcar_test(handle_MD_df)
print(mcar_result)
write.csv(as.data.frame(mcar_result), "mcar_test_result.csv", row.names = FALSE)
# Result: p = 0, data is NOT MCAR (MAR/MNAR)

# -------Imputation with MICE-------
library(mice)

# PMM method
imputed_pmm <- mice(handle_MD_df, m = 5, method = "pmm", seed = 123)
imputed_handle_MD_df_final_pmm <- complete(imputed_pmm, 1)
write.csv(imputed_handle_MD_df_final_pmm, "imputed_handle_MD_df_final_pmm.csv", row.names = FALSE)

# RF method
imputed_rf <- mice(handle_MD_df, m = 5, method = "rf", seed = 123)
imputed_handle_MD_df_final_rf <- complete(imputed_rf, 1)
write.csv(imputed_handle_MD_df_final_rf, "imputed_handle_MD_df_final_rf.csv", row.names = FALSE)

# -------Compare distributions-------
library(ggplot2)

var <- "hormone10_generated"

# PMM vs Original
compare_pmm <- data.frame(
  value = c(handle_MD_df[[var]], imputed_handle_MD_df_final_pmm[[var]]),
  source = c(rep("Original", nrow(handle_MD_df)),
             rep("PMM", nrow(imputed_handle_MD_df_final_pmm)))
)

png("density_pmm.png", width = 800, height = 600)
ggplot(compare_pmm, aes(x = value, fill = source)) +
  geom_density(alpha = 0.5) +
  scale_x_continuous(limits = c(0, 2)) +
  labs(title = "Original vs PMM: hormone10_generated") +
  theme_minimal()
dev.off()

# PMM vs RF vs Original
compare_all <- data.frame(
  value = c(handle_MD_df[[var]], 
            imputed_handle_MD_df_final_pmm[[var]], 
            imputed_handle_MD_df_final_rf[[var]]),
  source = c(rep("Original", nrow(handle_MD_df)),
             rep("PMM", nrow(imputed_handle_MD_df_final_pmm)),
             rep("RF", nrow(imputed_handle_MD_df_final_rf)))
)

png("density_pmm_vs_rf.png", width = 800, height = 600)
ggplot(compare_all, aes(x = value, fill = source)) +
  geom_density(alpha = 0.4) +
  scale_x_continuous(limits = c(0, 2)) +
  labs(title = "Original vs PMM vs RF: hormone10_generated") +
  theme_minimal()
dev.off()

# -------Outlier Detection-------
library(tidyr)

# Lipids boxplot
lipids_long <- imputed_handle_MD_df_final_pmm %>%
  select(lipids1, lipids2, lipids3, lipids4, lipids5) %>%
  pivot_longer(cols = everything(), names_to = "variables", values_to = "value")

png("boxplot_outliers.png", width = 800, height = 600)
ggplot(lipids_long, aes(x = variables, y = value)) +
  geom_boxplot(fill = "lightblue") +
  labs(title = "Outlier Detection") +
  theme_minimal()
dev.off()

