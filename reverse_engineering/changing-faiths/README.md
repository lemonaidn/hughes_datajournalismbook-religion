# Reverse Engineering: Changing Faiths

This assignment uses data from Pew Research Center's 2014 Religious Landscape Study to reproduce findings from FiveThirtyEight's analysis "Evangelical Protestants Are The Biggest Winners When People Change Faiths" by Leah Libresco.

## Data Files

All data files are included in the `data/` folder. These files come from FiveThirtyEight's GitHub repository and represent their processed version of the Pew Religious Landscape Study data.

### Files Included

1. **transition_matrix.csv** - A 12x12 matrix showing the probability that someone raised in one religion (rows) ends up in another religion (columns) as an adult. Each row sums to approximately 1.0.

2. **initial_distribution.csv** - The starting share of each religion in the U.S. population (the proportion of Americans raised in each tradition).

3. **fertility_rates.csv** - Average number of children per woman for each religious group.

4. **current.csv** - The output of FiveThirtyEight's Python simulation showing how the religious distribution evolves over 101 iterations as the model approaches equilibrium.

### The 12 Religious Categories

- Buddhist
- Catholic
- Evangelical Protestant
- Hindu
- Historically Black Protestant
- Jehovah's Witness
- Jewish
- Mainline Protestant
- Mormon
- Muslim
- Orthodox Christian
- Unaffiliated

## For Students

Work through the `reverse_engineering_02.Rmd` notebook. Read the FiveThirtyEight article (saved as an HTML file in this folder), identify the key facts and claims, and write your own code to reproduce those findings.

## Original Data Source

The original FiveThirtyEight analysis and data: https://github.com/fivethirtyeight/data/tree/master/pew-religions

The underlying Pew Research data: https://www.pewresearch.org/religion/religious-landscape-study/
