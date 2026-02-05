# Data Preparation Script for Reverse Engineering Assignment
# "Why Religion, Not Income, Predicts the American Vote"
#
# INSTRUCTOR USE ONLY - Students should not need to run this script.
# This downloads the CES 2024 Common Content from Harvard Dataverse,
# selects relevant variables, creates a broad religious tradition variable,
# and saves a filtered RDS file for student use.
#
# Requirements:
#   install.packages(c("dataverse", "tidyverse", "haven"))
#
# The output file (ces_2024_religion.rds) should be placed in
# reverse_engineering/data/ before distributing the assignment.

library(tidyverse)
library(dataverse)
library(haven)

# Set Dataverse server
Sys.setenv("DATAVERSE_SERVER" = "dataverse.harvard.edu")

# Download CES 2024 Common Content
# DOI: 10.7910/DVN/X11EP6
ces2024_raw <- get_dataframe_by_name(
  filename = "CCES24_Common_OUTPUT.dta",
  dataset = "doi:10.7910/DVN/X11EP6",
  .f = haven::read_dta,
  original = TRUE
)

# Select variables needed for the assignment
ces2024 <- ces2024_raw |>
  select(
    caseid,
    weight = commonpostweight,
    religpew,
    religpew_baptist,
    religpew_nondenom,
    religpew_methodist,
    religpew_pentecost,
    religpew_episcop,
    religpew_presby,
    religpew_lutheran,
    religpew_congreg,
    income = faminc_new,
    educ,
    pid7,
    vote_2024 = CC24_410,
    race
  )

# Create broad religious tradition categories
# This follows a simplified version of the coding used in Ryan Burge's analysis.
# The key distinctions are between major Protestant traditions (evangelical vs mainline),
# racial groups within traditions, and non-Christian/non-religious categories.
#
# religpew codes: 1=Protestant, 2=Catholic, 3=Mormon, 4=Orthodox Christian,
#   5=Jewish, 6=Muslim, 7=Buddhist, 8=Hindu, 9=Atheist, 10=Agnostic,
#   11=Nothing in Particular, 12=Something Else
#
# race codes: 1=White, 2=Black, 3=Hispanic, 4=Asian, 5=Native American,
#   6=Mixed, 7=Other, 8=Middle Eastern

# Define which Protestant denominations are typically classified as evangelical
# vs mainline. This is a simplification of the full RELTRAD coding scheme.

ces2024 <- ces2024 |>
  mutate(
    # First, identify evangelical denominations
    evangelical = case_when(
      religpew_baptist == 1 ~ TRUE,   # Southern Baptist
      religpew_baptist == 5 ~ TRUE,   # Independent Baptist
      religpew_baptist == 6 ~ TRUE,   # Baptist General Conference
      religpew_baptist == 7 ~ TRUE,   # Baptist Missionary Association
      religpew_baptist == 8 ~ TRUE,   # Conservative Baptist Association
      religpew_baptist == 9 ~ TRUE,   # Free Will Baptist
      religpew_baptist == 10 ~ TRUE,  # General Assoc. of Regular Baptists
      religpew_nondenom %in% c(1, 2, 3) ~ TRUE,  # Evangelical, Fundamentalist, Charismatic nondenom
      religpew_pentecost %in% 1:10 ~ TRUE,  # Pentecostal denominations
      religpew_lutheran == 2 ~ TRUE,  # Missouri Synod
      religpew_lutheran == 3 ~ TRUE,  # Wisconsin Synod
      religpew_presby == 2 ~ TRUE,    # PCA
      religpew_presby == 5 ~ TRUE,    # Orthodox Presbyterian
      religpew_presby == 6 ~ TRUE,    # Evangelical Presbyterian
      TRUE ~ FALSE
    ),
    # Identify mainline denominations
    mainline = case_when(
      religpew_baptist == 2 ~ TRUE,   # ABCUSA
      religpew_methodist == 1 ~ TRUE, # United Methodist
      religpew_lutheran == 1 ~ TRUE,  # ELCA
      religpew_presby == 1 ~ TRUE,    # PCUSA
      religpew_episcop == 1 ~ TRUE,   # Episcopal Church
      religpew_congreg == 1 ~ TRUE,   # UCC
      religpew_nondenom %in% c(4, 5) ~ TRUE,  # Interdenominational, Community Church
      TRUE ~ FALSE
    ),
    # Identify Black Protestant tradition (Black respondents in historically Black denominations
    # or any Black Protestant)
    black_prot = case_when(
      race == 2 & religpew == 1 ~ TRUE,  # Black Protestants
      religpew_baptist == 3 ~ TRUE,       # National Baptist Convention
      religpew_baptist == 4 ~ TRUE,       # Progressive Baptist Convention
      religpew_methodist == 3 ~ TRUE,     # AME
      religpew_methodist == 4 ~ TRUE,     # AME Zion
      religpew_methodist == 5 ~ TRUE,     # CME
      TRUE ~ FALSE
    ),
    # Build the broad tradition variable
    trad = case_when(
      black_prot ~ "Black Protestant",
      religpew == 1 & evangelical & race == 1 ~ "White Evangelical",
      religpew == 1 & evangelical & race != 1 ~ "Nonwhite Evangelical",
      religpew == 1 & mainline & race == 1 ~ "White Mainline",
      religpew == 1 & mainline & race != 1 ~ "Nonwhite Mainline",
      religpew == 1 & race == 1 ~ "Other White Protestant",
      religpew == 1 & race != 1 ~ "Other Nonwhite Protestant",
      religpew == 2 & race == 1 ~ "White Catholic",
      religpew == 2 & race != 1 ~ "Nonwhite Catholic",
      religpew == 3 ~ "Mormon/LDS",
      religpew == 4 ~ "Orthodox Christian",
      religpew == 5 ~ "Jewish",
      religpew == 6 ~ "Muslim",
      religpew == 7 ~ "Buddhist",
      religpew == 8 ~ "Hindu",
      religpew == 9 ~ "Atheist",
      religpew == 10 ~ "Agnostic",
      religpew == 11 ~ "Nothing in Particular",
      religpew == 12 ~ "Something Else",
      TRUE ~ NA_character_
    )
  ) |>
  # Remove helper columns
  select(-evangelical, -mainline, -black_prot) |>
  # Remove rows with no tradition assignment

  filter(!is.na(trad)) |>
  # Filter to valid income responses (1-16 scale, excluding refusals)
  filter(income >= 1, income <= 16)

# Create labels for the income variable for reference
# 1 = Less than $10,000
# 2 = $10,000 - $19,999
# 3 = $20,000 - $29,999
# 4 = $30,000 - $39,999
# 5 = $40,000 - $49,999
# 6 = $50,000 - $59,999
# 7 = $60,000 - $69,999
# 8 = $70,000 - $79,999
# 9 = $80,000 - $99,999
# 10 = $100,000 - $119,999
# 11 = $120,000 - $149,999
# 12 = $150,000 - $199,999
# 13 = $200,000 - $249,999
# 14 = $250,000 - $349,999
# 15 = $350,000 - $499,999
# 16 = $500,000 or more

# Save the processed data
saveRDS(ces2024, "reverse_engineering/data/ces_2024_religion.rds")

cat("Data saved to reverse_engineering/data/ces_2024_religion.rds\n")
cat("Rows:", nrow(ces2024), "\n")
cat("Traditions:\n")
print(sort(table(ces2024$trad), decreasing = TRUE))
