library(readr)

occ <- read_csv(
  "E://data/occ_vote.tab",
  col_types = cols(
    naics_code = col_character(),
    naics_desc = col_character(),
    employee_count = col_double(),
    dem_workers_raw = col_double(),
    rep_workers_raw = col_double(),
    other_workers_raw = col_double(),
    party_known_workers_raw = col_double(),
    dem_workers_imp = col_double(),
    rep_workers_imp = col_double(),
    other_workers_imp = col_double(),
    avg_match_quality = col_double(),
    democrat_pct_raw = col_double(),
    republican_pct_raw = col_double(),
    nonpartisan_pct_raw = col_double(),
    democrat_pct_two_party_raw = col_double(),
    republican_pct_two_party_raw = col_double(),
    two_party_margin_raw = col_double(),
    overall_margin_raw = col_double(),
    democrat_pct_imp = col_double(),
    republican_pct_imp = col_double(),
    nonpartisan_pct_imp = col_double(),
    democrat_pct_two_party_imp = col_double(),
    republican_pct_two_party_imp = col_double(),
    two_party_margin_imp = col_double(),
    overall_margin_imp = col_double(),
    political_diversity_raw = col_double(),
    political_diversity_imp = col_double(),
    effective_parties_raw = col_double(),
    effective_parties_imp = col_double(),
    latest_processed_at = col_character()
  )
)



library(dplyr)
library(stringr)

core_religious <- c("813110")  # Religious Organizations

faith_adjacent <- c(
  "611310", # Colleges, Universities, and Professional Schools (seminaries, Bible colleges)
  "611110", # Elementary & Secondary Schools (includes parochial schools)
  "611699", # Other Schools & Instruction (religious instruction)
  "813219", # Other Grantmaking & Giving Services (religious foundations)
  "813319", # Other Social Advocacy Organizations (religious advocacy)
  "624190", # Other Individual & Family Services (ministries, relief orgs)
  "624110"  # Child & Youth Services (faith-based youth programs)
)

occ <- occ %>%
  mutate(
    rel_sector = case_when(
      naics_code %in% core_religious ~ "Religious Organizations (813110)",
      naics_code %in% faith_adjacent ~ "Faith-Adjacent",
      str_detect(str_to_lower(naics_desc),
                 "\\breligious\\b|\\bfaith\\b|\\btheolog\\b|\\bseminar|\\bchurch\\b|\\bmosque\\b|\\bsynagogue\\b|\\byeshiva\\b") ~
        "Description-Religious",
      TRUE ~ "Other"
    )
  )


occ %>%
  count(rel_sector, sort = TRUE)

occ %>%
  filter(rel_sector != "Other") %>%
  select(naics_code, naics_desc)


rel_occ <- occ %>%
  filter(naics_code == "813110")



rel_occ %>%
  summarise(
    total_workers = sum(employee_count),
    dem_share  = mean(democrat_pct_imp),
    rep_share  = mean(republican_pct_imp),
    margin     = mean(overall_margin_imp),
    diversity  = mean(political_diversity_imp)
  )




top10 <- occ %>%
  arrange(desc(employee_count)) %>%
  slice_head(n = 10) %>%
  mutate(rank = row_number()) %>%
  select(rank, naics_code, naics_desc, employee_count)



compare <- occ %>%
  filter(naics_code %in% c(top10$naics_code, "813110")) %>%
  mutate(
    sector = if_else(naics_code == "813110", "Religious Organizations", naics_desc)
  ) %>%
  select(sector, employee_count, democrat_pct_imp, republican_pct_imp, overall_margin_imp, political_diversity_imp)



compare_summary <- compare %>%
  group_by(sector) %>%
  summarise(
    total_workers = sum(employee_count, na.rm = TRUE),
    dem_share  = weighted.mean(democrat_pct_imp, employee_count, na.rm = TRUE),
    rep_share  = weighted.mean(republican_pct_imp, employee_count, na.rm = TRUE),
    margin     = weighted.mean(overall_margin_imp, employee_count, na.rm = TRUE),
    diversity  = weighted.mean(political_diversity_imp, employee_count, na.rm = TRUE),
    .groups = "drop"
  ) %>%
  arrange(desc(total_workers))



library(dplyr)
library(forcats)
library(scales)
library(ggplot2)

compare_summary2 <- compare_summary %>%
  mutate(
    sector = fct_reorder(sector, margin),
    margin_label = percent(margin, accuracy = 1),
    hjust_lab = if_else(margin > 0, -0.1, 1.1)
  )

ggplot(compare_summary2, aes(x = sector, y = margin, fill = margin)) +
  geom_col(color = "black") +
  coord_flip() +
  scale_fill_gradient2(
    low = "#2166ac", mid = "white", high = "#b2182b",
    midpoint = 0, limits = c(-0.3, 0.3), oob = scales::squish
  ) +
  scale_y_continuous(limits = c(-.35, .08)) +
  geom_hline(yintercept = 0, color = "gray40", linewidth = 0.5) +
  geom_text(aes(label = margin_label), hjust = compare_summary2$hjust_lab, size = 6, family = "font") +
  labs(
    x = NULL, y = "Republican − Democratic Share",
    title = "Partisan Lean of Workers in Major Industries (2024)",
    subtitle = "Positive = Republican advantage • Negative = Democratic advantage", 
    caption = "@ryanburge | Data: VRScores, 2024"
  ) +
  theme_rb() +
  theme(legend.position = "none")
save("occ_compare_2024.png", wd = 10, ht = 6)





occ12 <- read_csv(
  "E://data/naics_panel_year_2012.tab",
  col_types = cols(
    naics_code = col_character(),
    naics_desc = col_character(),
    employee_count = col_double(),
    dem_workers_raw = col_double(),
    rep_workers_raw = col_double(),
    other_workers_raw = col_double(),
    party_known_workers_raw = col_double(),
    dem_workers_imp = col_double(),
    rep_workers_imp = col_double(),
    other_workers_imp = col_double(),
    avg_match_quality = col_double(),
    democrat_pct_raw = col_double(),
    republican_pct_raw = col_double(),
    nonpartisan_pct_raw = col_double(),
    democrat_pct_two_party_raw = col_double(),
    republican_pct_two_party_raw = col_double(),
    two_party_margin_raw = col_double(),
    overall_margin_raw = col_double(),
    democrat_pct_imp = col_double(),
    republican_pct_imp = col_double(),
    nonpartisan_pct_imp = col_double(),
    democrat_pct_two_party_imp = col_double(),
    republican_pct_two_party_imp = col_double(),
    two_party_margin_imp = col_double(),
    overall_margin_imp = col_double(),
    political_diversity_raw = col_double(),
    political_diversity_imp = col_double(),
    effective_parties_raw = col_double(),
    effective_parties_imp = col_double(),
    latest_processed_at = col_character()
  )
)




library(dplyr)
library(forcats)
library(scales)
library(ggplot2)

# --- Top 10 industries by employment (2012) ---
top10_2012 <- occ12 %>%
  arrange(desc(employee_count)) %>%
  slice_head(n = 10) %>%
  select(naics_code, naics_desc, employee_count)

# --- Pull Religious Organizations (813110) if present ---
rel_2012 <- occ12 %>% filter(naics_code == "813110")

# Combine top10 + 813110 (dedup in case 813110 is already in top10)
compare_2012 <- bind_rows(top10_2012, rel_2012) %>%
  distinct(naics_code, .keep_all = TRUE) %>%
  # Join back the metrics we need (since top10_2012 only kept a few cols)
  left_join(
    occ12 %>% select(
      naics_code, naics_desc, employee_count,
      democrat_pct_imp, republican_pct_imp,
      overall_margin_imp, political_diversity_imp
    ),
    by = "naics_code",
    suffix = c("", "")
  ) %>%
  mutate(
    sector = if_else(naics_code == "813110", "Religious Organizations", naics_desc)
  ) %>%
  select(sector, employee_count,
         democrat_pct_imp, republican_pct_imp,
         overall_margin_imp, political_diversity_imp)

# --- Summarize (weighted by employment; each NAICS is one row but this keeps parity with 2024 code) ---
compare_summary_2012 <- compare_2012 %>%
  group_by(sector) %>%
  summarise(
    total_workers = sum(employee_count, na.rm = TRUE),
    dem_share     = weighted.mean(democrat_pct_imp, employee_count, na.rm = TRUE),
    rep_share     = weighted.mean(republican_pct_imp, employee_count, na.rm = TRUE),
    margin        = weighted.mean(overall_margin_imp, employee_count, na.rm = TRUE),
    diversity     = weighted.mean(political_diversity_imp, employee_count, na.rm = TRUE),
    .groups = "drop"
  ) %>%
  arrange(desc(total_workers))

# --- Precompute labels to avoid the margin() name collision ---
compare_summary2_2012 <- compare_summary_2012 %>%
  mutate(
    sector       = fct_reorder(sector, margin),
    margin_label = percent(margin, accuracy = 1),
    hjust_lab    = if_else(margin > 0, -0.1, 1.1)
  )

# --- Plot with blue–white–red gradient centered at 0 ---
ggplot(compare_summary2_2012, aes(x = sector, y = margin, fill = margin)) +
  geom_col(color = "black") +
  coord_flip() +
  scale_fill_gradient2(
    low = "#2166ac", mid = "white", high = "#b2182b",
    midpoint = 0, limits = c(-0.3, 0.3), oob = scales::squish
  ) +
  # If your 2012 margins are different in range, adjust this next line:
  scale_y_continuous(limits = c(-.33, .12)) +
  geom_hline(yintercept = 0, color = "gray40", linewidth = 0.5) +
  geom_text(aes(label = margin_label), hjust = compare_summary2_2012$hjust_lab,
            size = 6, family = "font") +
  labs(
    x = NULL, y = "Republican − Democratic Share",
    title = "Partisan Lean of Workers in Major Industries (2012)",
    subtitle = "Positive = Republican advantage • Negative = Democratic advantage",
    caption = "@ryanburge | Data: VRscores, 2012"
  ) +
  theme_rb() +
  theme(legend.position = "none")

save("occ_compare_2012.png", wd = 10, ht = 6)




library(cluster)
mat <- occ %>% select(democrat_pct_imp, republican_pct_imp, political_diversity_imp) %>% scale()
cl <- kmeans(mat, centers = 5, nstart = 25)
occ$cluster <- cl$cluster



occ <- occ %>%
  mutate(
    cluster_label = case_when(
      cluster == 1 ~ "Strongly Democratic",
      cluster == 2 ~ "Strongly Republican",
      cluster == 3 ~ "Hyper-Democratic",
      cluster == 4 ~ "Mixed (Dem Lean)",
      cluster == 5 ~ "Mixed (GOP Lean)"
    )
  )



occ %>%
  count(cluster_label, sort = TRUE)

occ %>%
  group_by(cluster_label) %>%
  summarise(
    n_industries = n(),
    total_workers = sum(employee_count, na.rm = TRUE),
    mean_diversity = mean(political_diversity_imp, na.rm = TRUE)
  )

occ %>%
  filter(cluster_label == "Strongly Democratic") %>%
  arrange(desc(democrat_pct_imp)) %>%
  select(naics_code, naics_desc, democrat_pct_imp, republican_pct_imp, political_diversity_imp) %>%
  head(10)


library(dplyr)

# pick the religious orgs reference row
ref <- occ %>%
  filter(naics_code == "813110") %>%
  select(democrat_pct_imp, republican_pct_imp, political_diversity_imp)

# compute Euclidean distance to each other industry
similar_to_religion <- occ %>%
  mutate(
    dist = sqrt(
      (democrat_pct_imp - ref$democrat_pct_imp)^2 +
        (republican_pct_imp - ref$republican_pct_imp)^2 +
        (political_diversity_imp - ref$political_diversity_imp)^2
    )
  ) %>%
  arrange(dist)



similar_to_religion %>%
  filter(naics_code != "813110") %>%
  select(naics_code, naics_desc, democrat_pct_imp, republican_pct_imp,
         political_diversity_imp, dist) %>%
  slice_head(n = 10)



ref12 <- occ12 %>% filter(naics_code == "813110") %>%
  select(democrat_pct_imp, republican_pct_imp, political_diversity_imp)

similar_2012 <- occ12 %>%
  mutate(dist = sqrt((democrat_pct_imp - ref12$democrat_pct_imp)^2 +
                       (republican_pct_imp - ref12$republican_pct_imp)^2 +
                       (political_diversity_imp - ref12$political_diversity_imp)^2)) %>%
  arrange(dist) %>%
  slice_head(n = 10)





library(dplyr)
library(gt)

sim24 <- similar_to_religion %>%
  filter(naics_code != "813110") %>%
  select(naics_code, naics_desc, democrat_pct_imp, republican_pct_imp,
         political_diversity_imp, dist) %>%
  mutate(year = 2024)

sim12 <- similar_2012 %>%
  filter(naics_code != "813110") %>%
  select(naics_code, naics_desc, democrat_pct_imp, republican_pct_imp,
         political_diversity_imp, dist) %>%
  mutate(year = 2012)



sim_both <- bind_rows(sim12, sim24) %>%
  group_by(year) %>%
  mutate(rank = row_number()) %>%
  ungroup()


sim_wide <- sim_both %>%
  select(year, rank, naics_desc, democrat_pct_imp, republican_pct_imp,
         political_diversity_imp) %>%
  pivot_wider(
    names_from = year,
    values_from = c(naics_desc, democrat_pct_imp, republican_pct_imp, political_diversity_imp)
  )



sim_wide %>%
  gt() %>%
  fmt_percent(columns = contains("democrat_pct_imp"), decimals = 0) %>%
  fmt_percent(columns = contains("republican_pct_imp"), decimals = 0) %>%
  fmt_number(columns = contains("political_diversity_imp"), decimals = 3) %>%
  cols_label(
    rank = "Rank",
    naics_desc_2012 = "2012 — Industry",
    democrat_pct_imp_2012 = "Dem %",
    republican_pct_imp_2012 = "Rep %",
    political_diversity_imp_2012 = "Diversity",
    naics_desc_2024 = "2024 — Industry",
    democrat_pct_imp_2024 = "Dem %",
    republican_pct_imp_2024 = "Rep %",
    political_diversity_imp_2024 = "Diversity"
  ) %>%
  tab_header(
    title = md("**Industries Most Similar to Religious Organizations (2012 vs 2024)**"),
    subtitle = md("Similarity based on Democratic %, Republican %, and Political Diversity")
  ) %>%
  tab_source_note(md("Source: VRscores industry-year data"))



library(dplyr)
library(gt)
library(scales)
library(tidyr)

# --- Helper to compute top-10 nearest to 813110 for a given data frame ---
nearest_to_religion <- function(df, year_label) {
  ref <- df %>% filter(naics_code == "813110") %>%
    select(democrat_pct_imp, republican_pct_imp, political_diversity_imp)
  
  if (nrow(ref) == 0) {
    stop(paste0("NAICS 813110 (Religious Organizations) not found in ", year_label, " data."))
  }
  
  df %>%
    mutate(dist = sqrt(
      (democrat_pct_imp - ref$democrat_pct_imp)^2 +
        (republican_pct_imp - ref$republican_pct_imp)^2 +
        (political_diversity_imp - ref$political_diversity_imp)^2
    )) %>%
    filter(naics_code != "813110") %>%
    arrange(dist) %>%
    slice_head(n = 10) %>%
    mutate(rank = row_number())
}

# --- Build year-specific tables (wrap 2012 in try to avoid hard crash if 813110 missing) ---
sim24 <- nearest_to_religion(occ, "2024") %>%
  select(rank,
         naics_desc_2024 = naics_desc,
         dem_2024 = democrat_pct_imp,
         rep_2024 = republican_pct_imp,
         div_2024 = political_diversity_imp)

sim12 <- tryCatch(
  nearest_to_religion(occ12, "2012") %>%
    select(rank,
           naics_desc_2012 = naics_desc,
           dem_2012 = democrat_pct_imp,
           rep_2012 = republican_pct_imp,
           div_2012 = political_diversity_imp),
  error = function(e) {
    message(conditionMessage(e))
    # return empty tibble with needed cols so join still works
    tibble(rank = integer(), naics_desc_2012 = character(),
           dem_2012 = numeric(), rep_2012 = numeric(), div_2012 = numeric())
  }
)

# --- Side-by-side table (exactly 10 ranks if both years present) ---
sim_wide <- full_join(sim12, sim24, by = "rank") %>%
  arrange(rank)

# --- Pretty gt table ---
gt_tbl <- sim_wide %>%
  gt() %>%
  cols_label(
    rank = "Rank",
    naics_desc_2012 = "2012 — Industry",
    dem_2012 = "Dem %",
    rep_2012 = "Rep %",
    div_2012 = "Diversity",
    naics_desc_2024 = "2024 — Industry",
    dem_2024 = "Dem %",
    rep_2024 = "Rep %",
    div_2024 = "Diversity"
  ) %>%
  fmt_percent(columns = c(dem_2012, rep_2012, dem_2024, rep_2024), decimals = 0) %>%
  fmt_number(columns = c(div_2012, div_2024), decimals = 3) %>%
  tab_header(
    title = md("**Industries Most Similar to Religious Organizations (2012 vs 2024)**"),
    subtitle = md("Similarity based on Democratic %, Republican %, and Political Diversity")
  ) %>%
  tab_source_note(md("Source: VRscores industry-year data; similarity = Euclidean distance in (Dem %, Rep %, Diversity)."))

gt_tbl





nearest_to_religion_topN <- function(df, year_label, top_n = 100L, k = 10L) {
  ref <- df %>% filter(naics_code == "813110") %>%
    select(democrat_pct_imp, republican_pct_imp, political_diversity_imp)
  if (nrow(ref) == 0) stop(paste0("813110 missing in ", year_label))
  
  big <- df %>% arrange(desc(employee_count)) %>% slice_head(n = top_n)
  
  big %>%
    bind_rows(df %>% filter(naics_code == "813110")) %>% # ensure reference present
    distinct(naics_code, .keep_all = TRUE) %>%
    mutate(dist = sqrt(
      (democrat_pct_imp - ref$democrat_pct_imp)^2 +
        (republican_pct_imp - ref$republican_pct_imp)^2 +
        (political_diversity_imp - ref$political_diversity_imp)^2
    )) %>%
    filter(naics_code != "813110") %>%
    arrange(dist) %>%
    slice_head(n = k) %>%
    mutate(rank = row_number())
}

sim24_top <- nearest_to_religion_topN(occ,   "2024", top_n = 100, k = 10)
sim12_top <- nearest_to_religion_topN(occ12, "2012", top_n = 100, k = 10)


short_labels <- c(
  "Offices of Real Estate Appraisers" = "Real Estate Appraisers",
  "Engineering Services" = "Engineers",
  "Insurance Agencies and Brokerages" = "Insurance Brokers",
  "Search, Detection, Navigation, Guidance, Aeronautical, and Nautical System and Instrument Manufacturing" = "Aerospace Instruments",
  "Aircraft Manufacturing" = "Aircraft Manufacturing",
  "Aircraft Engine and Engine Parts Manufacturing" = "Aircraft Engines",
  "Mortgage and Nonmortgage Loan Brokers" = "Mortgage Brokers",
  "Offices of Real Estate Agents and Brokers" = "Real Estate Agents",
  "Automobile and Light Duty Motor Vehicle Manufacturing" = "Auto Manufacturing",
  "Used Car Dealers" = "Used Car Dealers",
  "Commercial and Institutional Building Construction" = "Commercial Construction",
  "Electrical Contractors and Other Wiring Installation Contractors" = "Electricians",
  "Real Estate Credit" = "Mortgage Lenders",
  "New Car Dealers" = "Car Dealers"
)

tbl <- tbl %>%
  mutate(across(contains("naics_desc"), ~ recode(., !!!short_labels, .default = .)))

library(gt)
library(scales)

gt_tbl <- tbl %>%
  gt() %>%
  opt_table_font(
    font = c(
      "Abel Regular", "Segoe UI",
      default_fonts()[-c(1:3)]
    )) %>% 
  cols_label(
    rank            = "Rank",
    naics_desc_2012 = "Industry",
    dem_2012        = "Dem %",
    rep_2012        = "Rep %",
    div_2012        = "Diversity",
    naics_desc_2024 = "Industry",
    dem_2024        = "Dem %",
    rep_2024        = "Rep %",
    div_2024        = "Diversity"
  ) %>%
  tab_spanner(label = "2012", columns = c(naics_desc_2012, dem_2012, rep_2012, div_2012)) %>%
  tab_spanner(label = "2024", columns = c(naics_desc_2024, dem_2024, rep_2024, div_2024)) %>%
  fmt_percent(columns = c(dem_2012, rep_2012, dem_2024, rep_2024), decimals = 0) %>%
  fmt_number(columns = c(div_2012, div_2024), decimals = 3) %>%
  data_color(columns = c(dem_2012, dem_2024),
             colors = col_numeric(c("#f7fbff", "#6baed6", "#2171b5"), domain = c(0,1))) %>%
  data_color(columns = c(rep_2012, rep_2024),
             colors = col_numeric(c("#fff5f0", "#fc9272", "#cb181d"), domain = c(0,1))) %>%
  data_color(columns = c(div_2012, div_2024),
             colors = col_numeric(c("#f7f7f7", "#969696", "#252525"),
                                  domain = range(c(tbl$div_2012, tbl$div_2024), na.rm = TRUE))) %>%
  cols_align(align = "left", columns = c(naics_desc_2012, naics_desc_2024)) %>%
  cols_width(
    rank ~ px(50),
    c(naics_desc_2012, naics_desc_2024) ~ px(200),
    c(dem_2012, rep_2012, div_2012, dem_2024, rep_2024, div_2024) ~ px(85)
  ) %>%
  tab_header(
    title = md("**Nearest Big-Industry Neighbors to Religious Organizations**"),
    subtitle = md("Similarity in (Dem %, Rep %, Diversity) among the top-N largest industries by employment")
  ) %>%
  tab_source_note(md("@ryanburge | Data: VRScores, 2012–2024")) %>%
  tab_options(
    table.width = px(900),
    data_row.padding = px(3),
    column_labels.padding = px(5),
    table.font.size = px(13),
    heading.align = "left"
  )


# Save
gtsave(gt_tbl, "E://graphs25/religion_neighbors_topN_gt.png",
       vwidth = 1600, vheight = 700)




top50 <- occ %>%
  arrange(desc(employee_count)) %>%
  slice_head(n = 50)


top50 <- top50 %>%
  mutate(
    rep_se = sqrt((republican_pct_imp * (1 - republican_pct_imp)) / employee_count),
    rep_low = republican_pct_imp - 1.96 * rep_se,
    rep_high = republican_pct_imp + 1.96 * rep_se
  )


library(ggplot2)
library(scales)


library(dplyr)

top50 <- top50 %>%
  mutate(industry_short = case_when(
    naics_desc == "Colleges, Universities, and Professional Schools" ~ "Colleges & Universities",
    naics_desc == "Software Publishers" ~ "Software Publishers",
    naics_desc == "Executive and Legislative Offices, Combined" ~ "Government Offices",
    naics_desc == "General Medical and Surgical Hospitals" ~ "Hospitals",
    naics_desc == "Commercial Banking" ~ "Commercial Banks",
    naics_desc == "Portfolio Management and Investment Advice" ~ "Investment Management",
    naics_desc == "Administration of Education Programs" ~ "Education Administration",
    naics_desc == "Other Computer Related Services" ~ "IT Services",
    naics_desc == "Offices of Real Estate Agents and Brokers" ~ "Real Estate Agents",
    naics_desc == "Offices of Lawyers" ~ "Law Offices",
    naics_desc == "Elementary and Secondary Schools" ~ "K–12 Schools",
    naics_desc == "Engineering Services" ~ "Engineers",
    naics_desc == "National Security" ~ "National Security",
    naics_desc == "Pharmaceutical Preparation Manufacturing" ~ "Pharmaceuticals",
    naics_desc == "All Other Miscellaneous Ambulatory Health Care Services" ~ "Ambulatory Health Care",
    naics_desc == "Offices of Physicians (except Mental Health Specialists)" ~ "Doctors’ Offices",
    naics_desc == "All Other General Merchandise Retailers" ~ "General Retail",
    naics_desc == "Freestanding Ambulatory Surgical and Emergency Centers" ~ "Surgery & Emergency Centers",
    naics_desc == "Administration of Public Health Programs" ~ "Public Health Administration",
    naics_desc == "Custom Computer Programming Services" ~ "Software Development",
    naics_desc == "Direct Health and Medical Insurance Carriers" ~ "Health Insurance",
    naics_desc == "Offices of Certified Public Accountants" ~ "Accounting Firms",
    naics_desc == "Insurance Agencies and Brokerages" ~ "Insurance Brokers",
    naics_desc == "Employment Placement Agencies" ~ "Staffing Agencies",
    naics_desc == "Home Health Care Services" ~ "Home Health Care",
    naics_desc == "Full-Service Restaurants" ~ "Full-Service Restaurants",
    naics_desc == "Clothing and Clothing Accessories Retailers" ~ "Clothing Retail",
    naics_desc == "Other Services Related to Advertising" ~ "Ad Support Services",
    naics_desc == "Other Direct Insurance (except Life, Health, and Medical) Carriers" ~ "Property Insurance",
    naics_desc == "Computing Infrastructure Providers, Data Processing, Web Hosting, and Related Services" ~ "Cloud & Hosting Services",
    naics_desc == "Hotels (except Casino Hotels) and Motels" ~ "Hotels & Motels",
    naics_desc == "Administrative Management and General Management Consulting Services" ~ "Management Consulting",
    naics_desc == "Other Management Consulting Services" ~ "Business Consulting",
    naics_desc == "Supermarkets and Other Grocery Retailers (except Convenience Retailers)" ~ "Grocery Stores",
    naics_desc == "Advertising Agencies" ~ "Advertising Agencies",
    naics_desc == "Limited-Service Restaurants" ~ "Fast-Food Restaurants",
    naics_desc == "Warehouse Clubs and Supercenters" ~ "Warehouse Stores",
    naics_desc == "Voluntary Health Organizations" ~ "Health Nonprofits",
    naics_desc == "Media Streaming Distribution Services, Social Networks, and Other Media Networks and Content Providers" ~ "Media & Streaming",
    naics_desc == "Offices of Real Estate Appraisers" ~ "Real Estate Appraisers",
    naics_desc == "Direct Property and Casualty Insurance Carriers" ~ "Property Insurance Carriers",
    naics_desc == "Legal Counsel and Prosecution" ~ "Legal Counsel",
    naics_desc == "Administration of Veterans Affairs" ~ "Veterans Affairs",
    naics_desc == "Commercial and Institutional Building Construction" ~ "Commercial Construction",
    naics_desc == "Web Search Portals and All Other Information Services" ~ "Internet Services",
    naics_desc == "Department Stores" ~ "Department Stores",
    naics_desc == "Wireless Telecommunications Carriers (except Satellite)" ~ "Wireless Carriers",
    naics_desc == "Surgical and Medical Instrument Manufacturing" ~ "Medical Equipment",
    naics_desc == "Miscellaneous Intermediation" ~ "Financial Intermediation",
    naics_desc == "Religious Organizations" ~ "Religious Organizations",
    TRUE ~ naics_desc
  ))


library(ggplot2)
library(scales)

top50 %>%
  mutate(naics_desc = fct_reorder(industry_short, republican_pct_imp)) %>%
  ggplot(aes(x = republican_pct_imp, y = naics_desc, color = republican_pct_imp)) +
  geom_point(size = 3) +
  scale_color_gradient2(
    low = "#2171b5", mid = "darkorchid", high = "#cb181d",
    midpoint = 0.3,  # center around 50%
    # limits = c(0.3, 0.7),  # optional: compress the range for visual clarity
    oob = scales::squish
  ) +
  scale_x_continuous(labels = percent_format(accuracy = 1)) +
  labs(
    x = "Republican %",
    y = NULL,
    title = "Estimated Republican Share by Industry",
    subtitle = "Among the 50 largest industries by employment",
    caption = "@ryanburge | Data: VRScores, 2024"
  ) +
  theme_rb() +
  theme(
    axis.text.y = element_text(size = 10),
    plot.title = element_text(face = "bold"),
    legend.position = "none"
  )

save("religion_top50_republican_ci.png", ht = 8, wd = 6)




emp <- read_csv("E://data/emp_panel24.csv")


religious_employers <- emp %>%
  mutate(name_clean = str_to_lower(company_name),
         name_clean = str_replace_all(name_clean, "[[:punct:]]", " "))



religious_terms <- c(
  # Core institutions
  "church", "synagogue", "mosque", "temple", "cathedral", "chapel",
  # Denominational tags
  "baptist", "catholic", "methodist", "lutheran", "presbyterian", "episcopal",
  "anglican", "orthodox", "pentecostal", "adventist", "mormon", "lds", "jesus christ",
  # Religious education / orgs
  "christian school", "christian academy", "christian university", "seminary",
  "bible college", "bible church", "bible camp", "bible institute", "faith academy",
  "religious", "ministry", "missions", "diocese", "archdiocese",
  # Jewish and Muslim orgs
  "islamic", "muslim", "jewish", "torah", "yeshiva", "chabad",
  # Saints and related terms
  "saint", "st\\.", "st ", "st-",  # allow various Saint formats
  # Other
  "unitarian", "universalist", "quaker", "mennonite", "amish"
)



religious_employers <- religious_employers %>%
  mutate(
    religious_flag = str_detect(name_clean, paste0("\\b(", paste(religious_terms, collapse="|"), ")\\b"))
  )


religious_employers %>%
  summarise(total = n(),
            religious = sum(religious_flag, na.rm = TRUE),
            pct = religious / total)


religious_employers <- religious_employers %>%
  mutate(
    religious_flag = religious_flag &
      !str_detect(name_clean, paste0(
        "\\b(county|city|state|public|corrections|hospital|clinic|health|construction|plumbing|consulting|university hospital)\\b"
      ))
  )


religious_employers %>%
  filter(religious_flag) %>%
  select(company_name) %>%
  slice_sample(n = 50)



religious_employers %>%
  mutate(group = if_else(religious_flag, "Religious Employers", "All Others")) %>%
  group_by(group) %>%
  summarise(
    mean_rep = mean(republican_pct_imp, na.rm = TRUE),
    mean_dem = mean(democrat_pct_imp, na.rm = TRUE),
    mean_margin = mean(overall_margin_imp, na.rm = TRUE),
    n = n()
  )

religious_employers %>%
  mutate(group = if_else(religious_flag, "Religious Employers", "All Others")) %>%
  group_by(group) %>%
  summarise(
    mean_margin = mean(overall_margin_imp, na.rm = TRUE),
    se         = sd(overall_margin_imp, na.rm = TRUE) / sqrt(n()),
    lower      = mean_margin - 1.96 * se,
    upper      = mean_margin + 1.96 * se,
    .groups = "drop"
  ) %>%
  ggplot(aes(x = group, y = mean_margin, fill = group)) +
  geom_col(color = "black") +
  geom_errorbar(aes(ymin = lower, ymax = upper), width = 0.10, color = "black") +
  geom_text(
    aes(
      label = percent(mean_margin, accuracy = 0.1),
      hjust = ifelse(mean_margin > 0, 1.65, -0.1)  # inside right for +, inside left for −
    ),
    color = "white", family = 'font', size = 12
  ) +
  coord_flip() +
  scale_fill_manual(values = c("All Others" = "dodgerblue", "Religious Employers" = "firebrick3")) +
  scale_y_continuous(labels = percent_format(accuracy = 1)) +
  labs(
    x = NULL, y = "Republican − Democratic Share",
    title = "Partisan Lean of Religious vs. Other Employers",
    caption = "@ryanburge | Data: VRScores 2024"
  ) +
  theme_rb() +
  theme(legend.position = "none")



save("rel_group_employee_compare.png", ht = 3)




religious_employers <- religious_employers %>%
  mutate(
    faith_type = case_when(
      str_detect(name_clean, "jewish|synagogue|temple|torah|chabad|yeshiva") ~ "Jewish",
      str_detect(name_clean, "islamic|muslim|mosque") ~ "Muslim",
      str_detect(name_clean, "catholic|christian|baptist|lutheran|methodist|presbyterian|episcopal|orthodox|pentecostal|adventist|mormon|church") ~ "Christian",
      TRUE ~ "Other/Unknown"
    )
  )


dat <- religious_employers %>%
  filter(religious_flag) %>%
  group_by(faith_type) %>%
  summarise(
    mean_margin = mean(overall_margin_imp, na.rm = TRUE),
    se   = sd(overall_margin_imp, na.rm = TRUE) / sqrt(n()),
    lower = mean_margin - 1.96 * se,
    upper = mean_margin + 1.96 * se,
    .groups = "drop"
  ) %>%
  mutate(
    label = percent(mean_margin, accuracy = 0.1),
    hjust_lab = if_else(mean_margin > 0, 1.1, -0.1)  # inside right for +, inside left for −
  )

ggplot(dat, aes(x = faith_type, y = mean_margin, fill = mean_margin)) +
  geom_col(color = "black") +
  geom_errorbar(aes(ymin = lower, ymax = upper), width = 0.2, color = "gray40") +
  geom_text(aes(label = label, hjust = hjust_lab),
            color = "black", family = "font", size = 9) +
  coord_flip() +
  scale_fill_gradient2(low = "#2166ac", mid = "white", high = "#b2182b", midpoint = 0) +
  scale_y_continuous(labels = percent_format(accuracy = 1)) +
  labs(
    x = NULL, y = "Republican − Democratic Share",
    title = "Partisan Lean of Religious Employers by Faith Type",
    caption = "@ryanburge | Data: VRScores 2024"
  ) +
  theme_rb() +
  theme(legend.position = "none")



save("emp_relig_type.png", ht = 4)




# only religious employers
protestant_counts <- religious_employers %>%
  filter(religious_flag, faith_type == "Christian") %>%
  mutate(
    denom = case_when(
      str_detect(name_clean, "baptist") ~ "Baptist",
      str_detect(name_clean, "methodist") ~ "Methodist",
      str_detect(name_clean, "lutheran") ~ "Lutheran",
      str_detect(name_clean, "presbyterian") ~ "Presbyterian",
      str_detect(name_clean, "episcopal|anglican") ~ "Episcopal/Anglican",
      str_detect(name_clean, "pentecostal|assembly of god|church of god") ~ "Pentecostal",
      str_detect(name_clean, "adventist") ~ "Adventist",
      str_detect(name_clean, "non.?denominational|community church|fellowship|evangelical") ~ "Non-Denominational",
      TRUE ~ "Other/Unknown"
    )
  ) %>%
  count(denom, sort = TRUE) %>%
  mutate(pct = n / sum(n))

protestant_counts




denom_margins <- religious_employers %>%
  filter(religious_flag, faith_type == "Christian") %>%
  mutate(
    denom = case_when(
      str_detect(name_clean, "baptist") ~ "Baptist",
      str_detect(name_clean, "methodist") ~ "Methodist",
      str_detect(name_clean, "lutheran") ~ "Lutheran",
      str_detect(name_clean, "presbyterian") ~ "Presbyterian",
      str_detect(name_clean, "episcopal|anglican") ~ "Episcopal/Anglican",
      str_detect(name_clean, "pentecostal|assembly of god|church of god") ~ "Pentecostal",
      str_detect(name_clean, "adventist") ~ "Adventist",
      str_detect(name_clean, "non.?denominational|community church|fellowship|evangelical") ~ "Non-Denominational",
      TRUE ~ "Other/Unknown"
    )
  ) %>%
  group_by(denom) %>%
  summarise(
    n = n(),
    mean_margin = mean(overall_margin_imp, na.rm = TRUE),
    se = sd(overall_margin_imp, na.rm = TRUE) / sqrt(n()),
    lower = mean_margin - 1.96 * se,
    upper = mean_margin + 1.96 * se,
    .groups = "drop"
  ) %>%
  arrange(mean_margin)

# ---- Plot ----
ggplot(denom_margins, aes(x = reorder(denom, mean_margin), y = mean_margin, fill = mean_margin)) +
  geom_col(color = "black") +
  geom_errorbar(aes(ymin = lower, ymax = upper), width = 0.15, color = "gray40") +
  geom_text(aes(label = percent(mean_margin, accuracy = 0.1)),
            hjust = ifelse(denom_margins$mean_margin > 0, 1.1, -0.1),
            color = "black", family = "font", size = 8) +
  coord_flip() +
  scale_fill_gradient2(
    low = "#2166ac", mid = "white", high = "#b2182b",
    midpoint = 0
  ) +
  scale_y_continuous(labels = percent_format(accuracy = 1)) +
  labs(
    x = NULL, y = "Republican − Democratic Share",
    title = "Partisan Lean by Protestant Denomination",
    subtitle = "Among religious employers identified as Christian",
    caption = "@ryanburge | Data: VRScores 2024"
  ) +
  theme_rb() 
save("protestant_denom_margin.png", ht = 5, wd = 7)




