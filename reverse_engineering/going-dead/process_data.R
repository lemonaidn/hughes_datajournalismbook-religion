library(tidyverse)

cces24 <- read_csv("cces24.csv")

denom_map <- list(
  baptist = c(
    `1` = "Southern Baptist", `2` = "ABCUSA", `3` = "Natl. Baptist Convention",
    `4` = "Progressive Baptist Convention", `5` = "Independent Baptist",
    `6` = "Baptist General Conference", `7` = "Baptist Miss. Association",
    `8` = "Conservative Bapt. Association", `9` = "Free Will Baptist",
    `10` = "Gen. Assoc. of Reg. Bapt.", `90` = "Other Baptist"
  ),
  methodist = c(
    `1` = "United Methodist", `2` = "Free Methodist",
    `3` = "African Methodist Episcopal", `4` = "AME - Zion",
    `5` = "Christian Methodist Episcopal", `90` = "Other Methodist"
  ),
  nondenom = c(
    `1` = "Nondenom Evangelical", `2` = "Nondenom Fundamentalist",
    `3` = "Nondenom Charismatic", `4` = "Interdenominational",
    `5` = "Community Church", `90` = "Other Nondenom"
  ),
  lutheran = c(
    `1` = "ELCA", `2` = "Lutheran - Missouri Synod",
    `3` = "Lutheran - Wisconsin Synod", `4` = "Other Lutheran"
  ),
  presbyterian = c(
    `1` = "PCUSA", `2` = "PCA", `3` = "Associated Reformed Presbyterian",
    `4` = "Cumberland Presbyterian", `5` = "Orthodox Presbyterian",
    `6` = "Evangelical Presbyterian", `90` = "Other Presbyterian"
  ),
  pentecostal = c(
    `1` = "Assemblies of God", `2` = "Church of God Cleveland TN",
    `3` = "Four Square Gospel", `4` = "Pentecostal Church of God",
    `5` = "Pentecostal Holiness Church", `6` = "Church of God in Christ",
    `7` = "Church of God of the Apostolic Faith",
    `8` = "Assembly of Christian Churches", `9` = "Apostolic Christian",
    `90` = "Other Pentecostal"
  ),
  episcopal = c(
    `1` = "TEC", `2` = "Church of England",
    `3` = "Anglican Orthodox", `4` = "Reformed Episcopal",
    `90` = "Other Episcopal"
  ),
  christian = c(
    `1` = "Church of Christ", `2` = "Disciples of Christ",
    `3` = "Christian Church", `90` = "Other Christian Church"
  ),
  congregational = c(
    `1` = "United Church of Christ", `2` = "Conservative Cong. Christian",
    `3` = "National Assoc. of Cons. Cong.", `90` = "Other Cong."
  ),
  holiness = c(
    `1` = "Church of the Nazarene", `2` = "Wesleyan Church",
    `4` = "Christian and Missionary Alliance", `5` = "Church of God",
    `6` = "Salvation Army"
  ),
  reformed = c(
    `1` = "Reformed Church in America", `2` = "Christian Reformed",
    `90` = "Other Reformed"
  ),
  adventist = c(
    `1` = "Seventh Day Adventist"
  )
)

denom_cols <- names(denom_map)

cces_long <- cces24 %>%
  pivot_longer(
    cols = all_of(denom_cols),
    names_to = "denom_col",
    values_to = "denom_code"
  ) %>%
  filter(!is.na(denom_code)) %>%
  mutate(
    trad = map2_chr(denom_col, denom_code, function(col, code) {
      mapping <- denom_map[[col]]
      label <- mapping[as.character(code)]
      if (is.na(label)) NA_character_ else label
    }),
    age = year - birthyr
  ) %>%
  filter(!is.na(trad), age >= 18, age <= 100) %>%
  select(year, birthyr, age, weight, trad)

write_csv(cces_long, "cces24_long.csv")

cat("Rows written:", nrow(cces_long), "\n")
cat("Denominations:", n_distinct(cces_long$trad), "\n")
print(sort(unique(cces_long$trad)))
