# Reverse Engineering: Streaming Church

This assignment uses data from Pew Research Center's 2023-24 Religious Landscape Study to reproduce findings from Ryan Burge's analysis "The People Streaming Church Aren't Who You Think."

## For Instructors: Data Preparation

The data file has been created from the full RLS 2023-24 Public Use File. If you need to regenerate it or update it:

### Steps to Prepare Data

1. Obtain the 2023-24 RLS Public Use File from Pew Research Center:
   - Download from: https://www.pewresearch.org/religion/dataset/2023-24-religious-landscape-study/
   - Save the SPSS file (.sav) in an accessible location

2. Update the path in `data_prep.R`:
```r
# Line 17: Adjust this path to where you have the RLS data stored
rls_full <- read_sav("~/code/rlsdata/2023-24 RLS Public Use File Feb 19.sav")
```

3. Run the data preparation script:
```r
source("data_prep.R")
```

This will create `data/rls_streaming.csv` with only the variables students need.

## Data File

The processed CSV file (`rls_streaming.csv`) contains 36,908 respondents with the following variables:

- **weight**: Survey weight for representative estimates
- **attndperrls**: In-person religious service attendance frequency (1-6 scale)
- **attndonrls**: Online/TV religious service attendance frequency (1-6 scale)
- **educrec**: Education level (1-4 scale)
- **inc_sdt1**: Household income (1-8 scale)
- **hisp**: Hispanic identification (1-2)
- **racecmb**: Race combined (1-5)
- **gender**: Gender (1-2)
- **birthdecade**: Birth decade (1-7, representing 1940s-2000s)

## For Students

Work through the `reverse_engineering_streaming.Rmd` notebook. Read the article (saved as an HTML file in this folder), identify the key facts and claims, and write your own code to reproduce those findings.

## Original Article

"The People Streaming Church Aren't Who You Think" by Ryan Burge, published on Graphs About Religion (https://www.graphsaboutreligion.com/)

The article challenges assumptions about online church attendance, showing that education, not just technology access, plays a key role in who streams services.

## Data Source

Pew Research Center's 2023-24 Religious Landscape Study
- Over 36,000 U.S. adults surveyed
- Conducted 2023-2024
- Public use file released February 2025
- More information: https://www.pewresearch.org/religion/religious-landscape-study/
