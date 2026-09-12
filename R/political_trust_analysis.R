# Political Participation and Institutional Trust
# Comparative analysis of Germany, Italy, Poland, and Sweden
# Data source: European Social Survey (ESS) Round 11
#
# IMPORTANT:
# This script was reconstructed from the R code embedded in the original
# project presentation and aligned with the final paper specification.
# It is not a byte-for-byte copy of the original lost .R file.
#
# The final paper treats "donprty" as the political party/action-group
# participation variable used in the original analysis. No separate
# political-donation predictor is included.
#
# Expected raw data file:
#   data/ESS11.sav
#
# Install packages if needed:
# install.packages(c(
#   "haven", "dplyr", "car", "nortest", "margins",
#   "modelsummary", "psych", "corrplot"
# ))

# ==============================================================================
# 1. PACKAGES
# ==============================================================================

library(haven)
library(dplyr)
library(car)
library(nortest)
library(margins)
library(modelsummary)
library(psych)
library(corrplot)

# ==============================================================================
# 2. IMPORT AND PREPARE ESS ROUND 11 DATA
# ==============================================================================

ess_wave11 <- read_sav("data/ESS11.sav")

# Countries used in the study:
# DE = Germany, IT = Italy, PL = Poland, SE = Sweden
ess_subset <- ess_wave11 |>
  filter(cntry %in% c("DE", "IT", "PL", "SE"))

# Optional intermediate file
# saveRDS(ess_subset, "data/ess11_main_data.rds")

ess11_main_data <- ess_subset

# ==============================================================================
# 3. VARIABLE SELECTION
# ==============================================================================

main_data <- ess11_main_data |>
  select(
    cntry,
    trstprl, trstplt, trstprt, trstlgl,   # Institutional trust
    vote, contplt, donprty,                # Institutional participation
    sgnptit, pbldmna, bctprd, pstplonl,   # Non-institutional participation
    agea, gndr, eduyrs, rlgblg,            # Demographic controls
    polintr, mnactic                        # Political interest, employment
  )

# Inspect unique values where useful
# lapply(main_data, function(x) sort(unique(x)))

# ==============================================================================
# 4. DESCRIPTIVE DATA AND COMPLETE-CASE SAMPLE
# ==============================================================================

# Initial sample size
nrow(main_data)

# Summary before complete-case cleaning
summary(main_data)

# Cleaned descriptive sample
main_data_clean <- main_data[complete.cases(main_data), ]

# Sample size used for descriptive analysis in the final paper should be checked
# against the expected value of 7,286.
nrow(main_data_clean)

summary(main_data_clean)

# ==============================================================================
# 5. CROSS-COUNTRY NON-PARAMETRIC TESTS
# ==============================================================================

vars_to_test <- c(
  "agea", "eduyrs",
  "trstprl", "trstplt", "trstprt", "trstlgl"
)

# Anderson-Darling normality tests
for (var in vars_to_test) {
  cat("\n\nAnderson-Darling test:", var, "\n")
  print(ad.test(main_data_clean[[var]]))
}

# Kruskal-Wallis tests by country
kw_results <- list(
  trust_parliament = kruskal.test(trstprl ~ cntry, data = main_data_clean),
  trust_politicians = kruskal.test(trstplt ~ cntry, data = main_data_clean),
  trust_parties = kruskal.test(trstprt ~ cntry, data = main_data_clean),
  trust_legal = kruskal.test(trstlgl ~ cntry, data = main_data_clean),
  age = kruskal.test(agea ~ cntry, data = main_data_clean),
  education = kruskal.test(eduyrs ~ cntry, data = main_data_clean)
)

kw_results

# ==============================================================================
# 6. SELECTED CROSS-TABULATIONS
# ==============================================================================

# Gender x voting
vote_gender <- table(main_data_clean$gndr, main_data_clean$vote)
vote_gender
prop.table(vote_gender, margin = 2)

# Religion x boycott
religion_boycott <- table(main_data_clean$rlgblg, main_data_clean$bctprd)
religion_boycott
prop.table(religion_boycott, margin = 2)

# Gender x petition signing
gender_petition <- table(main_data_clean$gndr, main_data_clean$sgnptit)
gender_petition
prop.table(gender_petition, margin = 2)

# Political interest x contacting politician/official
interest_contact <- table(main_data_clean$polintr, main_data_clean$contplt)
interest_contact
prop.table(interest_contact, margin = 2)

# ==============================================================================
# 7. RECODE VARIABLES FOR LOGISTIC REGRESSION
# ==============================================================================

# Trust outcomes:
# 0-4 = Low trust
# 5-10 = High trust

main_data_clean$trstprl_bin <- factor(
  car::recode(main_data_clean$trstprl, "0:4 = 0; 5:10 = 1"),
  levels = c(0, 1),
  labels = c("Low Trust", "High Trust")
)

main_data_clean$trstplt_bin <- factor(
  car::recode(main_data_clean$trstplt, "0:4 = 0; 5:10 = 1"),
  levels = c(0, 1),
  labels = c("Low Trust", "High Trust")
)

main_data_clean$trstprt_bin <- factor(
  car::recode(main_data_clean$trstprt, "0:4 = 0; 5:10 = 1"),
  levels = c(0, 1),
  labels = c("Low Trust", "High Trust")
)

main_data_clean$trstlgl_bin <- factor(
  car::recode(main_data_clean$trstlgl, "0:4 = 0; 5:10 = 1"),
  levels = c(0, 1),
  labels = c("Low Trust", "High Trust")
)

# Participation variables
# Source coding used in the presentation:
# 1 = Yes, 2 = No
# Voting additionally contains category 3 = not eligible

main_data_clean$vote_bin <- factor(
  car::recode(main_data_clean$vote, "1 = 1; 2 = 0; 3 = NA"),
  levels = c(0, 1),
  labels = c("No", "Yes")
)

main_data_clean$contplt_bin <- factor(
  car::recode(main_data_clean$contplt, "1 = 1; 2 = 0"),
  levels = c(0, 1),
  labels = c("No", "Yes")
)

# In the original presentation, donprty is the variable used for
# political party/action-group activity.
main_data_clean$donprty_bin <- factor(
  car::recode(main_data_clean$donprty, "1 = 1; 2 = 0"),
  levels = c(0, 1),
  labels = c("No", "Yes")
)

main_data_clean$sgnptit_bin <- factor(
  car::recode(main_data_clean$sgnptit, "1 = 1; 2 = 0"),
  levels = c(0, 1),
  labels = c("No", "Yes")
)

main_data_clean$pbldmna_bin <- factor(
  car::recode(main_data_clean$pbldmna, "1 = 1; 2 = 0"),
  levels = c(0, 1),
  labels = c("No", "Yes")
)

main_data_clean$bctprd_bin <- factor(
  car::recode(main_data_clean$bctprd, "1 = 1; 2 = 0"),
  levels = c(0, 1),
  labels = c("No", "Yes")
)

main_data_clean$pstplonl_bin <- factor(
  car::recode(main_data_clean$pstplonl, "1 = 1; 2 = 0"),
  levels = c(0, 1),
  labels = c("No", "Yes")
)

# Controls
main_data_clean$gender <- factor(
  main_data_clean$gndr,
  levels = c(1, 2),
  labels = c("Male", "Female")
)

main_data_clean$religion_bin <- factor(
  car::recode(main_data_clean$rlgblg, "1 = 1; 2 = 0"),
  levels = c(0, 1),
  labels = c("No", "Yes")
)

# ESS political-interest coding retained:
# 1 = very interested ... 4 = not at all interested
main_data_clean$polintr_ord <- as.numeric(main_data_clean$polintr)

main_data_clean$employment <- factor(main_data_clean$mnactic)

# Germany as reference category for country fixed effects
main_data_clean$cntry <- factor(main_data_clean$cntry)
main_data_clean$cntry <- relevel(main_data_clean$cntry, ref = "DE")

# Regression sample after voting ineligibility and any remaining missingness
regression_vars <- c(
  "trstprl_bin", "trstplt_bin", "trstprt_bin", "trstlgl_bin",
  "vote_bin", "contplt_bin", "donprty_bin",
  "sgnptit_bin", "pbldmna_bin", "bctprd_bin", "pstplonl_bin",
  "gender", "religion_bin", "polintr_ord",
  "agea", "eduyrs", "employment", "cntry"
)

regression_data <- main_data_clean[complete.cases(main_data_clean[, regression_vars]), ]

# The final paper reports N = 6,796 for the logistic regression models.
nrow(regression_data)

# ==============================================================================
# 8. MODEL FORMULAS
# ==============================================================================

main_predictors <- paste(
  "vote_bin + contplt_bin + donprty_bin +",
  "sgnptit_bin + pbldmna_bin + bctprd_bin + pstplonl_bin +",
  "gender + religion_bin + polintr_ord + agea + eduyrs + employment"
)

fixed_predictors <- paste(main_predictors, "+ cntry")

interaction_predictors <- paste(
  "(vote_bin + contplt_bin + donprty_bin +",
  "sgnptit_bin + pbldmna_bin + bctprd_bin + pstplonl_bin) * polintr_ord +",
  "gender + religion_bin + agea + eduyrs + employment + cntry"
)

# ==============================================================================
# 9. LOGISTIC REGRESSION: TRUST IN PARLIAMENT
# ==============================================================================

model_raw_prl <- glm(
  as.formula(paste("trstprl_bin ~", main_predictors)),
  data = regression_data,
  family = binomial
)

model_fixed_prl <- glm(
  as.formula(paste("trstprl_bin ~", fixed_predictors)),
  data = regression_data,
  family = binomial
)

model_interact_prl <- glm(
  as.formula(paste("trstprl_bin ~", interaction_predictors)),
  data = regression_data,
  family = binomial
)

summary(model_raw_prl)
summary(model_fixed_prl)
summary(model_interact_prl)

# Odds ratios and average marginal effects
exp(coef(model_raw_prl))
summary(margins(model_raw_prl))

# ==============================================================================
# 10. LOGISTIC REGRESSION: TRUST IN POLITICIANS
# ==============================================================================

model_raw_plt <- glm(
  as.formula(paste("trstplt_bin ~", main_predictors)),
  data = regression_data,
  family = binomial
)

model_fixed_plt <- glm(
  as.formula(paste("trstplt_bin ~", fixed_predictors)),
  data = regression_data,
  family = binomial
)

model_interact_plt <- glm(
  as.formula(paste("trstplt_bin ~", interaction_predictors)),
  data = regression_data,
  family = binomial
)

summary(model_raw_plt)
summary(model_fixed_plt)
summary(model_interact_plt)

exp(coef(model_raw_plt))
summary(margins(model_raw_plt))

# ==============================================================================
# 11. LOGISTIC REGRESSION: TRUST IN POLITICAL PARTIES
# ==============================================================================

model_raw_prt <- glm(
  as.formula(paste("trstprt_bin ~", main_predictors)),
  data = regression_data,
  family = binomial
)

model_fixed_prt <- glm(
  as.formula(paste("trstprt_bin ~", fixed_predictors)),
  data = regression_data,
  family = binomial
)

model_interact_prt <- glm(
  as.formula(paste("trstprt_bin ~", interaction_predictors)),
  data = regression_data,
  family = binomial
)

summary(model_raw_prt)
summary(model_fixed_prt)
summary(model_interact_prt)

exp(coef(model_raw_prt))
summary(margins(model_raw_prt))

# ==============================================================================
# 12. LOGISTIC REGRESSION: TRUST IN LEGAL SYSTEM
# ==============================================================================

model_raw_lgl <- glm(
  as.formula(paste("trstlgl_bin ~", main_predictors)),
  data = regression_data,
  family = binomial
)

model_fixed_lgl <- glm(
  as.formula(paste("trstlgl_bin ~", fixed_predictors)),
  data = regression_data,
  family = binomial
)

model_interact_lgl <- glm(
  as.formula(paste("trstlgl_bin ~", interaction_predictors)),
  data = regression_data,
  family = binomial
)

summary(model_raw_lgl)
summary(model_fixed_lgl)
summary(model_interact_lgl)

exp(coef(model_raw_lgl))
summary(margins(model_raw_lgl))

# ==============================================================================
# 13. MODEL COMPARISON AND OUTPUT
# ==============================================================================

# Compare AIC values reported in the paper
aic_table <- data.frame(
  Outcome = c("Parliament", "Politicians", "Political Parties", "Legal System"),
  Main = c(
    AIC(model_raw_prl),
    AIC(model_raw_plt),
    AIC(model_raw_prt),
    AIC(model_raw_lgl)
  ),
  FixedEffects = c(
    AIC(model_fixed_prl),
    AIC(model_fixed_plt),
    AIC(model_fixed_prt),
    AIC(model_fixed_lgl)
  ),
  Interaction = c(
    AIC(model_interact_prl),
    AIC(model_interact_plt),
    AIC(model_interact_prt),
    AIC(model_interact_lgl)
  )
)

aic_table

# Optional model tables
# modelsummary(
#   list(
#     "Main" = model_raw_prl,
#     "Country FE" = model_fixed_prl,
#     "Interaction" = model_interact_prl
#   ),
#   stars = TRUE,
#   output = "tables/LR_TrustParliament.xlsx"
# )

# ==============================================================================
# 14. CORRELATION MATRIX
# ==============================================================================

corr_vars <- main_data_clean |>
  select(
    vote, contplt, sgnptit, pbldmna,
    trstprl, trstplt, trstprt, trstlgl
  ) |>
  mutate(across(everything(), as.numeric))

corr_matrix <- cor(corr_vars, use = "pairwise.complete.obs")

corrplot(
  corr_matrix,
  method = "number",
  type = "upper",
  diag = TRUE
)

# ==============================================================================
# 15. EXPLORATORY FACTOR ANALYSIS
# ==============================================================================

# Variables used in the original EFA:
# vote, contact, petition, demonstration,
# trust in parliament, politicians, political parties, and legal system

efa_vars <- main_data_clean[, c(
  "vote", "contplt", "sgnptit", "pbldmna",
  "trstprl", "trstplt", "trstprt", "trstlgl"
)]

efa_vars <- data.frame(lapply(efa_vars, as.numeric))

summary(efa_vars)

# Parallel analysis
fa.parallel(efa_vars, main = "Parallel Analysis EFA")

# Three-factor solution used in the original analysis
fa_initial <- psych::fa(
  efa_vars,
  nfactors = 3,
  rotate = "none",
  scores = "regression"
)

print(fa_initial)
print(fa_initial$loadings, cutoff = 0.00)

# ==============================================================================
# 16. SESSION INFORMATION
# ==============================================================================

sessionInfo()
