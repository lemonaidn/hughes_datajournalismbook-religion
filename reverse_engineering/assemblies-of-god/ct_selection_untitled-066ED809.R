aog <- range_speedread("https://docs.google.com/spreadsheets/d/1hGhLAEV7nS--HtZwbk3zzmC-gDudN6o3Ol4nF8OxcWI/edit?usp=sharing", sheet = 8)

aog$members <- str_replace_all(aog$members, ",", "")
aog$members <- as.numeric(aog$members)

aog %>% 
  ggplot(., aes(x = year, y = members)) +
  geom_line(color = "orchid", linewidth = 1) +  # Line graph with custom color and size
  geom_point(stroke = 1, shape = 21, fill = 'white') + 
  scale_y_continuous(labels = scales::comma) +  # Format y-axis with commas
  scale_x_continuous(breaks = seq(min(aog$year), max(aog$year), by = 5)) +  # Label every 5th year
  theme_rb() +
  geom_text(data = aog %>% filter(year %in% c(1975, 1985, 1995, 2005, 2015, 2024)),  # Filter for specific years
            aes(label = scales::comma(members, accuracy = 0.01, scale = 1e-6, suffix = "M")),
            vjust = -1.5, color = "black", size = 4, family = "font") + 
  labs(x = "Year", 
       y = "Number of Members", 
       title = "Assemblies of God Membership Over Time", 
       caption = "@ryanburge\nData: 2024 AG Statistical Reports") +
  theme(panel.grid.major.x = element_line(color = "gray", linetype = "dotted"))  
save("aog_membership24.png")

aog %>% 
  filter(year >= 2014) %>% 
  ggplot(aes(x = factor(year), y = members)) +
  geom_col(fill = "orchid", color = "black") +
  geom_text(
    aes(label = scales::number(members, accuracy = 0.01, scale = 1e-6, suffix = "M")),
    vjust = -0.5, color = "black", size = 5, family = "font"
  ) +
  scale_y_continuous(labels = scales::comma, expand = expansion(mult = c(0, 0.1))) +
  labs(
    x = NULL,
    y = "Number of Members",
    title = "Assemblies of God Membership, 2018–2024",
    caption = "@ryanburge\nData: 2024 AG Statistical Reports"
  ) +
  theme_rb() +
  theme(
    panel.grid.major.x = element_blank(),
    panel.grid.major.y = element_line(color = "gray", linetype = "dotted")
  )

save("aog_membership_recent_bars.png", wd = 7, ht = 4)

## Slightly larger in 2024 than in 2011 (3.04M vs 3.06M)





attend <- read_csv("E://data/ag_attend.csv") %>% clean_names()


attend %>% 
  ggplot(., aes(x = year, y = attendance)) +
  geom_line(color = "azure3", size = 1) +  # Line graph with custom color and size
  geom_point(stroke = 1, shape = 21, fill = 'white') +
  theme_rb() +
  scale_y_continuous(labels = scales::comma) + 
  add_text(x = 1978, y = 1080000, word = "1.1M", sz = 6) +
  add_text(x = 2018, y = 2080000, word = "2M", sz = 6) +
  add_text(x = 2021, y = 1630000, word = "1.7M", sz = 6) +
  add_text(x = 2024, y = 2000000, word = "1.93M", sz = 6) +
  
  labs(x = "Year", y = "", title = "Assemblies of God In-Person Worship Attendance, 1978-2024", 
       caption = "@ryanburge\nData: 2024 AG Statistical Reports")  
save("aog_attendance24.png")



attend %>% 
  filter(year >= 2014) %>% 
  ggplot(aes(x = factor(year), y = attendance)) +
  geom_col(fill = "azure3", color = "black") +
  geom_text(
    aes(label = scales::number(attendance, accuracy = 0.01, scale = 1e-6, suffix = "M")),
    vjust = -0.5, color = "black", size = 5, family = "font"
  ) +
  scale_y_continuous(labels = scales::comma, expand = expansion(mult = c(0, 0.1))) +
  labs(
    x = NULL,
    y = "In-Person Attendance",
    title = "Assemblies of God Worship Attendance, 2014–2024",
    caption = "@ryanburge\nData: 2024 AG Statistical Reports"
  ) +
  theme_rb() +
  theme(
    panel.grid.major.x = element_blank(),
    panel.grid.major.y = element_line(color = "gray", linetype = "dotted")
  )

save("aog_attendance_recent_bars.png", wd = 7, ht = 4)

## 3.5% off their all time highs. 




att <- attend %>% 
  select(year, attendance)

both <- left_join(att, aog) %>% select(-denom)

both <- both %>% 
  filter(year >= 1979) %>% 
  mutate(ratio = attendance/members)

both %>% 
  ggplot(., aes(x = year, y = ratio)) +
  geom_line() +  # Line graph with custom color and size
  geom_point(color = "orange", stroke = 1, shape = 21, fill = 'white') +
  theme_rb() +
  y_pct() + 
  add_text(x = 1979, y = .725, word = "72%", sz = 6) +
  add_text(x = 2018, y = .635, word = "63%", sz = 6) +
  add_text(x = 2020, y = .530, word = "54%", sz = 6) +
  add_text(x = 2024, y = .648, word = "64%", sz = 6) +
  
  labs(x = "Year", y = "", title = "What Percentage of Adherents are Attenders in the Assemblies of God?", 
       caption = "@ryanburge\nData: 2024 AG Statistical Reports")
save("ag_attend_ratio24.png")




library(dplyr)
library(ggplot2)
library(scales)

# Filter data for 2009-2019
projection_data <- att %>%
  filter(as.numeric(year) >= 2009, as.numeric(year) <= 2019)

# Filter data for 2020-2023
plot_data <- att %>%
  filter(as.numeric(year) >= 2020)

# Fit a linear model to 2009-2019 data
lm_model <- lm(attendance ~ as.numeric(year), data = projection_data)

# Predict values for all years from 2009-2023
predicted_data <- data.frame(
  year = 2009:2024,
  num = predict(lm_model, newdata = data.frame(year = 2009:2024))
)

# Combine data for plotting, explicitly filtering only 2009 and later
combined_data <- att %>%
  filter(as.numeric(year) >= 2009) %>%  # Exclude years prior to 2009
  mutate(source = ifelse(as.numeric(year) <= 2019, "Projection Data", "Post-2020 Data"))


# Custom label formatting function for the y-axis
format_y_axis <- function(x) {
  ifelse(
    x >= 1e6, 
    paste0(round(x / 1e6, 1), "M"),  # Millions
    paste0(round(x / 1e3), "K")      # Thousands
  )
}

# Custom label formatting function for bar labels
format_attendance <- function(x) {
  ifelse(
    x >= 1e6, 
    paste0(round(x / 1e6, 1), "M"),  # Millions
    paste0(round(x / 1e3), "K")      # Thousands
  )
}

# Plot
ggplot() +
  geom_col(
    data = combined_data, 
    aes(x = as.numeric(year), y = attendance, fill = source), 
    color = "black"
  ) +
  geom_line(
    data = predicted_data, 
    aes(x = year, y = num), 
    color = "black", 
    linetype = "dashed", 
    size = 1
  ) +
  geom_text(
    data = combined_data,
    aes(
      x = as.numeric(year), 
      y = attendance, 
      label = format_attendance(attendance)
    ),
    vjust = -0.5,  # Adjust text position above bars
    size = 5, family = "font"     # Adjust text size
  ) +
  scale_fill_manual(
    values = c("Projection Data" = "orange", "Post-2020 Data" = "#6BAED6"),
    guide = guide_legend(reverse = TRUE)  # Reverse the legend order
  ) +
  scale_y_continuous(labels = format_y_axis) +  # Apply custom y-axis formatting
  labs(
    x = "Year",
    y = "",
    title = "Weekly Worship Attendance of the AG with Linear Projection (2009-2019)",
    caption = "@ryanburge\nData: AG Denominational Statistics"
  ) +
  theme_rb(legend = TRUE) +
  theme(
    plot.title = element_text(size = 16, face = "bold"),
    axis.text = element_text(size = 12),
    legend.position = "bottom",
    legend.title = element_blank()
  )

# Save the plot
save("weekly_attendance_projection_with_labels_assembliesofgod24.png")

## The projection model predicts an attendance of approximately 2,112,211 for the year 2023.

## 86.8304 - down 13.2% from the projection. 

## The projection model predicts an attendance of approximately 2,131,558 for the year 2024.

## 91.87 - down 8.1% from the projection. 


library(dplyr)
library(ggplot2)
library(scales)

# --- Fit projection on 2009–2019 (same approach as you used) ---
projection_data <- att %>% filter(as.numeric(year) >= 2009, as.numeric(year) <= 2019)
lm_model <- lm(attendance ~ as.numeric(year), data = projection_data)

predicted_data <- tibble(
  year = 2009:2024,
  num  = predict(lm_model, newdata = tibble(year = 2009:2024))
)

# --- Join actuals to predictions and compute gaps ---
gap_df <- att %>%
  mutate(year = as.numeric(year)) %>%
  filter(year >= 2009) %>%
  select(year, attendance) %>%
  left_join(predicted_data, by = "year") %>%
  mutate(
    abs_gap = attendance - num,            # actual - predicted
    pct_gap = (attendance - num) / num     # % vs projection
  )

# --- Helper label for millions ---
fmt_m <- function(x) ifelse(abs(x) >= 1e6,
                            paste0(sign(x) * round(abs(x)/1e6, 2), "M"),
                            comma(x))

# ========== Plot 1: Absolute gap (bars) ==========
gap_df %>%
  filter(year >= 2020) %>%
  ggplot(aes(x = factor(year), y = abs_gap)) +
  geom_hline(yintercept = 0, color = "gray40") +
  geom_col(aes(fill = abs_gap >= 0), color = "black") +
  geom_text(
    aes(label = paste0(ifelse(abs_gap >= 0, "+", ""), fmt_m(abs_gap),
                       " (", percent(pct_gap, accuracy = 0.1), ")"),
        vjust = ifelse(abs_gap >= 0, -0.5, 1.2)),
    size = 4.5, family = "font"
  ) +
  scale_fill_manual(values = c("FALSE" = "#B2182B", "TRUE" = "#4DAF4A"),
                    labels = c("FALSE" = "Below projection", "TRUE" = "Above projection")) +
  scale_y_continuous(labels = comma, expand = expansion(mult = c(0.05, 0.15))) +
  labs(
    x = NULL, y = "Actual – Predicted Attendance",
    title = "Gap vs. Linear Projection (baseline: 2009–2019)",
    caption = "@ryanburge | Source: AG Denominational Statistics"
  ) +
  theme_rb() +
  theme(legend.position = "bottom", legend.title = element_blank())

save("ag_attendance_gap_abs_2020_2024.png", wd = 7, ht = 5)

# ========== Plot 2 (optional): % gap only ==========
gap_df %>%
  filter(year >= 2020) %>%
  ggplot(aes(x = factor(year), y = pct_gap)) +
  geom_hline(yintercept = 0, color = "gray40") +
  geom_col(aes(fill = pct_gap >= 0), color = "black") +
  geom_text(
    aes(label = paste0(ifelse(pct_gap >= 0, "+", ""), percent(pct_gap, accuracy = 0.1)),
        vjust = ifelse(pct_gap >= 0, -0.5, 1.2)),
    size = 5, family = "font"
  ) +
  scale_fill_manual(values = c("FALSE" = "#B2182B", "TRUE" = "#4DAF4A"),
                    labels = c("FALSE" = "Below projection", "TRUE" = "Above projection")) +
  scale_y_continuous(labels = percent_format(accuracy = 1), expand = expansion(mult = c(0.05, 0.15))) +
  labs(
    x = NULL, y = "% Difference from Projection",
    title = "Attendance vs. Projection (Percent Gap)",
    caption = "@ryanburge | Source: AG Denominational Statistics"
  ) +
  theme_rb(legend = TRUE) +
  theme(legend.position = "bottom", legend.title = element_blank())

save("ag_attendance_gap_pct_2020_2024.png", wd = 7, ht = 4)


# --- Build data frame of recent gap values ---
gap_df_recent <- gap_df %>%
  filter(year >= 2020) %>%
  mutate(year = as.numeric(year))

# --- Fit a linear model for how the gap is closing ---
gap_trend <- lm(abs_gap ~ year, data = gap_df_recent)

summary(gap_trend)

# --- Predict the year when abs_gap = 0 (gap closes) ---
# abs_gap = a + b*year  →  0 = a + b*year  →  year = -a/b
intercept <- coef(gap_trend)[1]
slope <- coef(gap_trend)[2]
closing_year <- -intercept / slope

closing_year

## The gap will overcome the COVID declines around 2029 or 2030. 




con <- read_csv("E://data/ag_converts.csv") %>% clean_names()

cc <- con %>% select(year, converts)

bap <- read_csv("E://data/ag_baptisms.csv") %>% clean_names()

bb <- bap %>% select(year, water = water_baptisms, spirit = holy_spirit_baptisms)

gg <- left_join(bb, cc) %>% 
  mutate(baptism = water + spirit) %>% 
  mutate(nb = converts - baptism) %>% 
  select(year, water, spirit, other = nb) %>% 
  pivot_longer(
    cols = -year, # Keep the 'year' column as-is
    names_to = "type", # New column for race categories
    values_to = "num" # New column for values
  ) %>% 
  mutate(type = frcode(type == "water" ~ "Water Baptism", 
                       type == "spirit" ~ "Spirit Baptism", 
                       type == "other" ~ "Other"))


gg %>%
  group_by(year) %>% 
  mutate(percentage = (num / sum(num)) * 100) %>% 
  ungroup() %>% as.data.frame()


# Calculate total for each year
total_data <- gg %>%
  group_by(year) %>%
  summarize(total = sum(num, na.rm = TRUE))

# Merge totals back with the original data (optional, not needed for geom_text)
gg <- gg %>%
  left_join(total_data, by = "year")

# Plot
gg %>%
  ggplot(aes(x = year, y = num, fill = type)) +
  geom_col(color = "black") +
  geom_text(
    data = total_data, # Use the total data for labels
    aes(
      x = year, 
      y = total, 
      label = ifelse(year %in% c(1981, 1990, 1997, 2011, 2019, 2024), paste0(round(total / 1e3, 0), "K"), NA)
    ),
    inherit.aes = FALSE, # Do not inherit aesthetics from ggplot()
    vjust = -0.5, # Position labels above bars
    size = 3, # Adjust label size
    family = "font" # Optional: Customize font family if needed
  ) +
  theme_rb(legend = TRUE) +
  scale_y_continuous(labels = format_y_axis) +  
  scale_fill_fivethirtyeight() +
  labs(
    x = "", 
    y = "", 
    title = "Conversions into the Assemblies of God, 1979-2024", 
    caption = "@ryanburge | Data: AG Denominational Statistics"
  ) 
save("ag_inflows24.png")

library(dplyr)
library(ggplot2)
library(scales)

gg %>% 
  filter(year >= 2020) %>% 
  ggplot(aes(x = factor(year), y = num, fill = type)) +
  geom_col(color = "black") +
  geom_text(
    aes(label = paste0(round(num / 1e3, 0), "K")),
    position = position_stack(vjust = 0.5),  # centers text in each segment
    color = "black",
    size = 5.5,
    family = "font"
  ) +
  scale_fill_fivethirtyeight() +
  scale_y_continuous(labels = function(x) paste0(round(x / 1e3, 0), "K")) +
  labs(
    x = NULL,
    y = NULL,
    title = "Conversions into the Assemblies of God, 2020–2024",
    caption = "@ryanburge | Data: AG Denominational Statistics"
  ) +
  theme_rb(legend = TRUE) +
  theme(
    legend.title = element_blank(),
    plot.title = element_text(size = 15), 
    panel.grid.major.x = element_blank(),
    panel.grid.major.y = element_line(color = "gray", linetype = "dotted")
  )

save("ag_inflows_recent_bars.png", wd = 5, ht = 4)




race <- read_csv("E://data/ag_race.csv") %>% clean_names()


race <- race %>%
  mutate(
    asian_pacific_proportion = pacific_islander / total,
    black_proportion = black / total,
    hispanic_proportion = hispanic / total,
    native_american_proportion = native_american / total,
    white_proportion = white / total,
    other_any_race_proportion = other_mixed / total)

race_proportions <- race %>%
  select(year, ends_with("_proportion"))

long <- race_proportions %>%
  pivot_longer(
    cols = -year, # Keep the 'year' column as-is
    names_to = "race", # New column for race categories
    values_to = "count_or_proportion" # New column for values
  )

gg <- long %>%
  mutate(race = frcode(
    race == "white_proportion" ~ "White",
    race == "black_proportion" ~ "Black",
    race == "hispanic_proportion" ~ "Hispanic",
    race == "asian_pacific_proportion" ~ "Asian",
    race == "native_american_proportion" ~ "Native American",
    race %in% c("other_any_race_proportion", "unknown_proportion") ~ "Other/Unknown"
  )) %>%
  group_by(year, race) %>%
  summarize(pct = sum(count_or_proportion), .groups = "drop")

gg %>% 
  filter(year == 2001 | year == 2023) %>% 
  ggplot(., aes(x = factor(year), y = pct, fill = race)) +
  geom_col(color = "black") +
  facet_wrap(~ race) +
  theme_rb() + 
  y_pct() +
  scale_fill_manual(values = c(met.brewer("Java", 6))) +
  lab_bar(type = pct, pos = .04, sz = 8, above = TRUE) +
  labs(x = "", y = "", title = "The Racial Composition of Assemblies of God Adherents", 
       caption = "@ryanburge\nData: 2024 AG Statistical Reports")
save("ag_adh_race.png", ht = 8, wd = 6)



library(dplyr)
library(ggplot2)
library(scales)

# gg is a tibble: year, race, pct  (pct in 0–1)
# 1) Choose 5 evenly spaced years across the available range (snaps to nearest actual year)
years_all <- sort(unique(gg$year))
anchors   <- round(seq(min(years_all), max(years_all), length.out = 5))
pick_years <- unique(sapply(anchors, function(y) years_all[which.min(abs(years_all - y))]))
# Optional: ensure final order is chronological
pick_years <- sort(pick_years)

# 2) (Optional) Order race levels to your preferred display order
#    Put the largest group at the bottom of each stack when flipped.
race_levels <- c("White", "Hispanic", "Black", "Asian", "Native American", "Other/Unknown")



gg %>%
  mutate(
    race4 = frcode(
      race %in% c("White") ~ "White",
      race %in% c("Black") ~ "Black",
      race %in% c("Hispanic") ~ "Hispanic",
      TRUE ~ "Everyone Else"
    )
  ) %>%
  group_by(year, race4) %>%
  summarise(pct = sum(pct, na.rm = TRUE), .groups = "drop") %>%
  filter(year %in% c(2001, 2007, 2012, 2018, 2024)) %>%
  mutate(year = as.factor(year)) %>% 
  ggplot(aes(x = fct_rev(year), y = pct, fill = fct_rev(race4))) +
  geom_col(color = "black") +
  geom_text(
    aes(label = percent(pct, accuracy = 1)),
    position = position_stack(vjust = 0.5),
    size = 7, family = "font", color = "black"
  ) +
  coord_flip() +
  guides(fill = guide_legend(reverse = TRUE)) +  # ⬅️ reverse legend order
  scale_y_continuous(labels = percent_format(accuracy = 1)) +
  scale_fill_d3() +
  labs(
    x = NULL,
    y = NULL,
    title = "Racial Composition of the Assemblies of God, 2001–2024",
    caption = "@ryanburge | Source: AG Denominational Statistics"
  ) +
  theme_rb(legend = TRUE) +
  theme(
    legend.title = element_blank(),
    panel.grid.major.x = element_line(color = "gray", linetype = "dotted"),
    panel.grid.major.y = element_blank()
  )

save("ag_race_stacked_flipped_4groups.png", wd = 7, ht = 4)





aog <- aog %>%
  arrange(year) %>%  # Ensure data is sorted by year
  mutate(
    yoy_change = members - lag(members),  # Absolute YoY change
    yoy = (members - lag(members)) / lag(members)  # Percentage YoY change
  )

aog %>% 
  filter(yoy < .10) %>% 
  ggplot(., aes(x = year, y = yoy)) +
  geom_line() +
  geom_point(stroke = 1, shape = 21, fill = "white") +
  geom_smooth(se = FALSE, linetype = "twodash", color = "firebrick1", linewidth = .5) +
  y_pct() +
  geom_hline(yintercept = 0) +
  theme_rb() + 
  labs(x = "Year", y = "", title = "Year Over Year Percent Change in Assemblies of God Adherents", 
       caption = "@ryanburge\nData: 2024 AG Statistical Reports")
save("ag_yoy_change24.png")