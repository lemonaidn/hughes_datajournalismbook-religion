# Data Preparation Script for Reverse Engineering Assignment
# "The People Streaming Church Aren't Who You Think"
#
# INSTRUCTOR USE ONLY - Students should not need to run this script.
# This takes the full Pew Religious Landscape Study 2023-24 data
# and extracts only the variables needed for the streaming church analysis.
#
# Requirements:
#   - The 2023-24 RLS Public Use File must be available
#   - install.packages(c("tidyverse", "haven"))
#
# The output file (rls_streaming.csv) should be placed in
# reverse_engineering/streaming-church/data/ before distributing the assignment.

library(tidyverse)
library(haven)

# Read the full RLS data
# Adjust the path to where you have the RLS data stored
rls_full <- read_sav("~/code/rlsdata/2023-24 RLS Public Use File Feb 19.sav")

# Select only the variables needed for the streaming church analysis
rls_streaming <- rls_full %>%
  select(
    # Survey weight
    WEIGHT,

    # Attendance variables (key DVs)
    ATTNDPERRLS,   # In-person attendance frequency
    ATTNDONRLS,    # Online/TV attendance frequency

    # Demographics
    EDUCREC,       # Education (recoded)
    INC_SDT1,      # Income (standard categories)
    HISP,          # Hispanic identification
    RACECMB,       # Race (combined)
    GENDER,        # Gender
    BIRTHDECADE    # Birth decade
  ) %>%
  # Remove any rows with missing weight
  filter(!is.na(WEIGHT)) %>%
  # Convert to lowercase column names for student ease of use
  rename_all(tolower)

# Save as CSV
write_csv(rls_streaming, "data/rls_streaming.csv")

cat("Data saved to data/rls_streaming.csv\n")
cat("Rows:", nrow(rls_streaming), "\n")
cat("\nVariable summary:\n")
cat("- attndperrls: In-person attendance (1=More than once/week, 2=Once/week, 3=Once or twice/month,\n")
cat("                4=Few times/year, 5=Seldom, 6=Never)\n")
cat("- attndonrls: Online/TV attendance (same scale as attndperrls)\n")
cat("- educrec: Education (1=HS or less, 2=Some college, 3=College grad, 4=Postgrad)\n")
cat("- inc_sdt1: Income (1-8 scale, see codebook)\n")
cat("- hisp: Hispanic (1=Yes, 2=No)\n")
cat("- racecmb: Race (1=White, 2=Black, 3=Asian, 4=Mixed, 5=Other)\n")
cat("- gender: Gender (1=Man, 2=Woman)\n")
cat("- birthdecade: Birth decade (1=1940s through 7=2000s)\n")
