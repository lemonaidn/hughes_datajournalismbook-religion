# Reverse Engineering: Money and Leadership in the Presbyterian Church in America

## About This Assignment

This reverse engineering assignment is based on Ryan Burge's analysis ["Money and Leadership in the Presbyterian Church in America"](https://www.graphsaboutreligion.com/p/money-and-leadership-in-the-presbyterian) published on January 1, 2026.

The analysis examines financial and leadership patterns across over 1,700 Presbyterian Church in America (PCA) congregations using 2024 statistical reports. The article explores practical questions that church leaders care about: How many people should serve in leadership roles? What's a normal giving rate per member? How do church size and finances relate?

## The Data

The data comes from the PCA's annual statistical reports submitted by each congregation. The dataset (`pca_stats.xlsx`) includes:

- **Membership data**: Communicant members, non-communicant members, total membership
- **Leadership**: Number of ruling elders and deacons
- **Financial data**: Tithes & offerings, total church income, current expenses, building fund contributions
- **Additions and losses**: New members, deaths, transfers, removals
- **Attendance**: Estimated morning attendance, Sunday school, small groups
- **Disbursements**: Benevolent giving, operational expenses

Key calculated fields mentioned in the article:
- **Per capita giving**: Total tithes & offerings divided by total members
- **Expense ratio**: Current expenses divided by total church income
- **Leadership ratio**: Total members divided by total leaders (elders + deacons)

## Replicable Findings to Reverse Engineer

Using the techniques covered in class (filtering, grouping, summarizing, calculating new columns), try to replicate these findings from the article:

### Finding 1: Leadership Patterns by Church Size
**Claim**: "In the very smallest churches, you'll usually find about three people serving in formal leadership roles. That number rises to around four deacons and elders in churches with 26–50 members... A church with 100–250 members averages about ten leaders, and among the largest PCA churches, that number climbs to roughly 37."

**What to verify**:
- Calculate average total leaders (ruling elders + deacons) for different church size categories
- Size categories: very small (0-25), 26-50, 51-100, 100-250, 500+
- Does the ratio between deacons and elders stay consistent (roughly 1:1) across all sizes?

### Finding 2: Leader-to-Member Ratio
**Claim**: "Across the entire sample, the average church has one leader for every twenty members."

**What to verify**:
- Calculate total leaders per church (ruling elders + deacons)
- Divide total members by total leaders to get the ratio
- Calculate the mean ratio across all churches
- How does this ratio change by church size?

### Finding 3: Very Small Churches Have Higher Leadership Ratios
**Claim**: "In a really small church, there's often one elder or deacon for every seven members."

**What to verify**:
- Filter to churches with 20 or fewer members
- Calculate the leader-to-member ratio for this group
- Compare to larger churches

### Finding 4: Per Capita Giving Distribution
**Claim**: "About 7% have a per-capita giving rate below $1,000 per person... about 5% of PCA congregations" have giving above $7,000. "The most common range is $2,000 to $4,000 per member, which includes nearly half of all congregations."

**What to verify**:
- Calculate what percentage of churches have per capita giving below $1,000
- Calculate what percentage have per capita giving above $7,000
- Calculate what percentage fall between $2,000 and $4,000
- What is the median per capita giving?

### Finding 5: Per Capita Giving by Church Size
**Claim**: "Per-capita giving is about $3,500 per person in smaller congregations and rises only to around $3,850 among those at the upper end—a bump of roughly 10%." The largest churches have "about $4,343 per person."

**What to verify**:
- Calculate mean per capita giving for churches in different size categories
- Compare small (26-50 members) to medium (100-250 members) to very large (500+ members)
- Does the data support these specific dollar amounts?

### Finding 6: Expense-to-Income Ratio
**Claim**: "Across the average PCA church, about 86% of all income goes out through current expenses."

**What to verify**:
- Calculate the ratio of current expenses to total church income
- What is the mean expense ratio across all churches?
- Filter out churches with missing or zero income to avoid skewing results

### Finding 7: Small Churches Spend More Than They Earn
**Claim**: "Small churches are spending more than they're taking in. In fact, their expenses exceed their income by nearly 30%."

**What to verify**:
- Filter to the smallest churches (e.g., under 25 members)
- Calculate current expenses divided by total church income
- Do these churches have an expense ratio above 100%? How far above?

### Finding 8: Large Churches Save More
**Claim**: "Among churches with at least 500 members, every three dollars that comes in translates to just two dollars going out for expenses. That's a savings rate north of 30%."

**What to verify**:
- Filter to churches with 500+ members
- Calculate the expense-to-income ratio
- Is it around 0.67 (two-thirds) or lower?
- What is the average savings rate (1 - expense ratio) for these large churches?

### Finding 9: Building Fund Prevalence
**Claim**: "Exactly one-third of all PCA churches had a line item for building funds."

**What to verify**:
- Count how many churches have a building fund offering greater than $0 (or not NA)
- Calculate what percentage this represents of all churches
- Is it close to 33%?

### Finding 10: Growth and Building Funds
**Claim**: "About 34% of churches that reported more subtractions than additions in the prior year still contributed to a building fund. Among those that grew in the past year, the figure was 41%."

**What to verify**:
- Calculate net change for each church (total additions minus total losses)
- For churches with negative net change, what percentage have building funds?
- For churches with positive net change, what percentage have building funds?
- How do these percentages compare to the article's claims?

## Notes on Data Preparation

The Excel file needs some cleaning:
- Skip the first 2 rows when reading to get proper headers
- The "Total" column (column 9) represents total membership
- "Ruling Elders" and "Deacons" are separate columns (24 and 25)
- Some churches have missing data (NA values) for various fields
- You'll need to filter out rows with missing key data for certain analyses

## Assignment Goals

The goal is to practice:
1. Reading data from Excel files
2. Filtering data based on conditions
3. Grouping data by categories (church size bins)
4. Calculating summary statistics (mean, median, percentages)
5. Creating new calculated columns (ratios, totals)
6. Interpreting results and comparing to published findings

This is real data about a real denomination, and these are practical questions that church leaders genuinely care about. Your analysis could help inform decision-making about staffing, budgeting, and church growth strategies.
