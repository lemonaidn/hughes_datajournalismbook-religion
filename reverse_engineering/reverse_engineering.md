# Reverse Engineering Assignments

This assignment asks you to read a published data story or report, then use R to reproduce key quantitative findings. You'll practice counting, calculating percentages, computing averages and making comparisons — the basic building blocks of data journalism.

Pick one of the following stories to reverse engineer.

------------------------------------------------------------------------

## 1. Evangelical Protestants Are The Biggest Winners When People Change Faiths

**By Leah Libresco, FiveThirtyEight (2015)**

Using Pew's 2014 Religious Landscape Study, this story models what America's religious demographics would look like if current faith-switching rates continued indefinitely. Evangelical Protestants come out as the biggest winners — they retain members better than other groups and attract the most converts — while Catholics would lose more than half their current share.

[**Read the story**](changing-faiths.html)

**Data:** CSV files derived from Pew's Religious Landscape Study, including a transition matrix showing the probability of switching between 12 religious traditions, each tradition's initial population share, fertility rates by group, and a simulation of how those shares change over 100 iterations.

------------------------------------------------------------------------

## 2. The Assemblies of God in 2024

**By Ryan Burge, Graphs About Religion (2025)**

This piece tracks the Assemblies of God denomination using its own annual statistical reports, covering membership, worship attendance, conversions and racial composition from the mid-1970s through 2024. The AG is one of the few large U.S. Protestant denominations posting steady long-term growth, and its racial makeup now closely mirrors the general U.S. population.

[**Read the story**](assemblies-of-god.html)

**Data:** Four CSV files from the Assemblies of God's annual statistical reports: yearly membership totals (1975-2024), yearly worship attendance (1978-2024), racial/ethnic composition over time, and conversion/baptism counts by type (2020-2024).

------------------------------------------------------------------------

## 3. Money and Leadership in the Presbyterian Church in America

**By Ryan Burge, Graphs About Religion (2026)**

Using detailed statistical data covering more than 1,700 PCA congregations, this story examines how many elders and deacons a church should have relative to its size, what normal per-capita giving looks like, and how expenses and savings rates vary by congregation size.

[**Read the story**](pca-stats.html)

**Data:** A CSV file with one row per PCA congregation (1,741 churches), including total members, number of ruling elders and deacons, tithes and offerings, building fund contributions, total income, current expenses and per capita giving.

------------------------------------------------------------------------

## 4. The People Streaming Church Aren't Who You Think

**By Ryan Burge, Graphs About Religion (2026)**

Using the Pew Religious Landscape Study, this story reveals a counterintuitive pattern: college-educated Americans are more likely to attend church in person, but Americans with only a high school diploma are nearly twice as likely to stream religious services online weekly. Online worship has become most common among lower-education, lower-income Americans.

[**Read the story**](streaming-church.html)

**Data:** A CSV file drawn from the Pew Religious Landscape Study (\~37,000 respondents) with variables for in-person attendance frequency, online streaming frequency, education level, household income, race and birth decade.

------------------------------------------------------------------------

## 5. The Most Republican Jobs in America? Start with the Church

**By Ryan Burge, Graphs About Religion (2025)**

Drawing on VRScores — a database linking voter registration records to employment data — this piece finds that people employed by religious organizations are the most Republican of any large employment sector in the U.S. It compares partisan lean across Muslim, Jewish and Christian employers, and across individual Protestant denominations.

[**Read the story**](partisan-jobs.html)

**Data:** A CSV file combining VRScores panel data from 2012-2020, with one row per NAICS industry code per year, including the number of workers, Republican share and Democratic share for each industry.

------------------------------------------------------------------------

## 6. When Are Half Your Members Going to Be Dead?

**By Ryan Burge, Graphs About Religion (2026)**

Using the 2024 Cooperative Election Study, this story maps the age distributions of the 20 largest U.S. Protestant denominations, calculating mean ages, Baby Boomer shares, and the projected year each denomination will lose half its current members. The central warning: most major denominations are being propped up by the Baby Boom generation and will face rapid decline once that cohort ages out.

[**Read the story**](going-dead.html)

**Data:** A CSV file from the 2024 Cooperative Election Study (approximately 60,000 respondents) with survey weights, birth year, and detailed Protestant denomination codes (Baptist, Methodist, Lutheran, Presbyterian, Pentecostal, etc.).

------------------------------------------------------------------------

## 7. Religious Diversity in the United States

**By Dale E. Jones, 2020 U.S. Religion Census**

This report applies Simpson's Diversity Index to 2020 U.S. Religion Census data to measure religious diversity at the county, metro and state levels. It finds, for example, that Los Angeles County has the most religious bodies (171) of any county, that New Hampshire has the highest percentage of religiously unaffiliated residents (73%), and that Utah is the least religiously diverse state.

[**Read the report**](ReligiousDiversity-Jones.pdf)

**Data:** Two Excel files from the 2020 U.S. Religion Census. The Group Detail file has congregation and adherent counts for each of 450+ religious groups at the national, state, county and metro levels. The Summaries file has total population and aggregate religious adherent counts at each geographic level.

------------------------------------------------------------------------

## 8. The Rise and Geographic Dispersion of Non-Christian Faith Traditions

**By Mike McMullen, 2020 U.S. Religion Census**

This report examines seven non-Christian faith traditions — Baha'i, Buddhism, Hinduism, Islam, Judaism, Sikhism and Zoroastrianism — and how they have spread across U.S. metropolitan areas classified by "gateway city" type. It finds that older faiths like Judaism remain concentrated in established gateways (New York, Chicago, Boston), while newer immigrant faiths like the Baha'i are more dispersed into 21st-century gateway cities.

[**Read the report**](DispersionNonChristianFaith-McMullen.pdf)

**Data:** Two Excel files from the 2020 U.S. Religion Census. The Group Detail file has congregation and adherent counts for each of 450+ religious groups at the national, state, county and metro levels. The Summaries file has total population and aggregate religious adherent counts at each geographic level.

------------------------------------------------------------------------

## 9. Why Religion, Not Income, Predicts the American Vote

**By Ryan Burge, Graphs About Religion (2026)**

Using the 2024 Cooperative Election Study, this story demonstrates that household income has almost no predictive power over how Americans vote once religious tradition is accounted for. A Southern Baptist and an atheist with the same income are separated by roughly 60 percentage points in their likelihood of voting Republican.

[**Read the story**](predicting-vote.html)

**Data:** A CSV file derived from the 2024 Cooperative Election Study (\~45,000 post-election respondents) with survey weights, broad religious tradition (e.g. White Evangelical, Black Protestant, Jewish, Atheist), household income on a 1-16 scale, 7-point party identification, 2024 presidential vote choice, race and education level.
