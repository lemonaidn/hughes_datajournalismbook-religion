# Reverse Engineering: Religious Diversity in the United States

This assignment uses data from the 2020 U.S. Religion Census to reproduce findings from Dale E. Jones's analysis "Religious Diversity in the United States."

## Data Source

The 2020 U.S. Religion Census
- Collected by the Association of Statisticians of American Religious Bodies (ASARB)
- Data aggregated at the county level
- Over 450 denominations and faith groups included
- Available at: https://www.usreligioncensus.org/

## For Students

Read the report (saved as a text file: ReligiousDiversity-Jones1.txt), identify the key quantitative facts and claims (focusing on replicable sentences, not the maps), and write well-commented code to reproduce those findings using the 2020 U.S. Religion Census data.

## Original Report

"Religious Diversity in the United States" by Dale E. Jones, published in the 2020 U.S. Religion Census report.

The report examines religious diversity across U.S. counties, metropolitan areas, and states using Simpson's Diversity Index applied to different categorizations of religious groups.

## Key Concepts

- **Simpson's Diversity Index**: A mathematical measure that considers both the number of different groups and their relative sizes. The formula is D = 1 - ∑(n/N)², where n is the number in each category and N is the total. The index ranges from 0 (no diversity) to 1 (maximum diversity).

- **Religious Categories**: The report uses several classification schemes:
  - 372 individual religious bodies (congregations)
  - 215 religious bodies (adherents)
  - 6 world religions (Bahá'í, Buddhist, Christian, Hindu, Islam, Jewish)
  - 43 religious families (historical groupings)
  - 13 American religious traditions (Black Protestant, Buddhist, Catholic, Evangelical Protestant, Hindu, Islam, Jewish, Jehovah's Witnesses, Latter-day Saints, Mainline Protestant, Orthodox Christian, Other Christian, Other Eastern)
  - 13 traditions + unaffiliated (treating unaffiliated as a 14th category)

- **Geographic Units**: Counties, metropolitan areas (1 million+ population), and states

## Reproducible Findings to Verify

The report contains numerous specific claims that can be verified with data. Focus on these types of findings:

### Specific Numerical Claims

1. **County-level statistics**:
   - Los Angeles County has 171 religious bodies
   - Catholics are 62% of all adherents in Los Angeles County

2. **Metropolitan area statistics**:
   - New York-Newark-Jersey City metro has 198 religious bodies
   - Catholics are 61% of the New York metropolitan area's adherents
   - 20 of 56 largest metro areas rank in the top 20% of counties for diversity
   - Only 2 metros would rank with moderate diversity
   - None would be categorized with the least diverse counties

3. **State-level statistics**:
   - Pennsylvania has 245 religious bodies
   - Catholics are 47% of Pennsylvania's religious adherents
   - Two-thirds of the population in Oregon, New Hampshire, and Maine are not claimed by any religious group
   - Utah: 65% claimed by Latter-day Saints
   - Alaska: 65% unaffiliated
   - Oregon: 67% unaffiliated
   - Maine: 69% unaffiliated
   - New Hampshire: 73% unaffiliated

4. **Metropolitan area rankings** (Table 1):
   - Memphis, TN-MS-AR is the most religiously diverse metro (1 million+)
   - Denver-Aurora-Lakewood, CO is the least religiously diverse metro (1 million+)
   - Denver: two-thirds unaffiliated, nearly half the remaining population is Catholic (nearly 90% in just two groups)
   - Salt Lake City: half claimed by Latter-day Saints, one-third unaffiliated
   - Memphis: one-third unaffiliated, one-third Evangelical Protestant, one-sixth Black Protestant, with Mainline Protestants and Catholics each at 5%

5. **State rankings** (Table 2):
   - Most diverse: Louisiana (37% unaffiliated, 27% Catholic, 25% Evangelical Protestant)
   - 2nd: South Carolina (45% unaffiliated, 20% Evangelical Protestant, 18% Mainline Protestant)
   - 3rd: Texas (45% unaffiliated, 24% Evangelical Protestant, 20% Catholic)
   - 4th: North Dakota (45% unaffiliated, 21% Catholic, 21% Mainline Protestant)
   - 5th: Idaho (47% unaffiliated, 25% Latter-day Saints, 12% Evangelical Protestant)
   - Least diverse states: Alaska (65% unaffiliated), Oregon (67% unaffiliated), Utah (65% Latter-day Saints), Maine (69% unaffiliated), New Hampshire (73% unaffiliated)

6. **District of Columbia**:
   - Would be the most diverse if it were a state
   - 44% unaffiliated
   - Four other groups each claim at least 10%: Evangelical Protestants (15%), Catholics (12%), Black Protestants (10%), Mainline Protestants (10%)

7. **World religions diversity**:
   - Highest diversity based on world religions is only 0.51
   - This compares to 0.62 needed to reach "moderate diversity" on the all religious bodies scale
   - Seven additional world religions reported congregational locations but were unable to provide adherent figures

## Data Preparation

Students will need to:

1. Download the 2020 U.S. Religion Census data from usreligioncensus.org
2. Identify the different categorization schemes (religious traditions, families, world religions)
3. Calculate the unaffiliated population for each geographic area (total population minus total adherents)
4. Identify the 56 metropolitan areas with populations of 1 million or more in 2020
5. Implement Simpson's Diversity Index calculation

## Methodology Notes

### Simpson's Diversity Index Formula

The formula is: D = 1 - ∑(n/N)²

Where:
- N = total number of instances (e.g., total adherents in a county)
- n = instances in each category (e.g., Catholic adherents in that county)
- For each category, divide n by N, square the result, then sum all squared results
- Subtract this sum from 1 to get the diversity index

The index ranges from 0 (no diversity) to 1 (maximum diversity). The report uses this consistently across all categorizations.

### Unaffiliated Population

The report treats the unaffiliated population as a 14th religious category when using the 13 American religious traditions classification. The unaffiliated are calculated as total population minus total religious adherents claimed by congregations in the census.

## Challenges to Expect

- The diversity index depends heavily on the categorization scheme used
- Comparing index values across different categorization schemes is not recommended
- Metropolitan area definitions are based on county units
- Some religious bodies reported congregations but not adherent counts
- The data requires careful aggregation at different geographic levels
