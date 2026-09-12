# Political Participation and Trust in Political Institutions

## A Comparative Analysis of Germany, Italy, Poland, and Sweden

[![DOI](https://img.shields.io/badge/DOI-10.13140%2FRG.2.2.26675.18722-blue)](https://doi.org/10.13140/RG.2.2.26675.18722)

This project examines the relationship between political participation and trust in political institutions using data from Round 11 of the European Social Survey (ESS).

The analysis compares Germany, Italy, Poland, and Sweden and investigates whether different forms of political participation are associated with citizens' trust in parliament, politicians, political parties, and the legal system.

## Research Questions

1. How are different forms of political participation associated with trust in political institutions?
2. Does the relationship between political participation and institutional trust vary across Germany, Italy, Poland, and Sweden?
3. Does political interest moderate the relationship between political participation and institutional trust?

## Data

The analysis uses **European Social Survey (ESS) Round 11** data for:

- Germany
- Italy
- Poland
- Sweden

The initial sample contained **7,957 respondents**. After data cleaning, **7,286 observations** were retained for descriptive analysis, while the logistic regression models were estimated using **6,796 observations**.

The raw ESS dataset is not distributed through this repository. Information on accessing the data is provided in the `data` directory.

## Variables

### Institutional Trust

Four institutional trust outcomes are examined:

- Trust in parliament
- Trust in politicians
- Trust in political parties
- Trust in the legal system

For the logistic regression analysis, trust scores were classified into:

- **Low trust:** 0–4
- **High trust:** 5–10

### Political Participation

The analysis distinguishes between institutionalised and non-institutionalised forms of political participation.

**Institutionalised participation**

- Voting
- Contacting politicians or public officials
- Political party/action-group activity

**Non-institutionalised participation**

- Signing petitions
- Participating in demonstrations
- Boycotting products
- Online political engagement

## Methods

The analysis was conducted in **R** and includes:

- Descriptive statistics
- Cross-country comparisons
- Kruskal–Wallis tests
- Correlation analysis
- Binary logistic regression
- Country fixed-effects models
- Political-interest interaction models
- Odds ratios and average marginal effects
- Exploratory factor analysis

## Key Findings

Voting and political party activity are consistently associated with higher levels of institutional trust, while online political engagement is consistently associated with lower trust.

Other forms of non-institutionalised participation show mixed relationships across institutional outcomes.

Substantial cross-national differences are also observed. Relative to Germany, Sweden displays higher institutional trust, while Poland displays lower institutional trust after accounting for individual characteristics and political participation.

Greater political interest is associated with higher institutional trust. However, political interest does not consistently moderate the relationship between political participation and trust.

Overall, the findings indicate that the relationship between political participation and institutional trust depends on the **form of participation, the institution being evaluated, and the national context**.

## Repository Structure

```text
├── R/
│   └── political_trust_analysis.R
├── data/
│   └── README.md
├── figures/
├── paper/
│   └── political-participation-institutional-trust.pdf
├── .gitignore
└── README.md
```

## Tools and Skills

- R
- Data cleaning and transformation
- Exploratory data analysis
- Statistical hypothesis testing
- Logistic regression
- Fixed-effects modelling
- Interaction analysis
- Marginal effects
- Exploratory factor analysis
- Data visualisation
- Quantitative policy research

## Authors

This research was conducted collaboratively by:

- Emmanuel Annan
- Caleb Oppong
- Senyo K. Yevugah
- Wilhelmina N. Dodd
- Daniel P. Beatrice
- Dery R. Songnoma
- Benjamin O. Sarpong

**HSE University, Moscow, Russia**

## Citation

Annan, E., Oppong, C., Yevugah, S. K., Dodd, W. N., Beatrice, D. P., Songnoma, D. R., & Sarpong, B. O. (2026). *Political Participation and Trust in Political Institutions: A Comparative Analysis of Sweden, Germany, Poland, and Italy.*

**DOI:** [10.13140/RG.2.2.26675.18722](https://doi.org/10.13140/RG.2.2.26675.18722)

## Reproducibility

The `R` directory contains the reconstructed analysis workflow used for this project. The script was reconstructed from the original project materials after the original standalone R script was no longer available and was aligned with the final paper specification.
