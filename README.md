# multinomial-vs-ordinal-logit-model-comparison
A comparative analysis of the Multinomial and Ordered Logit Models using the APS dataset in SAS, investigating how dataset structure influences optimal model selection.

# Comparative Study: Multinomial vs Ordinal Logit Models
**Language:** SAS  
**Institution:** University of Pretoria  
**Year:** 2024  
**Author:** Siyabonga Mahlangu  

---

## Research Question
Does the nature of a dataset (nominal or ordinal response 
variable) affect the choice of model selection between the 
Multinomial Logit Model and the Ordered Logit Model?

---

## Dataset
**APS (Adolescent Placement Study)**  
- 508 observations  
- 11 explanatory variables  
- 3-category ordinal response variable (Outpatient, 
  Intermediate Residential, Residential Patient)  

---

## Methods Used
- Binary Logit Model (baseline)
- Multinomial Logit Model (PROC LOGISTIC with GLOGIT link)
- Ordered Logit Model (PROC LOGISTIC with proportional 
  odds assumption)
- Proportional Odds Assumption Testing (Wald Test, 
  Score Test, Mosaic Plots)
- Model Evaluation: AIC, BIC, Deviance, 
  Pearson Chi-Square
- Predicted Probability Plots (Effect Plots)
- Odds Ratio Estimation

---

## Key Finding
The proportional odds assumption of the Ordinal Logit 
Model was violated when all explanatory variables were 
included — specifically driven by variables with 
extremely high odds ratios (CUSTD, LOSGRP, BEHAV).

After removing these variables, the assumption held, 
but at the cost of model completeness. The Multinomial 
Logit Model was therefore determined to be the more 
appropriate model for this dataset due to its 
flexibility and superior interpretability of all 
explanatory variables.

---

## Insightful Secondary Finding
Variables with very high odds ratios in the Multinomial 
Logit Model directly impacted the proportional odds 
assumption in the Ordinal Logit Model — suggesting that 
odds ratio magnitude can serve as an early diagnostic 
indicator of assumption violations.

---

## Files
- `analysis.sas` — Full SAS code including PROC FREQ, 
  PROC LOGISTIC, PROC IML, and effect plots
- `report.pdf` — Full research report with derivations, 
  results, and conclusions

---

## Tools & Procedures Used
- PROC FREQ — descriptive statistics and cross tabulations
- PROC LOGISTIC — model fitting and parameter estimation
- PROC IML — probability estimation in multinomial case
- Maximum Likelihood Estimation (MLE)
- Newton-Raphson Optimisation

---

## How to Run
1. Load the APS dataset into SAS
2. Run `analysis.sas` sequentially
3. Outputs include parameter estimates, odds ratios, 
   goodness-of-fit statistics, and predicted 
   probability plots
