# NAICS-Year Panel Codebook

*Generated:* 2025-10-31T01:02:49.059219Z
*Years covered:* 2012-2024

## Coverage Summary
| Year | Rows | File |
| --- | ---: | --- |
| 2012 | 1,010 | `naics_panel_year_2012.parquet` |
| 2013 | 1,010 | `naics_panel_year_2013.parquet` |
| 2014 | 1,010 | `naics_panel_year_2014.parquet` |
| 2015 | 1,010 | `naics_panel_year_2015.parquet` |
| 2016 | 1,011 | `naics_panel_year_2016.parquet` |
| 2017 | 1,011 | `naics_panel_year_2017.parquet` |
| 2018 | 1,011 | `naics_panel_year_2018.parquet` |
| 2019 | 1,011 | `naics_panel_year_2019.parquet` |
| 2020 | 1,010 | `naics_panel_year_2020.parquet` |
| 2021 | 1,010 | `naics_panel_year_2021.parquet` |
| 2022 | 1,010 | `naics_panel_year_2022.parquet` |
| 2023 | 1,010 | `naics_panel_year_2023.parquet` |
| 2024 | 1,011 | `naics_panel_year_2024.parquet` |
| **Total** | **13,135** | |

## Variable Dictionary
| Column | Type | Description |
| --- | --- | --- |
| `naics_code` | string | Primary NAICS code. |
| `naics_desc` | string | Text description for the NAICS code. |
| `employee_count` | integer | Number of unique workers in the NAICS-year group (minimum 5). |
| `dem_workers_raw` | float | Workers with Democratic affiliation based solely on L2 voter registrations (raw counts). |
| `rep_workers_raw` | float | Workers with Republican affiliation based solely on L2 voter registrations (raw counts). |
| `other_workers_raw` | float | Matched workers whose L2 record is neither Democratic nor Republican (raw counts). |
| `party_known_workers_raw` | float | Workers with any L2 party assignment (Democratic, Republican, or other). |
| `dem_workers_imp` | float | Imputed Democratic worker count (we are able to impute most, but not all, independents/unknown). |
| `rep_workers_imp` | float | Imputed Republican worker count (we are able to impute most, but not all, independents/unknown). |
| `other_workers_imp` | float | Workers who are not registered Democrat or Republican and for whom we could not confidently impute partisanship (`max(employee_count - dem_workers_imp - rep_workers_imp, 0)`). |
| `avg_match_quality` | float | Average match quality across all matched workers (higher is a higher probability match). |
| `democrat_pct_raw` | float | Democratic share using raw L2 counts (`dem_workers_raw / employee_count`). |
| `republican_pct_raw` | float | Republican share using raw L2 counts. |
| `nonpartisan_pct_raw` | float | Nonpartisan share using raw L2 counts. |
| `democrat_pct_two_party_raw` | float | Democratic share among two-party workers from raw L2 counts (`dem_workers_raw / (dem_workers_raw + rep_workers_raw)`). |
| `republican_pct_two_party_raw` | float | Republican share among two-party workers from raw L2 counts (`rep_workers_raw / (dem_workers_raw + rep_workers_raw)`). |
| `two_party_margin_raw` | float | Republican minus Democratic share among two-party workers (raw L2 counts; `(rep_workers_raw - dem_workers_raw) / (dem_workers_raw + rep_workers_raw)`). |
| `overall_margin_raw` | float | Republican minus Democratic share of the full workforce (raw L2 counts; `(rep_workers_raw - dem_workers_raw) / employee_count`). |
| `democrat_pct_imp` | float | Democratic share after imputing independents/unknown (`dem_workers_imp / employee_count`; registered partisans remain unchanged). |
| `republican_pct_imp` | float | Republican share after imputing independents/unknown (`rep_workers_imp / employee_count`; registered partisans remain unchanged). |
| `nonpartisan_pct_imp` | float | Nonpartisan share after imputing independents/unknown (`other_workers_imp / employee_count`). |
| `democrat_pct_two_party_imp` | float | Democratic share among imputed two-party workers (`dem_workers_imp / (dem_workers_imp + rep_workers_imp)`; imputations only affect independents/unknown). |
| `republican_pct_two_party_imp` | float | Republican share among imputed two-party workers (`rep_workers_imp / (dem_workers_imp + rep_workers_imp)`; imputations only affect independents/unknown). |
| `two_party_margin_imp` | float | Imputed two-party margin (`(rep_workers_imp - dem_workers_imp) / (dem_workers_imp + rep_workers_imp)`). |
| `overall_margin_imp` | float | Imputed overall margin (`(rep_workers_imp - dem_workers_imp) / employee_count`). |
| `political_diversity_raw` | float | One minus the sum of squared raw partisan shares (1 - ∑pᵢ²); higher values indicate more partisan diversity. |
| `political_diversity_imp` | float | One minus the sum of squared imputed partisan shares (1 - ∑pᵢ²); higher values indicate more partisan diversity. |
| `effective_parties_raw` | float | Effective number of parties based on raw shares (inverse Herfindahl index). |
| `effective_parties_imp` | float | Effective number of parties based on imputed shares (inverse Herfindahl index). |
| `latest_processed_at` | string | ISO 8601 timestamp indicating when the NAICS-year was last processed. |

## Citation

If you use this dataset, please cite both:
1. Kagan, Max; Frake, Justin; Hurst, Reuben (2025). “VRscores: A New Measure and Dataset of Workforce Politics Using Voter Registrations.” SSRN Working Paper No. 5104795. https://ssrn.com/abstract=5104795
2. Frake, Justin; Hurst, Reuben; Kagan, Max (2025). “Political Segregation in the US Workplace.” SSRN Working Paper No. 4639165. https://ssrn.com/abstract=4639165 or http://dx.doi.org/10.2139/ssrn.4639165
