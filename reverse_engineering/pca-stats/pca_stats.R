

pca <- read_csv("E://data/cleaned_pca_last_submitted.csv")

pca <- pca %>% filter(city != "NA")


# Calculate mean share of communicants across all churches
# Clean % communicant at church level (guard against 0 totals / bad values)
pca_clean <- pca %>%
  dplyr::mutate(pct = dplyr::if_else(total_mem > 0,
                                     comm / total_mem,
                                     NA_real_)) %>%
  dplyr::mutate(pct = dplyr::if_else(is.finite(pct), pct, NA_real_))

# Overall mean (ignores NA/Inf)
mean_comm <- mean(pca_clean$pct, na.rm = TRUE)


gg1 <- pca %>% 
  mutate(pct = comm / total_mem) %>% 
  select(church, pct) %>% 
  arrange(-pct) %>% 
  mutate(bins = frcode(
    pct <= .7 ~ "<70%", 
    pct > .7 & pct <= .8 ~ "70–80%", 
    pct > .8 & pct <= .9 ~ "80–90%", 
    pct > .9 & pct <= .99 ~ "90–99%", 
    pct == 1 ~ "100%"
  )) %>% 
  ct(bins, show_na = FALSE)

# --- Plot ---
gg1 %>%
  ggplot(aes(x = bins, y = pct, fill = bins)) +
  geom_col(color = "black") +
  theme_rb() + 
  y_pct() + 
  scale_fill_manual(
    values = c(
      "<70%"   = "#D73027",  # deep red
      "70–80%" = "#FC8D59",  # orange
      "80–90%" = "#FEE090",  # yellow
      "90–99%" = "#91BFDB",  # light blue
      "100%"   = "#4575B4"   # deep blue
    )
  ) +
  lab_bar(above = TRUE, pos = .015, sz = 9, type = pct) +
  labs(
    x = "",
    y = "",
    title = "The Share of All Members Who Are Communicant",
    caption = "@ryanburge\nData: PCA Annual Statistics",
    fill = ""
  ) +
  theme(legend.position = "none") +
  # Add mean value annotation in top right
  annotate(
    "text",
    x = Inf, y = Inf,
    label = paste0("Mean = ", scales::percent(mean_comm, accuracy = 1)),
    hjust = 3.25, vjust = 1.35,
    size = 7, family = "font", fontface = "bold"
  )

save("pca_communicant_percentages.png", wd = 5.25, ht = 6)






library(dplyr)
library(tidyr)
library(ggplot2)

# Clean and reshape
adds_comp <- pca %>%
  select(prof_child, prof_adult, trans_letter, reaffirmation, restored, total_adds) %>%
  filter(total_adds > 0) %>%
  mutate(across(c(prof_child, prof_adult, trans_letter, reaffirmation, restored),
                ~replace_na(., 0))) %>%
  mutate(
    prof_child     = prof_child / total_adds,
    prof_adult     = prof_adult / total_adds,
    trans_letter   = trans_letter / total_adds,
    reaffirmation  = reaffirmation / total_adds,
    restored       = restored / total_adds
  ) %>%
  summarise(across(prof_child:restored, mean, na.rm = TRUE)) %>%
  pivot_longer(everything(), names_to = "type", values_to = "pct")

# Make readable labels
adds_comp <- adds_comp %>%
  mutate(
    type = dplyr::recode(type,
                  prof_child    = "Profession of Faith (Child)",
                  prof_adult    = "Profession of Faith (Adult)",
                  trans_letter  = "Transfer of Letter",
                  reaffirmation = "Reaffirmation of Faith",
                  restored      = "Restored"
    )
  )

# --- Plot ---
adds_comp %>%
  ggplot(aes(x = reorder(type, pct), y = pct, fill = type)) +
  geom_col(color = "black") +
  coord_flip() +
  theme_rb() +
  y_pct() +
  scale_fill_manual(values = c(
    "Profession of Faith (Child)"  = "#7FB3D5",  # soft blue
    "Profession of Faith (Adult)"  = "#2874A6",  # deep blue
    "Transfer of Letter"           = "#52BE80",  # medium green
    "Reaffirmation of Faith"       = "#F7DC6F",  # gold
    "Restored"                     = "#CD6155"   # warm rose
  )) +
  labs(
    x = "",
    y = "",
    title = "Composition of Additions to PCA Church Membership",
    subtitle = "Share of total new additions by type of membership change",
    caption = "@ryanburge | Data: PCA Annual Statistics"
  ) +
  theme(legend.position = "none") +
  lab_bar(above = TRUE, pos = .02, sz = 9, type = pct)

save("pca_adds_composition.png", wd = 9, ht = 4)




library(dplyr)
library(tidyr)
library(ggplot2)
library(forcats)

# Build the composition by church-size category (2022+)
gg <- pca %>%
  filter(stat_year >= 2022, total_adds > 0) %>%
  mutate(
    mem_cat = cut(
      total_mem,
      breaks = c(0, 25, 50, 100, 250, 500, Inf),
      labels = c("1–25", "26–50", "51–100", "101–250", "251–500", "500+"),
      right = TRUE
    )
  ) %>%
  mutate(across(c(prof_child, prof_adult, trans_letter, reaffirmation, restored),
                ~ tidyr::replace_na(., 0))) %>%
  # convert each add type to a within-church share
  mutate(
    prof_child     = prof_child     / total_adds,
    prof_adult     = prof_adult     / total_adds,
    trans_letter   = trans_letter   / total_adds,
    reaffirmation  = reaffirmation  / total_adds,
    restored       = restored       / total_adds
  ) %>%
  # average the within-church shares inside each size bin
  group_by(mem_cat) %>%
  summarise(across(prof_child:restored, mean, na.rm = TRUE), .groups = "drop") %>%
  pivot_longer(prof_child:restored, names_to = "type", values_to = "pct") %>%
  mutate(
    type = dplyr::recode(type,
                  prof_child    = "Profession of Faith (Child)",
                  prof_adult    = "Profession of Faith (Adult)",
                  trans_letter  = "Transfer of Letter",
                  reaffirmation = "Reaffirmation of Faith",
                  restored      = "Restored"
    ),
    # keep your template's column names: faceting var = trad2, fill group = age2
    trad2 = mem_cat,
    age2  = type
  )

# ---- Plot in your template style ----
gg %>% 
  filter(trad2 != "NA") %>% 
  mutate(lab = round(pct, 2)) %>% 
  ggplot(aes(x = 1, y = pct, fill = fct_rev(age2))) +
  geom_col(color = "black") + 
  coord_flip() +
  facet_wrap(~ trad2, ncol = 1, strip.position = "left") +
  theme_rb() +
  scale_fill_manual(values = c(
    "Profession of Faith (Child)"  = "#7FB3D5",  # soft blue
    "Profession of Faith (Adult)"  = "#2874A6",  # deep blue
    "Transfer of Letter"           = "#52BE80",  # medium green
    "Reaffirmation of Faith"       = "#F7DC6F",  # gold
    "Restored"                     = "#CD6155"   # warm rose
  )) +
  theme(legend.position = "bottom") +
  scale_y_continuous(labels = scales::percent) +
  theme(strip.text.y.left = element_text(angle = 0)) +
  guides(fill = guide_legend(reverse = TRUE, nrow = 1)) +
  theme(axis.title.y = element_blank(),
        axis.text.y  = element_blank(),
        axis.ticks.y = element_blank(),
        panel.grid.minor.y = element_blank(),
        panel.grid.major.y = element_blank()) +
  # single readable label per segment (>5%)
  geom_text(aes(label = ifelse(pct > .05, paste0(lab * 100, "%"), "")),
            position = position_stack(vjust = 0.5),
            size = 8, family = "font", color = "black") +
  theme(plot.title = element_text(size = 16)) +
  theme(strip.text.y.left = element_text(angle = 0, hjust = 1)) +
  labs(
    x = "", y = "",
    title   = "How New Members Join PCA Churches, by Congregation Size",
    caption = "@ryanburge | Data: PCA Annual Statistics",
    fill    = "Addition Type"
  )

save("pca_adds_by_size_template.png", wd = 9, ht = 5.5)



loss_comp <- pca %>%
  filter(stat_year >= 2022, total_loss > 0) %>%
  mutate(across(c(death, trans, remv_fr_roll, discipl), ~as.numeric(.))) %>%
  mutate(across(c(death, trans, remv_fr_roll, discipl), ~replace_na(., 0))) %>%
  mutate(
    death         = death / total_loss,
    trans         = trans / total_loss,
    remv_fr_roll  = remv_fr_roll / total_loss,
    discipl       = discipl / total_loss
  ) %>%
  summarise(across(death:discipl, mean, na.rm = TRUE)) %>%
  pivot_longer(death:discipl, names_to = "type", values_to = "pct") %>%
  mutate(
    type = dplyr::recode(type,
                  death         = "Death",
                  trans         = "Transfer",
                  remv_fr_roll  = "Removed from Roll",
                  discipl       = "Discipline"
    )
  )

# ---- Overall composition bar ----
loss_comp %>%
  ggplot(aes(x = reorder(type, pct), y = pct, fill = type)) +
  geom_col(color = "black") +
  coord_flip() +
  theme_rb() +
  scale_y_continuous(labels = scales::percent, limits = c(0, .425)) +
  scale_fill_manual(values = c(
    "Death"             = "#496D89",  # slate blue
    "Transfer"          = "#80B1D3",  # light blue
    "Removed from Roll" = "#F4B183",  # warm tan
    "Discipline"        = "#D95F02"   # burnt orange
  )) +
  labs(
    x = "",
    y = "",
    title = "Composition of Membership Losses in PCA Churches",
    caption = "@ryanburge | Data: PCA Annual Statistics",
    fill = "Loss Type"
  ) +
  theme(legend.position = "none") +
  geom_text(aes(label = scales::percent(pct, accuracy = 1)),
            hjust = -0.1, size = 8, family = "font") 

save("pca_losses_overall.png", wd = 9, ht = 4)



gg <- pca %>%
  filter(stat_year >= 2022, total_loss > 0) %>%
  mutate(across(c(death, trans, remv_fr_roll, discipl), ~as.numeric(.))) %>%
  mutate(across(c(death, trans, remv_fr_roll, discipl), ~replace_na(., 0))) %>%
  mutate(
    mem_cat = cut(
      total_mem,
      breaks = c(0, 25, 50, 100, 250, 500, Inf),
      labels = c("1–25", "26–50", "51–100", "101–250", "251–500", "500+"),
      right = TRUE
    )
  ) %>%
  mutate(
    death         = death / total_loss,
    trans         = trans / total_loss,
    remv_fr_roll  = remv_fr_roll / total_loss,
    discipl       = discipl / total_loss
  ) %>%
  group_by(mem_cat) %>%
  summarise(across(death:discipl, mean, na.rm = TRUE)) %>%
  pivot_longer(death:discipl, names_to = "type", values_to = "pct") %>%
  mutate(
    type = dplyr::recode(type,
                  death         = "Death",
                  trans         = "Transfer",
                  remv_fr_roll  = "Removed from Roll",
                  discipl       = "Discipline"
    ),
    trad2 = mem_cat,
    age2  = type
  )

# ---- Plot (template style) ----
gg %>% 
  filter(trad2 != "NA") %>% 
  mutate(lab = round(pct, 2)) %>% 
  ggplot(aes(x = 1, y = pct, fill = fct_rev(age2))) +
  geom_col(color = "black") + 
  coord_flip() +
  facet_wrap(~ trad2, ncol = 1, strip.position = "left") +
  theme_rb() +
  scale_fill_manual(values = c(
    "Death"             = "#496D89",  # slate blue
    "Transfer"          = "#80B1D3",  # light blue
    "Removed from Roll" = "#F4B183",  # tan
    "Discipline"        = "#D95F02"   # orange
  )) +
  theme(legend.position = "bottom") +
  scale_y_continuous(labels = scales::percent) +
  theme(strip.text.y.left = element_text(angle = 0)) +
  guides(fill = guide_legend(reverse = TRUE, nrow = 1)) +
  theme(axis.title.y = element_blank(),
        axis.text.y  = element_blank(),
        axis.ticks.y = element_blank(),
        panel.grid.minor.y = element_blank(),
        panel.grid.major.y = element_blank()) +
  geom_text(aes(label = ifelse(pct > .05, paste0(lab * 100, "%"), "")),
            position = position_stack(vjust = 0.5),
            size = 8, family = "font", color = "black") +
  geom_text(aes(label = ifelse(age2 == "Death" & pct > .05, paste0(lab * 100, "%"), "")),
            position = position_stack(vjust = 0.5),
            size = 8, family = "font", color = "white") +
  theme(plot.title = element_text(size = 16)) +
  theme(strip.text.y.left = element_text(angle = 0, hjust = 1)) +
  labs(
    x = "", y = "",
    title   = "How PCA Members Are Lost, by Congregation Size",
    caption = "@ryanburge | Data: PCA Annual Statistics",
    fill    = "Loss Type"
  )

save("pca_losses_by_size_template.png", wd = 9, ht = 5.5)

pca %>% 
  ct(est_morn_attend)


att_bins_collapsed <- att_bins %>%
  mutate(
    bin4 = case_when(
      attend_bin %in% c("≤25%", "26–50%")      ~ "≤50%",
      attend_bin %in% c("51–75%")              ~ "51–75%",
      attend_bin %in% c("76–100%")             ~ "76–100%",
      attend_bin %in% c("101–125%", "125%+")   ~ "Over 100%"
    )
  ) %>%
  group_by(bin4) %>%
  summarise(
    n = sum(n, na.rm = TRUE),
    pct = sum(pct, na.rm = TRUE),
    .groups = "drop"
  ) %>%
  mutate(bin4 = factor(bin4, levels = c("≤50%", "51–75%", "76–100%", "Over 100%")))

att_bins_collapsed



mean_attend_share <- pca %>%
  filter(!is.na(total_mem), total_mem > 0, !is.na(est_morn_attend)) %>%
  mutate(attend_share = est_morn_attend / total_mem) %>%
  filter(is.finite(attend_share), attend_share <= 2) %>%  # drop absurd ratios
  summarise(mean_share = mean(attend_share, na.rm = TRUE)) %>%
  pull(mean_share)

mean_attend_share



att_bins_collapsed %>%
  mutate(lab = round(pct, 2)) %>%
  ggplot(aes(x = fct_rev(bin4), y = pct, fill = bin4)) +
  geom_col(color = "black") +
  coord_flip() +
  theme_rb() +
  scale_y_continuous(labels = scales::percent, limits = c(0, .45)) +
  scale_fill_manual(values = c(
    "≤50%"      = "#C7C7A6",  # sage gray
    "51–75%"    = "#9DC3C2",  # light teal
    "76–100%"   = "#6699B0",  # slate blue
    "Over 100%" = "#446E9B"   # deep blue-gray
  )) +
  geom_text(
    aes(label = paste0(round(pct * 100, 0), "%")),
    hjust = -0.21, size = 9, family = "font"
  ) +
  theme(legend.position = "none") +
  labs(
    x = "",
    y = "",
    title = "Estimated Sunday Attendance as a Share of PCA Membership",
    subtitle = paste0(
      "Average attendance across all churches: ",
      scales::percent(mean_attend_share, accuracy = 0.1)
    ),
    caption = "@ryanburge | Data: PCA Annual Statistics"
  )

save("pca_attendance_share_bins_collapsed.png", wd = 8, ht = 3.5)



# --- Mean attendance share by size bin ---
mean_by_size <- pca %>%
  filter(stat_year >= 2022, !is.na(total_mem), total_mem > 0, !is.na(est_morn_attend)) %>%
  mutate(
    mem_cat = cut(
      total_mem,
      breaks = c(0, 25, 50, 100, 250, 500, Inf),
      labels = c("1–25", "26–50", "51–100", "101–250", "251–500", "500+"),
      right = TRUE
    ),
    attend_share = est_morn_attend / total_mem
  ) %>%
  filter(is.finite(attend_share), attend_share <= 2) %>%  # trim obvious outliers
  group_by(mem_cat) %>%
  summarise(mean_share = mean(attend_share, na.rm = TRUE), .groups = "drop") %>%
  mutate(mem_cat = fct_relevel(mem_cat, "1–25","26–50","51–100","101–250","251–500","500+"))

# --- Plot ---
mean_by_size %>%
  ggplot(aes(x = mem_cat, y = mean_share, fill = mem_cat)) +
  geom_col(color = "black") +
  theme_rb() +
  scale_y_continuous(labels = percent, limits = c(0, 1.1)) +
  scale_fill_manual(values = c(
    "1–25"   = "#D0D5DC",
    "26–50"  = "#C1CDD7",
    "51–100" = "#B2C5D2",
    "101–250"= "#9ABACF",
    "251–500"= "#5E93A1",
    "500+"   = "#2F5D62"
  )) +
  geom_text(aes(label = scales::percent(mean_share, accuracy = 0.1)),
            vjust = -0.5, size = 4.5, family = "font") +
  theme(legend.position = "none",
        plot.title = element_text(size = 14), 
        panel.grid.minor.x = element_blank(),
        panel.grid.major.x = element_blank()) +
  labs(
    x = "Church Membership Size",
    y = "",
    title = "Average Sunday Attendance as a Share of Membership",
    caption = "@ryanburge | Data: PCA Annual Statistics"
  )

save("pca_mean_attendance_share_by_size.png", wd = 5, ht = 5)


# --- Prep data ---
elders_deacons <- pca %>%
  filter(stat_year >= 2022,
         !is.na(total_mem),
         total_mem > 0,
         !is.na(ruling_elders),
         !is.na(deacons)) %>%
  mutate(
    mem_cat = cut(
      total_mem,
      breaks = c(0, 25, 50, 100, 250, 500, Inf),
      labels = c("1–25", "26–50", "51–100", "101–250", "251–500", "500+"),
      right = TRUE
    )
  ) %>%
  group_by(mem_cat) %>%
  summarise(
    mean_elders  = mean(ruling_elders, na.rm = TRUE),
    mean_deacons = mean(deacons, na.rm = TRUE),
    .groups = "drop"
  ) %>%
  mutate(
    total = mean_elders + mean_deacons
  ) %>%
  tidyr::pivot_longer(
    cols = c(mean_elders, mean_deacons),
    names_to = "role",
    values_to = "mean_count"
  ) %>%
  mutate(
    role = dplyr::recode(role,
                  mean_elders  = "Ruling Elders",
                  mean_deacons = "Deacons"),
    mem_cat = fct_relevel(mem_cat, "1–25", "26–50", "51–100",
                          "101–250", "251–500", "500+")
  )

# --- Compute totals per size bin for labeling ---
# ensure same factor order for mem_cat
totals_by_size <- totals_by_size %>%
  dplyr::mutate(mem_cat = forcats::fct_relevel(
    mem_cat, "1–25","26–50","51–100","101–250","251–500","500+"
  ))


elders_deacons %>%
  ggplot(aes(x = mem_cat, y = mean_count, fill = role)) +
  geom_col(color = "black") +
  coord_flip() +
  theme_rb() +
  scale_y_continuous(expand = expansion(mult = c(0, 0.15))) +
  scale_fill_manual(values = c(
    "Ruling Elders" = "#6BAED6",   # medium blue
    "Deacons"       = "#74C476"    # soft green
  )) +
  
  # Labels inside bars for larger congregations
  geom_text(
    data = elders_deacons %>% filter(mem_cat %in% c("101–250", "251–500", "500+")),
    aes(label = round(mean_count, 1)),
    position = position_stack(vjust = 0.5),
    color = "white",
    size = 5.5,
    family = "font",
    fontface = "bold"
  ) +
  
  # Total labels to the right of bars
  geom_text(
    data = totals_by_size,
    mapping = aes(x = mem_cat, y = total, label = round(total, 1)),
    inherit.aes = FALSE,
    hjust = -0.3,
    size = 5.5,
    family = "font",
    fontface = "bold",
    color = "#333333"
  ) +
  
  theme(
    legend.position = "bottom",
    panel.grid.minor.y = element_blank(),
    panel.grid.major.y = element_blank()
  ) +
  labs(
    x = "",
    y = "Average Number of Officers",
    fill = "",
    title = "Average Number of Ruling Elders and Deacons by Congregation Size",
    caption = "@ryanburge | Data: PCA Annual Statistics"
  )

save("pca_elders_deacons_by_size_flipped_labels.png", wd = 7, ht = 4)


officer_ratio <- pca %>%
  filter(!is.na(total_mem), total_mem > 0) %>%
  mutate(total_officers = ruling_elders + deacons) %>%
  filter(total_officers > 0) %>%
  summarise(
    mean_ratio = mean(total_mem / total_officers, na.rm = TRUE)
  )

officer_ratio

officer_ratio_by_size <- pca %>%
  filter(!is.na(total_mem), total_mem > 0) %>%
  mutate(total_officers = ruling_elders + deacons) %>%
  filter(total_officers > 0) %>%
  mutate(
    mem_cat = cut(
      total_mem,
      breaks = c(0, 25, 50, 100, 250, 500, Inf),
      labels = c("1–25", "26–50", "51–100", "101–250", "251–500", "500+")
    )
  ) %>%
  group_by(mem_cat) %>%
  summarise(avg_members_per_officer = mean(total_mem / total_officers, na.rm = TRUE))


officer_ratio_by_size %>%
  ggplot(aes(x = mem_cat, y = avg_members_per_officer)) +
  geom_point(size = 4, color = "#4575B4") +
  geom_line(group = 1, color = "#4575B4", linewidth = 1.2) +
  theme_rb() +
  labs(
    x = "Church Membership Size",
    y = "Average Members per Officer",
    title = "Officer-to-Member Ratio by Congregation Size",
    caption = "@ryanburge | Data: PCA Annual Statistics"
  ) +
  geom_text(
    aes(label = round(avg_members_per_officer, 1)),
    vjust = -0.75,
    family = "font",
    size = 5
  ) +
  ylim(0, 40)

save("pca_officer_ratio_by_size.png", wd = 7, ht = 4)

pca %>%
  mutate(has_building_fund = !is.na(building_fund_offering) & building_fund_offering > 0) %>%
  summarise(
    n_all = n(),
    n_with_fund = sum(has_building_fund),
    pct_of_all = n_with_fund / n_all,  # denominator = ALL churches (1,735)
    n_reporting = sum(!is.na(building_fund_offering)),
    pct_among_reporting = n_with_fund / n_reporting  # denominator = 878 reporting
  )

566/1735 ## 33% of churches have a building fund. 




pca %>%
  mutate(
    net_change = total_adds - total_loss,
    growth_cat = frcode(
      net_change < 0 ~ "Declining",
      net_change == 0 ~ "Stable",
      net_change > 0 ~ "Growing"
    ),
    has_building_fund = !is.na(building_fund_offering) & building_fund_offering > 0
  ) %>%
  filter(!is.na(growth_cat)) %>% 
  group_by(growth_cat) %>%
  summarise(
    pct_with_fund = mean(has_building_fund, na.rm = TRUE),
    n = n()
  ) %>%
  mutate(
    pct_label = scales::percent(pct_with_fund, accuracy = 0.1),
    growth_cat = fct_relevel(growth_cat, "Declining", "Stable", "Growing")
  ) %>%
  ggplot(aes(x = growth_cat, y = pct_with_fund, fill = growth_cat)) +
  geom_col(color = "black") +
  geom_text(
    aes(label = pct_label),
    vjust = -0.25,
    size = 8,
    family = "font"
  ) +
  theme_rb() +
  scale_y_continuous(labels = scales::percent_format(), limits = c(0, 0.5)) +
  scale_fill_manual(values = c(
    "Declining" = "#F4A582",  # warm orange
    "Stable"    = "#BDBDBD",  # gray
    "Growing"   = "#92C5DE"   # light blue
  )) +
  labs(
    x = "",
    y = "Share with Building Fund",
    title = "Share of PCA Churches with a Building Fund by Growth Category",
    subtitle = "Note: 33% of all churches have a building fund",
    caption = "@ryanburge | Data: PCA Annual Statistics\n"
  ) +
  theme(legend.position = "none") +
  theme(plot.title = element_text(size = 15))

save("pca_building_fund_by_growth.png", wd = 6, ht = 5)





breaks_fixed2 <- c(0, 1000, 2000, 3000, 4000, 5000, 7000, Inf)
labels_fixed2 <- c(
  "$0–$999", "$1,000–$1,999", "$2,000–$2,999",
  "$3,000–$3,999", "$4,000–$4,999", "$5,000–$6,999", "$7,000+"
)

giving_bins_fixed2 <- pca %>%
  filter(!is.na(per_capita_giving), per_capita_giving >= 0) %>%
  mutate(
    bin = cut(per_capita_giving,
              breaks = breaks_fixed2,
              labels = labels_fixed2,
              include.lowest = TRUE,
              right = FALSE)  # [a,b)
  ) %>%
  count(bin, name = "n") %>%
  mutate(
    pct = n / sum(n),
    bin = fct_rev(bin)
  )






giving_bins_fixed2 %>%
  ggplot(aes(x = bin, y = pct, fill = bin)) +
  geom_col(color = "black") +
  coord_flip() +
  theme_rb() +
  scale_y_continuous(labels = percent_format(accuracy = 1)) +
  scale_fill_manual(values = c(
    "$0–$999"        = "#D0D5DC",
    "$1,000–$1,999"  = "#B6C9D3",
    "$2,000–$2,999"  = "#A9C3CD",
    "$3,000–$3,999"  = "#9CBCD0",
    "$4,000–$4,999"  = "#8FB5C9",
    "$5,000–$6,999"  = "#6E97AE",
    "$7,000+"        = "#2F5D62"
  )) +
  lab_bar(above = TRUE, pos = .02, sz = 10, type = pct) +
  theme(legend.position = "none") +
  labs(
    x = "",
    y = "",
    title = "Per-Capita Giving Among PCA Congregations",
    caption = "@ryanburge | Data: PCA Annual Statistics"
  )

save("pca_per_capita_giving_bins_fixed2.png", wd = 8, ht = 5)



cap <- quantile(pca$per_capita_giving, 0.99, na.rm = TRUE)

pca_clean <- pca %>%
  mutate(per_capita_giving = ifelse(per_capita_giving > cap, cap, per_capita_giving))


pca_giving_by_size <- pca_clean %>%
  filter(per_capita_giving > 0, total_mem > 0) %>%
  mutate(
    mem_cat = frcode(
      total_mem <= 25 ~ "1–25",
      total_mem <= 50 ~ "26–50",
      total_mem <= 100 ~ "51–100",
      total_mem <= 250 ~ "101–250",
      total_mem <= 500 ~ "251–500",
      total_mem > 500 ~ "500+"
    )
  ) %>%
  group_by(mem_cat) %>%
  mean_ci(per_capita_giving, ci = .84)


# ---- Plot ----
pca_giving_by_size %>%
  ggplot(aes(x = mem_cat, y = mean)) +
  geom_col(fill = "#74A9CF", color = "black") +
  geom_errorbar(aes(ymin = lower, ymax = upper), width = 0.2, linewidth = 0.8) +
  geom_text(
    aes(y = 700, label = scales::dollar(round(mean, 0))),
    size = 9, family = "font", fontface = "bold"
  ) +
  theme_rb() +
  scale_y_continuous(labels = scales::dollar, expand = expansion(mult = c(0, 0.1))) +
  labs(
    x = "",
    y = "Mean Per-Capita Giving ($)",
    title = "Mean Per-Capita Giving by Congregation Size",
    caption = "@ryanburge | Data: PCA Annual Statistics"
  )

save("pca_mean_percapita_giving_by_size.png", wd = 8, ht = 5)


pca %>%
  filter(!is.na(per_capita_giving), per_capita_giving > 0,
         !is.na(total_mem), total_mem > 0) %>%
  filter(per_capita_giving < 30000) %>% 
  mean_ci(per_capita_giving, ci = .84)

## $3700 is the average giving per capita (removing outliers)





library(scales)

pca <- pca %>%
  mutate(region = frcode(
    st %in% c("ME", "NH", "VT", "MA", "RI", "CT", "NY", "NJ", "PA") ~ "Northeast",
    st %in% c("OH", "IN", "IL", "MI", "WI", "MN", "IA", "MO") ~ "Midwest",
    st %in% c("DE", "MD", "DC", "VA", "WV", "NC", "SC", "GA", "FL", "AL", "MS", "TN", "KY") ~ "South",
    st %in% c("AR", "LA", "TX", "OK", "NM", "AZ") ~ "Southwest",
    st %in% c("ND", "SD", "NE", "KS", "MT", "WY", "CO", "UT", "ID") ~ "Mountain West",
    st %in% c("WA", "OR", "CA", "NV", "HI", "AK") ~ "Pacific",
    st %in% c("AB", "BC", "NB", "NS", "ON") ~ "Canada",
    TRUE ~ "Other"
  ))


library(ggrepel)


pca %>%
  filter(!region %in% c("Other", "Canada")) %>%
  group_by(region) %>%
  mutate(cutoff = quantile(total_mem, 0.98, na.rm = TRUE)) %>%
  filter(total_mem <= cutoff) %>%
  group_by(region) %>%
  mean_ci(total_mem, ci = 0.84) %>%
  mutate(
    region = fct_reorder(region, mean),
    lab = round(mean, 0)
  ) %>%
  ggplot(aes(x = region, y = mean, fill = region)) +
  geom_col(color = "black") +
  geom_errorbar(
    aes(ymin = lower, ymax = upper),
    width = 0.3, linewidth = 0.8
  ) +
  geom_text(
    aes(label = lab),
    vjust = -0.4, size = 5, family = "font"
  ) +
  theme_rb() +
  coord_flip() +
  scale_y_continuous(labels = scales::comma_format()) +
  scale_fill_manual(values = c(
    "Northeast"     = "#9ECAE1",
    "Midwest"       = "#6BAED6",
    "South"         = "#3182BD",
    "Southwest"     = "#31A354",
    "Mountain West" = "#74C476",
    "Pacific"       = "#FD8D3C"
  )) +
  labs(
    x = "",
    y = "Average Membership (Outliers Trimmed)",
    title = "Average PCA Church Membership by Region (Top 2% Removed)",
    subtitle = "Error bars show 84% confidence intervals; outliers removed within each region",
    caption = "@ryanburge | Data: PCA Annual Statistics"
  ) +
  theme(legend.position = "none")

save("pca_avg_membership_by_region_trimmed.png", wd = 8, ht = 5)


pca %>%
  filter(!region %in% c("Other", "Canada")) %>%
  group_by(region) %>%
  summarise(
    median = median(total_mem, na.rm = TRUE),
    q1 = quantile(total_mem, 0.25, na.rm = TRUE),
    q3 = quantile(total_mem, 0.75, na.rm = TRUE),
    n = n(),
    .groups = "drop"
  ) %>%
  mutate(
    region = fct_reorder(region, median),
    lab = round(median, 0)
  ) %>%
  ggplot(aes(x = region, y = median, fill = region)) +
  geom_col(color = "black") +
  geom_text(
    aes(y = median + 10, label = lab), size = 11, family = "font"
  ) +
  theme_rb() +
  coord_flip() +
  scale_y_continuous(labels = scales::comma_format()) +
  scale_fill_manual(values = c(
    "Northeast"     = "#9ECAE1",
    "Midwest"       = "#6BAED6",
    "South"         = "#3182BD",
    "Southwest"     = "#31A354",
    "Mountain West" = "#74C476",
    "Pacific"       = "#FD8D3C"
  )) +
  labs(
    x = "",
    y = "Median Membership",
    title = "Median PCA Church Membership by Region",
    caption = "@ryanburge | Data: PCA Annual Statistics"
  ) +
  theme(legend.position = "none")

save("pca_median_membership_by_region.png", wd = 8, ht = 5)





library(gt)

table <- pca %>%
  filter(!is.na(total_mem)) %>%
  arrange(desc(total_mem)) %>%
  select(church, city, st, pastor, total_mem) %>%
  slice_head(n = 10) %>%
  gt() %>%
  opt_table_font(
    font = c("Abel Regular", "Segoe UI", default_fonts()[-c(1:3)])
  ) %>%
  fmt_number(
    columns = total_mem,
    decimals = 0,
    use_seps = TRUE
  ) %>%
  cols_label(
    church = "Church Name",
    city = "City",
    st = "State",
    pastor = "Pastor", 
    total_mem = "Total Membership"
  ) %>%
  tab_header(
    title = md("**Ten Largest PCA Churches**"),
    subtitle = md("Based on reported total membership in latest PCA Annual Statistics")
  ) %>%
  tab_source_note(
    source_note = md("@ryanburge | Data: PCA Annual Statistics")
  ) %>%
  tab_options(
    table.width = pct(80),
    heading.align = "left",
    column_labels.font.weight = "bold"
  )


gtsave(table, "E://graphs25/largest_pca_churches.png")



# ----- 1) Build expense share (allowing >100% if running a deficit) -----
pca_exp <- pca %>%
  filter(!is.na(total_church_income), total_church_income > 0,
         !is.na(current_expenses), current_expenses >= 0) %>%
  mutate(exp_share = current_expenses / total_church_income)

# ----- 2) Overall mean + CI -----
overall <- pca_exp %>%
  mean_ci(exp_share, ci = .84) %>%
  mutate(mem_cat = factor("All Churches", levels = "All Churches"))

# ----- 3) By size bin (ordered via frcode) -----
by_size <- pca_exp %>%
  mutate(
    mem_cat = frcode(
      total_mem <= 25  ~ "1–25",
      total_mem <= 50  ~ "26–50",
      total_mem <= 100 ~ "51–100",
      total_mem <= 250 ~ "101–250",
      total_mem <= 500 ~ "251–500",
      total_mem > 500  ~ "500+"
    )
  ) %>%
  group_by(mem_cat) %>%
  mean_ci(exp_share, ci = .84) %>%
  ungroup()

# ----- 4) Combine & plot -----
exp_shares <- bind_rows(overall, by_size) %>% filter(mem_cat != 'NA')

exp_shares %>%
  filter(!is.na(mem_cat)) %>%
  mutate(
    lab = percent(mean, accuracy = 0.1),
    text_color = ifelse(mem_cat == "500+", "white", "black")
  ) %>%
  ggplot(aes(x = fct_rev(mem_cat), y = mean, fill = mem_cat)) +
  geom_col(color = "black") +
  geom_errorbar(aes(ymin = lower, ymax = upper), width = 0.25, linewidth = 0.8) +
  geom_text(
    aes(y = .10, label = lab, color = text_color),
    size = 8, family = "font", fontface = "bold", show.legend = FALSE
  ) +
  scale_color_identity() +
  coord_flip() +
  theme_rb() +
  scale_y_continuous(labels = percent_format(accuracy = 1), limits = c(0, 1.3)) +
  scale_fill_manual(values = c(
    "All Churches" = "#D0D5DC",
    "1–25"   = "#B9C7D3",
    "26–50"  = "#A8BECD",
    "51–100" = "#97B6C7",
    "101–250"= "#86ADC1",
    "251–500"= "#6E97AE",
    "500+"   = "#2F5D62"
  )) +
  labs(
    x = "",
    y = "Share of Income Spent on Expenses",
    title = "Expenses as a Share of Total Income (Overall and by Congregation Size)",
    caption = "@ryanburge | Data: PCA Annual Statistics"
  ) +
  theme(legend.position = "none")

save("pca_expense_share_overall_and_by_size_fixed.png", wd = 9, ht = 6)





pca %>%
  summarise(
    median = median(total_mem, na.rm = TRUE),
    q1 = quantile(total_mem, 0.25, na.rm = TRUE),
    q3 = quantile(total_mem, 0.75, na.rm = TRUE),
    n = n(),
    .groups = "drop"
  ) %>%
  mutate(
    region = fct_reorder(region, median),
    lab = round(median, 0)
  ) %>%
  ggplot(aes(x = region, y = median, fill = region)) +
  geom_col(color = "black") +
  geom_text(
    aes(y = median + 10, label = lab), size = 11, family = "font"
  ) +
  theme_rb() +
  coord_flip() +
  scale_y_continuous(labels = scales::comma_format()) +
  scale_fill_manual(values = c(
    "Northeast"     = "#9ECAE1",
    "Midwest"       = "#6BAED6",
    "South"         = "#3182BD",
    "Southwest"     = "#31A354",
    "Mountain West" = "#74C476",
    "Pacific"       = "#FD8D3C"
  )) +
  labs(
    x = "",
    y = "Median Membership",
    title = "Median PCA Church Membership by Region",
    caption = "@ryanburge | Data: PCA Annual Statistics"
  ) +
  theme(legend.position = "none")

save("pca_median_membership_by_region.png", wd = 8, ht = 5)






library(scales)

pca <- pca %>%
  mutate(region = frcode(
    st %in% c("ME", "NH", "VT", "MA", "RI", "CT", "NY", "NJ", "PA") ~ "Northeast",
    st %in% c("OH", "IN", "IL", "MI", "WI", "MN", "IA", "MO") ~ "Midwest",
    st %in% c("DE", "MD", "DC", "VA", "WV", "NC", "SC", "GA", "FL", "AL", "MS", "TN", "KY") ~ "South",
    st %in% c("AR", "LA", "TX", "OK", "NM", "AZ") ~ "Southwest",
    st %in% c("ND", "SD", "NE", "KS", "MT", "WY", "CO", "UT", "ID") ~ "Mountain West",
    st %in% c("WA", "OR", "CA", "NV", "HI", "AK") ~ "Pacific",
    st %in% c("AB", "BC", "NB", "NS", "ON") ~ "Canada",
    TRUE ~ "Other"
  ))


library(ggrepel)


pca %>%
  filter(!is.na(total_mem), !is.na(total_church_income)) %>%
  filter(total_church_income > 0) %>%
  filter(
    total_mem < quantile(total_mem, 0.99, na.rm = TRUE),
    total_church_income < quantile(total_church_income, 0.99, na.rm = TRUE)
  ) %>%
  mutate(label = paste0(church, "\n", city, ", ", st)) %>%
  ggplot(aes(x = total_mem, y = total_church_income, color = region)) +
  geom_point(alpha = 1) +
  geom_text_repel(
    data = . %>% filter(total_church_income > 7500000),
    aes(label = label),
    size = 5, family = "font", color = "black", box.padding = 0.3, max.overlaps = Inf
  ) +
  geom_text_repel(
    data = . %>% filter(total_church_income < 5000000 & total_mem > 1500),
    aes(label = label),
    size = 4, family = "font", color = "black", box.padding = 0.3, max.overlaps = Inf
  ) +
  scale_color_brewer(palette = "Set2") +
  geom_smooth(se = FALSE, method = "lm", color = "black", linewidth = .5, linetype = "twodash") +
  scale_y_continuous(labels = label_dollar(scale = 1e-6, suffix = "M")) +
  theme_rb(legend = TRUE) +
  labs(
    x = "Total Membership",
    y = "Total Church Income",
    title = "Relationship Between Membership and Church Income (PCA)",
    caption = "@ryanburge\nData: PCA Annual Statistics"
  )

save("pca_mem_vs_income.png", ht = 10, wd = 10)



model <- pca %>%
  filter(!is.na(total_mem), !is.na(total_church_income)) %>%
  filter(total_church_income > 0) %>%
  filter(
    total_mem < quantile(total_mem, 0.99, na.rm = TRUE),
    total_church_income < quantile(total_church_income, 0.99, na.rm = TRUE)
  ) %>%
  lm(total_church_income ~ total_mem, data = .)


summary(model)