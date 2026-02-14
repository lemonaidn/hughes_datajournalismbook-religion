# Reverse Engineering: Religion and Voting

This assignment uses data from the 2024 Cooperative Election Study (CES) to reproduce findings from Ryan Burge's analysis "Why Religion, Not Income, Predicts the American Vote."

## For Instructors: Data Preparation

The data file is **not** included in this repository due to its size and licensing. You must download and prepare it before distributing this assignment to students.

### Steps to Prepare Data

**IMPORTANT:** As of February 2026, the CES 2024 data may not yet be available on Harvard Dataverse, or the file structure may have changed. Follow these steps:

#### Option 1: Use the data_prep.R script (if CES 2024 is available)

1. Install required packages:
```r
install.packages(c("dataverse", "tidyverse", "haven"))
```

2. Check if the CES 2024 data is available at: https://dataverse.harvard.edu/dataset.xhtml?persistentId=doi:10.7910/DVN/X11EP6

3. If available, run the `data_prep.R` script from this folder:
```r
setwd("reverse_engineering/predicting-vote")
source("data_prep.R")
```

This script will:
- Download the CES 2024 Common Content from Harvard Dataverse
- Create religious tradition categories following Ryan Burge's coding scheme
- Select only the variables students need for the assignment
- Save two files in the `data/` folder:
  - `ces_2024_religion.rds` (preferred format, preserves data types)
  - `ces_2024_religion.csv` (for inspection/backup)

4. Distribute the `ces_2024_religion.rds` file to students by placing it in their `data/` folder

#### Option 2: Use CES 2022 data instead

If CES 2024 is not available, you can modify the script to use CES 2022 data:

1. In `data_prep.R`, change line 24 to:
```r
ces2024_raw <- get_dataframe_by_name(
  filename = "CCES22_Common_OUTPUT.dta",
  dataset = "doi:10.7910/DVN/PR4L8P",
  .f = haven::read_dta,
  original = TRUE
)
```

2. Change line 48 to use the 2022 vote variable:
```r
vote_2024 = CC22_410,  # Change to CC22_410 for 2022 data
```

3. Update references to "2024" throughout the assignment to "2022"

#### Option 3: Manual download

1. Go to the CES data repository: https://cces.gov.harvard.edu/
2. Download the most recent Common Content file
3. Manually run the data processing steps from `data_prep.R` in your R session
4. Save the output to the `data/` folder

### Data File Size

The processed RDS file is approximately 5-10 MB (depending on the final CES 2024 release). The original CES dataset is much larger (~500 MB).

### Alternative: Use Pre-2024 CES Data

If the 2024 CES is not yet available, you can modify `data_prep.R` to use CES 2020 or 2022 data instead. The variable names are similar across years. You'll need to update:
- The DOI/filename for the different year
- The vote variable name (e.g., `CC20_410` for 2020, `CC22_410` for 2022)
- References to 2024 in the assignment text

## For Students

Once your instructor has provided the data file, place it in the `data/` folder and work through the `reverse_engineering.Rmd` notebook.
