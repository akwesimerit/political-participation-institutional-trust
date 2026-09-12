# Data Documentation

## Data Source

This project uses data from **Round 11 of the European Social Survey (ESS)**.

The European Social Survey is a cross-national survey that collects data on attitudes, beliefs, behaviours, and demographic characteristics across European populations.

For this study, the analysis is restricted to respondents from:

- Germany
- Italy
- Poland
- Sweden

## Dataset

**Dataset:** European Social Survey Round 11  
**Edition:** 3.0  
**Reference period:** 2023/2024  
**Data provider:** European Social Survey European Research Infrastructure (ESS ERIC)

The initial analytical dataset contained **7,957 respondents** across the four selected countries.

After complete-case data cleaning, **7,286 observations** were retained for the descriptive analysis.

The logistic regression models were estimated using **6,796 observations** after accounting for additional exclusions and missing information required for the regression specification.

## Variables Used

### Institutional Trust

The study examines four institutional trust variables:

| ESS Variable | Description |
|---|---|
| `trstprl` | Trust in country's parliament |
| `trstplt` | Trust in politicians |
| `trstprt` | Trust in political parties |
| `trstlgl` | Trust in the legal system |

The original trust variables are measured on a **0–10 scale**.

For binary logistic regression, the variables were recoded as:

- **0–4 = Low trust**
- **5–10 = High trust**

### Political Participation

The analysis examines institutionalised and non-institutionalised forms of political participation.

| ESS Variable | Description |
|---|---|
| `vote` | Voting in the most recent national election |
| `contplt` | Contacting a politician or government official |
| `donprty` | Political party/action-group activity used in the analysis |
| `sgnptit` | Signing a petition |
| `pbldmna` | Taking part in a lawful public demonstration |
| `bctprd` | Boycotting certain products |
| `pstplonl` | Posting or sharing political content online |

### Political Interest

| ESS Variable | Description |
|---|---|
| `polintr` | Interest in politics |

The ESS coding is:

1. Very interested  
2. Quite interested  
3. Hardly interested  
4. Not at all interested  

Higher numerical values therefore represent **lower political interest**.

### Control Variables

The analysis also includes demographic and individual-level controls, including:

| ESS Variable | Description |
|---|---|
| `agea` | Age |
| `gndr` | Gender |
| `eduyrs` | Years of full-time education |
| `rlgblg` | Belonging to a religion or denomination |
| `mnactic` | Main activity/employment status |
| `cntry` | Country |

## Countries

Country codes used in the R analysis are:

| Code | Country |
|---|---|
| `DE` | Germany |
| `IT` | Italy |
| `PL` | Poland |
| `SE` | Sweden |

Germany (`DE`) is used as the reference category in the country fixed-effects regression models.

## Data Access

The raw ESS Round 11 dataset is **not included in this GitHub repository**.

Researchers wishing to reproduce the analysis should obtain the appropriate ESS Round 11 dataset directly from the **European Social Survey Data Portal**:

https://www.europeansocialsurvey.org/data-portal

After obtaining the dataset, place the required data file in the local `data/` directory and update the import path in the R script where necessary.

## Reproducibility

The analysis workflow is available in:

```text
R/political_trust_analysis.R
```

The script covers:

- Data selection and cleaning
- Variable recoding
- Descriptive analysis
- Kruskal–Wallis tests
- Correlation analysis
- Binary logistic regression
- Country fixed-effects models
- Political-interest interaction models
- Odds ratios and average marginal effects
- Exploratory factor analysis

## Data Citation

European Social Survey European Research Infrastructure (ESS ERIC). (2025). *European Social Survey Round 11 data (2023/24), Edition 3.0*. ESS ERIC.

## Research Output

The accompanying research paper is available under the following DOI:

**https://doi.org/10.13140/RG.2.2.26675.18722**
