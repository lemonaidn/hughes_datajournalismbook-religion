# Data Notes for Religious Diversity Assignment

## Required Data Files

Students will need to download and prepare data from the 2020 U.S. Religion Census:

### Primary Data Source

**2020 U.S. Religion Census**
- Website: https://www.usreligioncensus.org/
- Navigate to "Data & Maps" section
- Download county-level data files

### Required Data Tables

Students should look for the following data on the U.S. Religion Census website:

1. **County-level adherent data by religious body**
   - Contains counts of adherents for each religious denomination in each county
   - Typically available as CSV or Excel download
   - File may be named something like "2020_US_Religion_Census_county_data.csv"

2. **Religious body classifications**
   - Mapping of individual religious bodies to:
     - World religions (6 categories)
     - Religious families (43 categories)
     - American religious traditions (13 categories)
   - May be in a separate classification file or embedded in the main data

3. **Congregation counts**
   - Number of congregations (churches, mosques, temples, etc.) for each religious body in each county
   - May be in the same file as adherent data or separate

4. **Population data**
   - County-level total population (for calculating unaffiliated)
   - Can also be obtained from U.S. Census Bureau if not included

### Additional Data Needed

**Metropolitan Statistical Areas (MSAs)**
- Office of Management and Budget (OMB) delineations
- Counties that comprise each MSA
- 2020 population of each MSA to identify those with 1 million+
- Available from: https://www.census.gov/programs-surveys/metro-micro.html

## Data Processing Steps

Students will need to:

1. **Load county-level data**
   - Read religious adherent counts by county
   - Read congregation counts by county
   - Merge with county population data

2. **Calculate unaffiliated population**
   - Sum all religious adherents in each county
   - Subtract from total county population
   - This becomes the "unaffiliated" category

3. **Apply religious classifications**
   - Group individual religious bodies into the different categorization schemes:
     - 6 world religions
     - 43 religious families
     - 13 American religious traditions
   - Sum adherents within each category for each county

4. **Aggregate to metropolitan areas**
   - Use MSA-to-county crosswalk
   - Sum adherents across all counties in each MSA
   - Filter to MSAs with 1 million+ population (56 total in 2020)

5. **Aggregate to states**
   - Sum adherents across all counties in each state
   - Calculate percentages and diversity indices

6. **Calculate Simpson's Diversity Index**
   - For each geographic unit (county, metro, state)
   - For each categorization scheme (world religions, families, traditions, traditions+unaffiliated)
   - Apply the formula: D = 1 - ∑(n/N)²

## Potential Data Challenges

- **File size**: County-level data for 3,100+ counties and 300+ religious bodies can be large
- **Missing data**: Some religious bodies may not have reported adherent counts
- **Geographic matching**: Matching counties to metros requires careful crosswalk
- **Classification consistency**: Ensuring religious bodies are classified consistently across schemes
- **Unaffiliated calculation**: Making sure total adherents don't exceed total population

## Data Structure Suggestion

Students may find it helpful to create data frames like:

```r
# County-level data with 13 traditions + unaffiliated
county_diversity <- data.frame(
  fips = character(),           # County FIPS code
  county_name = character(),
  state = character(),
  total_pop = numeric(),
  black_protestant = numeric(),
  buddhist = numeric(),
  catholic = numeric(),
  evangelical = numeric(),
  hindu = numeric(),
  islam = numeric(),
  jewish = numeric(),
  jehovahs_witnesses = numeric(),
  lds = numeric(),
  mainline = numeric(),
  orthodox = numeric(),
  other_christian = numeric(),
  other_eastern = numeric(),
  unaffiliated = numeric(),
  diversity_index = numeric()
)
```

## Instructors: Preparing the Data

Because the data structure and availability on usreligioncensus.org may vary, instructors may want to:

1. Visit the website and identify the specific files students should download
2. Create a data preparation script that downloads and processes the data
3. Provide processed data files to students with the necessary aggregations
4. Update the assignment with specific file names and download instructions

The assignment is designed to be flexible - students can work with raw downloads or pre-processed files depending on the learning objectives and time available.
