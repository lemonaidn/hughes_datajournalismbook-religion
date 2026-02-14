# Data Notes for Faith Dispersion Analysis

## Required Data

To reproduce the findings in McMullen's report, you will need:

### 1. 2020 U.S. Religion Census Data

**Source:** https://www.usreligioncensus.org/

The report analyzes seven non-Christian faith traditions: - Bahá'í Faith (communities) - Buddhism (temples) - Hinduism (temples) - Islam (mosques) - Judaism (synagogues) - Sikhism (gurdwaras) - Zoroastrianism (temples)

**What you need:** - House of worship counts by county for each faith tradition - Metropolitan area identifications to aggregate county-level data

### 2. Gateway City Classifications

The report uses a typology from Singer et al. (2008) that classifies metropolitan areas into six types:

**Established Gateways:** 1. **Former gateways:** Baltimore, Buffalo, Cleveland, Detroit, Milwaukee, Philadelphia, Pittsburgh, St. Louis 2. **Continuous gateways:** Boston, New York/Newark/Jersey City, Chicago, San Francisco 3. **Post-WWII gateways:** Houston, Los Angeles, Riverside/San Bernardino, Orange County, San Diego, Fort Lauderdale, Miami

**21st-Century Gateways:** 4. **Emerging gateways:** Atlanta, Dallas-Fort Worth, Las Vegas, Orlando, West Palm Beach, Washington DC 5. **Re-emerging gateways:** Minneapolis-St. Paul, Denver, Oakland, Phoenix, Portland OR, Sacramento, San Jose, Tampa, Seattle 6. **Pre-emerging gateways:** Raleigh-Durham, Charlotte, Greensboro/Winston-Salem, Salt Lake City, Austin

### 3. Key Definitions

-   **High-concentration area:** A metropolitan area with at least 6 houses of worship for a given faith tradition
-   **Metropolitan area:** The report uses metro areas to aggregate county-level data (you may need to create metro area groupings from county data)

## Suggested Approach

1.  Download the 2020 U.S. Religion Census data for the seven faith traditions
2.  Aggregate county-level data to metropolitan areas
3.  Identify which metro areas have 6+ houses of worship for each faith
4.  Classify those metro areas by gateway type (using the list above)
5.  Calculate the percentage of houses of worship in each gateway category
6.  Compare your results to Tables 1-7 in the report

## Data Challenges

-   The U.S. Religion Census data is organized by county, but the analysis requires metropolitan areas
-   You'll need to either find or create a mapping of counties to metro areas
-   Gateway city classifications are based on Singer et al. (2008) research - the list above provides the cities mentioned in the report
-   Some metro areas may not fall into any gateway category - the report notes that percentages don't add to 100% for this reason
